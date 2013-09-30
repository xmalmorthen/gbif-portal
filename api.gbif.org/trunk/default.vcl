# The tomcat backend serving the portal application and web services
# Timeouts are aggressive to encourage Varnish to discard stale connections
# The backend is never marked as bad (saintmode = 0)
# Polling is added only for heartbeating, to keep connections open (just in case)
backend tomcat {
#  .host = "jawa.gbif.org";
  .host = "staging.gbif.org";    
  .port = "8080";
  .connect_timeout = 1s;
  .first_byte_timeout = 10s;
  .between_bytes_timeout = 5s;
  # never discard a backend
  .saintmode_threshold = 0;
  # don't overload tomcat (it has 100 connection pool)
  .max_connections = 75;
}

backend drupal {    
#  .host = "drupallive.gbif.org";    
  .host = "drupaldev.gbif.org";    
  .port = "80";   
  .connect_timeout = 2s;
  .first_byte_timeout = 10s;
  .between_bytes_timeout = 10s;  
}

backend geocode {
  .host = "boma.gbif.org";    
  .port = "8080";   
  .connect_timeout = 60s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 60s; 
}

backend nublookup {
  .host = "ecat-dev.gbif.org";
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
  
  # remove whatever host we got, as varnish adds the backend hostname if none exists in the request
  remove req.http.host;

  # is this a frontend or webservice request?
  if (req.http.host ~ "^api") {
    call recv_ws;
  } else {
    call recv_portal;
  }
}

sub recv_ws {
  # remove cookies in weird case they exist
  remove req.http.Cookie;

  if ( req.url ~ "^/favicon.ico") {
    error 404 "Not found";
  }
  
  # temporary redirect for name_usage URLs
  if (req.url ~ "/name_usage"){
    error 301 regsub(req.url, "/name_usage", "/species");
  }

  # default to tomcat backend
  set req.backend = tomcat;

  # drupal powered webservices
  if (req.url ~ "^/mendeley"){
    set req.backend = drupal;
    set req.url = regsub(req.url, "^/mendeley/country/([a-zA-Z]+)$", "/mendeley/country/\1/json");

  # nub lookup
  } else if (req.url ~ "^/lookup/species"){
    set req.backend = nublookup;
    set req.url = regsub(req.url, "^/lookup/species", "/nub-ws/nub");
  
  # geocode
  } else if (req.url ~ "^/lookup/reverse_geocode"){
    set req.backend = geocode;
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
    # anything left should be registry calls
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

# subroutine dealing with any frontend call to either
# struts or drupal
sub recv_portal {
  # remove trailing slash if exists
  set req.url = regsub(req.url, "(.)/$", "\1");
  
  # remove all cookies if no drupal session is set - we configured varnish to only cache pages without any cookie!
  if (req.http.Cookie) {
    set req.http.x-cookie = req.http.Cookie;
    if (!req.http.Cookie ~ "(^| )SESS[0-9abcdef]+") {
      remove req.http.Cookie;
    }
  }

  # catch known struts paths
  if ( req.url ~ "^/(dataset|occurrence|species|member|node/|network/|ipt|publisher|developer|country|cfg|css|fonts|img|js|favicon|participation/list|infrastructure)" || (req.url ~ "^/user/(downloads|namelist|cancel)")) {
    set req.url = regsub(req.url, "^/", "/portal/");
    set req.backend = tomcat;

  } else {
    set req.backend = drupal;
  }

  # only cache GET requests without a session cookies
  if (req.http.Cookie || req.request != "GET") {
    return (pass);
  }
  return (lookup);
}

sub vcl_fetch {
  # remove portal context from redirects
  if ( beresp.status == 302 && beresp.http.Location ~ "/portal/" ) {
    set beresp.http.Location = regsub(beresp.http.Location, "/portal/", "/");
  }
  
  # remove no cache headers. 
  # Cache-Control: mag-age takes precendence over Last-Modified or ETags:
  # https://www.varnish-cache.org/trac/wiki/VCLExampleLongerCaching
  # http://stackoverflow.com/questions/6451137/etag-attribute-present-but-no-cache-control-present-in-http-header
  # http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html
  remove beresp.http.Cache-Control;
  remove beresp.http.expires;
    
  # dont cache put, post or delete
  if((bereq.request == "PUT" || bereq.request == "POST" || bereq.request == "DELETE")) {
    return (hit_for_pass);
  }
 
  # dont cache redirects or errors - especially for staging errors can be temporary only
  if ( beresp.status >= 300 ) {
    return (hit_for_pass);
  }
  
  # cache metrics and map tiles for a minute
  if ( req.url ~ "^/(metrics-ws|tile-server)") {
    set beresp.ttl = 60s;
    # cache quickly changing count metrics for 10 seconds only
    if ( req.url ~ "count") {
      set beresp.ttl = 10s;
    }
  } else if( req.url ~ "^/(cfg|css|img|js|favicon|sites|misc|modules)" ) {
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

  # set explicit cache header
  set beresp.http.Cache-Control = "max-age=" + beresp.ttl;

  return (deliver);
}

sub vcl_error {
  if (obj.status == 301) {
    set obj.http.Location = obj.response;
    set obj.status = 301;
    return(deliver);
  }
}
