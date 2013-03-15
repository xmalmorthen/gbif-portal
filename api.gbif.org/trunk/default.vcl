backend jawa {    
  .host = "130.226.238.239";       
  .port = "8080";   
  .connect_timeout = 60s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 60s;  
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

acl purge {
  "localhost";
  "192.38.28.0"/25;
  "130.226.238.128"/25;
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
    if (!client.ip ~ purge) {
      error 403 "Forbidden.";
    } else {
      purge_url(req.url);
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

  # API
  # first check API versions
  } else if ( req.url ~ "^/dev/") {
    set req.backend = staging;
    set req.url = regsub(req.url, "^/dev/", "/");

  } else if (req.url ~ "^/uat/") {
    set req.backend = jawa;
    set req.url = regsub(req.url, "^/uat/", "/");

  } else {
    error 404 "API version not existing";
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
      set req.backend = staging;
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

    } else {
      # anything left should be registry calls
      set req.url = regsub(req.url, "^/", "/registry-ws/");
    }
  }

  return (lookup);
}


sub vcl_fetch {
  # dont cache successful put, post,delete
  if((bereq.request == "PUT" || bereq.request == "POST" || bereq.request == "DELETE") && (beresp.status < 400)) {
    return (pass);
    #vcl3 return (hit_for_pass);
  }
  
  # dont cache redirects or errors - especially for staging errors can be temporary only
  if ( beresp.status >= 300 ) {
    return (pass);
    #vcl3 return (hit_for_pass);
  }
  
  # do not cache changing metrics
  if ( req.url ~ "^/metrics-ws") {
    return (pass);
  }  

  # cache for 2 days
  set beresp.ttl = 48h;
  return (deliver);
}
