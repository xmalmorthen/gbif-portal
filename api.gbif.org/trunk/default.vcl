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

backend drupaldev {    
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
  if (req.http.host ~ "^(uat|portaldev).gbif.org") {
    # remove trailing slash
    set req.url = regsub(req.url, "(.)/$", "\1");
    # default to java apps
    if (req.http.host == "uat.gbif.org") {
      set req.backend = jawa;
    } else {
      set req.backend = staging;
    }
    
    # remove all cookies if no drupal session is set - we configured varnish to only cache pages without any cookie!
    if (req.http.Cookie) {
      set req.http.x-cookie = req.http.Cookie;
      if (!req.http.Cookie ~ "(^| )SESS[0-9abcdef]+") {
        remove req.http.Cookie;
      }
    }

    # catch known java app paths
    if ( req.url ~ "^/(dataset|occurrence|species|member|node/|network/|publisher|developer|country|cfg|css|fonts|img|js|favicon|participation/list)" || (req.url ~ "^/user/(downloads|namelist|cancel)")) {
      set req.url = regsub(req.url, "^/", "/portal/");

    } else {
      # pass to drupal for the rest
      if (req.http.host == "uat.gbif.org") {
        set req.http.host="drupallive.gbif.org";
        set req.backend = drupallive;
      } else {
        set req.http.host="drupaldev.gbif.org";
        set req.backend = drupaldev;
      }
    }

    # dont cache requests with session cookies
    if (req.http.Cookie || req.request != "GET") {
      return (pass);
    }
    return (lookup);


  #
  # ONLY WEBSERVICE CALLS IF WE REACH HERE !!!
  #
  } else if (req.http.host == "api.gbif.org") {
    set req.backend = jawa;

  } else if (req.http.host == "apidev.gbif.org" 
    || req.http.host ~ "^localhost") {
    set req.backend = staging;

  } else {
    error 404 "Unknown host";
  }

  if ( req.url ~ "^/favicon.ico") {
    error 404 "Not found";
  }
  
  # temporary redirect for name_usage URLs
  if (req.url ~ "/name_usage"){
    error 301 regsub(req.url, "/name_usage", "/species");
  }
  
  # druapl powered webservices
  if (req.url ~ "^/mendeley"){
    if (req.http.host == "uat.gbif.org") {
      set req.http.host="drupallive.gbif.org";
      set req.backend = drupallive;
    } else {
      set req.http.host="drupaldev.gbif.org";
      set req.backend = drupaldev;
    }
    # expose http://staging.gbif.org/mendeley/country/ES/json
    set req.url = regsub(req.url, "^/mendeley/country/([a-zA-Z]+)$", "/mendeley/country/\1/json");
    return (lookup);
  }

  if (req.url ~ "^/lookup/species"){
    set req.backend = ecatdev;
    set req.url = regsub(req.url, "^/lookup/species", "/nub-ws/nub");
    # BOMA runs an old nublookup, but is intended to host the uat version in the future
    # if (req.http.host == "apidev.gbif.org") {
    #   set req.backend = boma;
    #   set req.url = regsub(req.url, "^/lookup/species", "/ws-nub/nub");
    # }
  
  } else if (req.url ~ "^/lookup/reverse_geocode"){
    set req.backend = boma;
    set req.url = regsub(req.url, "^/lookup/reverse_geocode", "/geocode-ws/reverse");

  } else if ( req.url ~ "^/species/(search|suggest)") {
      set req.url = regsub(req.url, "^/species/", "/checklistbank-search-ws/");
  
  } else if ( req.url ~ "^/(species|dataset_metrics|description|name_list)" ) {
    set req.url = regsub(req.url, "^/", "/checklistbank-ws/");
  
  } else if ( req.url ~ "^/map") {
    set req.url = regsub(req.url, "^/map", "/tile-server");
  
  } else if ( req.url ~ "^/occurrence/(count|counts|datasets|countries|publishing_countries)") {
    set req.url = regsub(req.url, "^/", "/metrics-ws/");
  
  } else if ( req.url ~ "^/occurrence/download/request") {
    set req.url = regsub(req.url, "^/", "/occurrence-download-ws/");
    # not cache any download response
    return (pass);

  } else if ( req.url ~ "^/occurrence/download") {
    set req.url = regsub(req.url, "^/", "/registry2-ws/");
    # not cache any download response
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
  # dont cache put, post or delete
  if((bereq.request == "PUT" || bereq.request == "POST" || bereq.request == "DELETE")) {
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
  
  # cache metrics andmap tiles for a minute
  if ( req.url ~ "^/(metrics-ws|tile-server)") {
    set beresp.ttl = 60s;
    # cache quickly changing count metrics for 10 seconds only
    if ( req.url ~ "count") {
      set beresp.ttl = 10s;
    }
  } else if( req.url ~ "^/(cfg|css|fonts|img|js|favicon|sites|misc|modules)" ) {
    # cache static files for 10 days 10*60s*60*24
    set beresp.ttl = 864000s;
  } else if( req.url ~ "^/([a-z0-9-]+-ws)" ) {
    # cache json for a week 7*60s*60*24
    set beresp.ttl = 604800s;
  } else {
    # cache all the rest for 10 minutes as default
    # includes tile-server, image-cache, non personalized drupal pages & portal html
    set beresp.ttl = 600s;
  }

  return (deliver);
}


sub vcl_error {
  if (obj.status == 301) {
    set obj.http.Location = obj.response;
    set obj.status = 301;
    return(deliver);
  }
}
