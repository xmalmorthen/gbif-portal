backend jawa {    
  .host = "130.226.238.239";       
  .port = "8080";   
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

#backend mogo {
#  .host = "130.226.238.242";    
#  .port = "8080";   
#  .connect_timeout = 60s;
#  .first_byte_timeout = 60s;
#  .between_bytes_timeout = 60s; 
#}

#backend balancer {    
#  .host = "130.226.238.134";     
#  .port = "http";
#  .connect_timeout = 60s;
#  .first_byte_timeout = 60s;
#  .between_bytes_timeout = 60s; 
#}    

acl purge {
  "localhost";
  "192.38.28.0"/25;
  "130.226.238.128"/25;
}


sub vcl_recv {
  if (req.request == "PURGE") {
    if (!client.ip ~ purge) {
      error 405 "Not allowed.";
    } else {
      purge_url(req.url);
      error 200 "Purged.";
    }
  }

  # first check API versions
  if ( req.url ~ "^/dev/") {
    set req.http.host="jawa.gbif.org";
    set req.backend = jawa;
    set req.url = regsub(req.url, "^/dev/", "/");

  } else if (req.url ~ "^/portal/") {
    set req.http.host="staging.gbif.org";
    set req.backend = staging;
    set req.url = regsub(req.url, "^/portal/", "/portal-web-dynamic/");
    return (lookup);

  } else {
    error 404 "API version not existing";
  }

  if ( req.url ~ "^/favicon.ico") {
    error 404 "Not found";
  }
  
  if (req.url ~ "^/lookup/"){
#    set req.http.host="balancer.gbif.org";
#    set req.backend = balancer;
    set req.http.host="boma.gbif.org";
    set req.backend = boma;
    if (req.url ~ "^/lookup/name_usage"){
      set req.url = regsub(req.url, "^/lookup/name_usage", "/ws-nub/nub");
    } else if (req.url ~ "^/lookup/reverse_geocode"){
      set req.url = regsub(req.url, "^/lookup/reverse_geocode", "/geocode-ws/reverse");
    }

  } else {
    if ( req.url ~ "^/name_usage/search") {
      set req.url = regsub(req.url, "^/name_usage/", "/checklistbank-search-ws/");

    } else if ( req.url ~ "^/name_usage" || req.url ~ "^/dataset_metrics" || req.url ~ "^/name_list") {
      set req.url = regsub(req.url, "^/", "/checklistbank-ws/");

    } else if ( req.url ~ "^/map") {
      set req.url = regsub(req.url, "^/map", "/tile-server");

    } else if ( req.url ~ "^/occurrence/count") {
      set req.url = regsub(req.url, "^/", "/metrics-ws/");

    } else if ( req.url ~ "^/occurrence/search") {
      set req.url = regsub(req.url, "^/occurrence", "/occurrence-ws");

    } else if ( req.url ~ "^/occurrence") {
      set req.url = regsub(req.url, "^/", "/occurrence-ws/");

    } else if ( req.url ~ "^/dataset/metrics") {
      # not existing yet for all datasets - use checklist service for now
      set req.url = regsub(req.url, "^/dataset/metrics", "/checklistbank-ws/dataset_metrics");

    } else if ( req.url ~ "^/dataset/crawl") {
      set req.url = regsub(req.url, "^/", "/metrics-ws/");

    } else if ( req.url ~ "^/dataset/search") {
      set req.url = regsub(req.url, "^/dataset/", "/registry-search-ws/");

    } else {
      # should be all registry calls
      set req.url = regsub(req.url, "^/", "/registry-ws/");
    }
  }

  return (lookup);
}


sub vcl_fetch {
  if((bereq.request == "PUT" || bereq.request == "POST" || bereq.request == "DELETE") && (beresp.status < 400)) {
    purge_url("/dev/(node|organization|network|technical_installation|dataset|graph|contact|endpoint|identifier)/*");
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

  # cache for 12h
  set beresp.ttl = 12h;
  return (deliver);
}
