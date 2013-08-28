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
}

backend drupallive {    
  .host = "drupallive.gbif.org";    
  .port = "80";   
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

backend drupalstaging {    
  .host = "130.226.238.148";    
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

backend ecatdev {
  .host = "130.226.238.144";
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

  # keep original URL in custom header, see http://dev.gbif.org/issues/browse/GBIFCOM-137
  set req.http.x-url = "http://" + req.http.host + req.url;
  
  # first check for uat PORTAL subdomain
  if (req.http.host == "uat.gbif.org" || req.http.host == "portaldev.gbif.org") {
    # default to java apps
    if (req.http.host == "uat.gbif.org") {
      set req.backend = jawa;
    } else {
      set req.backend = staging;
    }
    
    # the registry console
    # TODO: this only exposes the html, but the vital css & js files are not exposed yet as they clash with the portal path. 
    # Maybe not needed to expose in UAT at all?
    if ( req.url ~ "^/console" ) {
      # the console is not public - only GBIFS can access it!
      if (!client.ip ~ GBIFS) {
        error 403 "Not allowed, this page is private to the GBIF Secretariat";
      }
      set req.url = regsub(req.url, "^/console", "/registry2-ws/web/index.html");
      # dont cache any console files
      return (pass);
    }

    # catch known java app paths
    if ( req.url ~ "^/(dataset|occurrence|species|member|node|network|publisher|developer|country|cfg|css|fonts|img|js|favicon)" || (req.url ~ "^/user/(downloads|namelist|cancel)")) {
      set req.url = regsub(req.url, "^/", "/portal/");

    } else {
      # pass to drupal for the rest
      if (req.http.host == "uat.gbif.org") {
        set req.http.host="drupallive.gbif.org";
        set req.backend = drupallive;
      } else {
        set req.http.host="staging.gbif.org";
        set req.backend = drupalstaging;
      }
    }

    # PORTAL - ONLY CACHE STATIC FILES !!!
    if ( req.url ~ "^/(cfg|css|fonts|img|js|favicon|sites|misc|modules)" ) {
      return (lookup);
    } else {
      return (pass);
    }


  #
  # ONLY WEBSERVICE CALLS IF WE REACH HERE !!!
  #
  } else if (req.http.host == "api.gbif.org") {
    set req.backend = jawa;

  } else if (req.http.host == "apidev.gbif.org" 
    || req.http.host == "apidev1.gbif.org" 
    || req.http.host == "apidev2.gbif.org" 
    || req.http.host == "apidev3.gbif.org" 
    || req.http.host == "apidev4.gbif.org" 
    || req.http.host ~ "^localhost") {
    set req.backend = staging;

  } else {
    error 404 "Unknown host";
  }

  if ( req.url ~ "^/favicon.ico") {
    error 404 "Not found";
  }
  
  if (req.url ~ "^/lookup/name_usage"){
    if (req.http.host == "apidev.gbif.org") {
      set req.backend = ecatdev;
      set req.url = regsub(req.url, "^/lookup/name_usage", "/nub-ws/nub");
    } else {
      set req.backend = boma;
      set req.url = regsub(req.url, "^/lookup/name_usage", "/ws-nub/nub");
    }
  
  } else if (req.url ~ "^/lookup/reverse_geocode"){
    set req.backend = boma;
    set req.url = regsub(req.url, "^/lookup/reverse_geocode", "/geocode-ws/reverse");

  } else if ( req.url ~ "^/name_usage/(search|suggest)") {
      set req.url = regsub(req.url, "^/name_usage/", "/checklistbank-search-ws/");
  
  } else if ( req.url ~ "^/(name_usage|dataset_metrics|description|name_list)" ) {
    set req.url = regsub(req.url, "^/", "/checklistbank-ws/");
  
  } else if ( req.url ~ "^/map") {
    set req.url = regsub(req.url, "^/map", "/tile-server");
  
  } else if ( req.url ~ "^/occurrence/(count|counts|datasets|countries|publishing_countries)") {
    set req.url = regsub(req.url, "^/", "/metrics-ws/");
  
  } else if ( req.url ~ "^/occurrence/download") {
    set req.url = regsub(req.url, "^/", "/occurrence-download-ws/");
    # not cache any download response, for this new downloads should evict the cache which is not the case
    return (pass);
  
  } else if ( req.url ~ "^/occurrence") {
    set req.url = regsub(req.url, "^/", "/occurrence-ws/");
  
  } else if ( req.url ~ "^/dataset/metrics") {
    # not existing yet for all datasets - use checklist service for now
    set req.url = regsub(req.url, "^/dataset/metrics", "/checklistbank-ws/dataset_metrics");
  
  } else if ( req.url ~ "^/dataset/process") {
    set req.url = regsub(req.url, "^/", "/crawler-ws/");
  
  } else if ( req.url ~ "^/image") {
    set req.url = regsub(req.url, "^/image", "/image-cache/");
  
  } else if (req.url !~ "^/web") {
    # anything left should be registry calls - BUT do not expose the console in the API!
    set req.url = regsub(req.url, "^/", "/registry2-ws/");
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
 
  # remove portal context from redirects
  if ( beresp.status == 302 && beresp.http.Location ~ "/portal/" ) {
    set beresp.http.Location = regsub(beresp.http.Location, "/portal/", "/");
  }
 
  # dont cache redirects or errors - especially for staging errors can be temporary only
  if ( beresp.status >= 300 ) {
    return (hit_for_pass);
  }
  
  # cache metrics only for a very short time
  if ( req.url ~ "^/metrics-ws") {
    set beresp.ttl = 60s;
    # do not cache quickly changing count metrics
    if ( req.url ~ "count") {
      return (hit_for_pass);
    }
  } else {
    # cache for 30 days
    set beresp.ttl = 2592000s;
  }

  return (deliver);
}
