# TR: Removing this to experiment with more aggressively discarding 
# stale connections below
# backend jawa {    
#  .host = "130.226.238.239";       
#  .port = "8080";   
#  .connect_timeout = 60s;
#  .first_byte_timeout = 60s;
#  .between_bytes_timeout = 60s;  
#}

# The tomcat backend serving the portal application and web services
# Timeouts are aggressive to encourage Varnish to discard stale connections
# The backend is never marked as bad (saintmode = 0)
# Polling is added only for heartbeating, to keep connections open (just in case)
backend jawa {
  .host = "130.226.238.239";
  .port = "8080";
  .connect_timeout = 1s;
  # this is insanely long because of slow species and dataset pages
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 5s;
  # never discard a backend
  .saintmode_threshold = 0;
  # don't overload tomcat (it has 100 connection pool)
  .max_connections = 75;
  # probe the backend to keep connections open
  .probe = {
    .url = "/registry-ws/dataset?limit=1";
    .timeout = 5s;
    .interval = 60s;
    # 9/10 polls must succeed for the backend to be considered alive
    .window = 10;
    .threshold = 10;
  }
}

backend drupal {    
  .host = "drupallive.gbif.org";    
  .port = "80";   
  .connect_timeout = 60s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 60s;  
}

backend boma {
  .host = "192.38.28.83";    
  .port = "8080";   
  .connect_timeout = 60s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 60s; 
}

backend staging {
  .host = "130.226.238.148";    
  .port = "8080";   
  .connect_timeout = 60s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 60s; 
}

acl GBIFS {
    "localhost";
    "192.38.28.0"/25; 
    "130.226.238.128"/25;
    "10.66.77.0"/16;
    "192.168.0.0"/24;
}

sub vcl_recv {
  if (req.request == "PURGE") {
    if (!client.ip ~ GBIFS) {
      error 403 "Forbidden.";
    } else {
      ban_url(req.url);
      error 200 "Purged.";
    }
  }

  # first check for uat portal subdomain
  if (req.http.host == "uat.gbif.org") {
    # the portal is not yet public - only GBIFS can access it!
    if (!client.ip ~ GBIFS) {
      error 403 "Not allowed, this page is private to the GBIF Secretariat";
    }
    # is this a webservice call which should go to api.gbif.org?
    if ( req.url ~ "^/[a-z-]-ws" ) {
      error 404 "GBIF Webservices are hosted at http://api.gbif.org/uat";
    }
    # is this a user struts url? This is the only user page not served by drupal
    if ( req.url ~ "^/user/downloads") {
      set req.backend = jawa;

    # any known drupal path?
    } else if ( req.url ~ "^/(user|newsroom|page|sites|misc|modules)" || req.url ~ "^/?$") {
      set req.http.host="drupallive.gbif.org";
      set req.backend = drupal;

    } else {
      set req.backend = jawa;
    }

    # PORTAL - ONLY CACHE STATIC FILES !!!
    if ( req.url ~ "^/(img|js|css|fonts|sites|misc|modules)" ) {
      return (lookup);
    } else {
      return (pass);
    }

  # API UAT
  # first check API versions
  } else if (req.http.host == "api.gbif.org") {
    set req.backend = jawa;

  } else if (req.http.host == "apidev.gbif.org") {
    set req.backend = staging;

  } else {
    error 404 "Unknown host";
  }

  if ( req.url ~ "^/favicon.ico") {
    error 404 "Not found";
  }
  
  if (req.url ~ "^/lookup/"){
    set req.backend = boma;
    if (req.url ~ "^/lookup/name_usage"){
      set req.url = regsub(req.url, "^/lookup/name_usage", "/ws-nub/nub");
    } else if (req.url ~ "^/lookup/reverse_geocode"){
      set req.url = regsub(req.url, "^/lookup/reverse_geocode", "/geocode-ws/reverse");
    }

  } else {
    if ( req.url ~ "^/name_usage/(search|suggest)") {
      set req.url = regsub(req.url, "^/name_usage/", "/checklistbank-search-ws/");

    } else if ( req.url ~ "^/(name_usage|dataset_metrics|description|name_list)" ) {
      set req.url = regsub(req.url, "^/", "/checklistbank-ws/");

    } else if ( req.url ~ "^/map") {
      set req.url = regsub(req.url, "^/map", "/tile-server");

    } else if ( req.url ~ "^/occurrence/(count|datasets)") {
      set req.url = regsub(req.url, "^/", "/metrics-ws/");

    } else if ( req.url ~ "^/occurrence/download") {
      set req.url = regsub(req.url, "^/", "/occurrence-download-ws/");

    } else if ( req.url ~ "^/occurrence") {
      set req.url = regsub(req.url, "^/", "/occurrence-ws/");

    } else if ( req.url ~ "^/dataset/metrics") {
      # not existing yet for all datasets - use checklist service for now
      set req.url = regsub(req.url, "^/dataset/metrics", "/checklistbank-ws/dataset_metrics");

    } else if ( req.url ~ "^/dataset/process") {
      set req.url = regsub(req.url, "^/", "/crawler-ws/");

    } else if ( req.url ~ "^/dataset/(search|suggest)") {
      set req.url = regsub(req.url, "^/dataset/", "/registry-search-ws/");

    } else if ( req.url ~ "^/image") {
      set req.url = regsub(req.url, "^/image", "/image-cache/");

    } else {
      # anything left should be registry calls
      set req.url = regsub(req.url, "^/", "/registry-ws/");
    }
  }

  # apparently varnish tries to cache POST requests by converting them to GETs :(
  # https://www.varnish-cache.org/forum/topic/235
  # we therefore make sure we only cache GET requests
  if ( req.request == "GET") {
    return (lookup);
  } else {
    return(pass);
  }
}


sub vcl_fetch {
  # dont cache successful put, post,delete
  if((bereq.request == "PUT" || bereq.request == "POST" || bereq.request == "DELETE") && (beresp.status < 400)) {
    return (hit_for_pass);
  }
  
  # dont cache redirects or errors - especially for staging errors can be temporary only
  if ( beresp.status >= 300 ) {
    return (hit_for_pass);
  }
  
  # do not cache changing metrics
  if ( req.url ~ "^/metrics-ws") {
    return (hit_for_pass);
  }  

  # cache for 2 days
  #set beresp.ttl = 172800s;
  # cache for 30 days
  set beresp.ttl = 2592000s;
  return (deliver);
}
