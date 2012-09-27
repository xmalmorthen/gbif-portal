backend jawa {    
  .host = "130.226.238.239";       
  .port = "8080";     
}

backend balancer {    
  .host = "130.226.238.134";       
  .port = "http";     
}       

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
  } else {
    error 404 "API version not existing";
  }

  if ( req.url ~ "^/favicon.ico") {
    error 404 "Not found";
  }
  
  if (req.url ~ "^/nub_match"){
    set req.http.host="balancer.gbif.org";
    set req.backend = balancer;
    set req.url = regsub(req.url, "^/match_nub", "/ws-nub/nub");

  } else {
    if ( req.url ~ "^/name_usage/search") {
      set req.url = regsub(req.url, "^/name_usage/", "/checklistbank-search-ws/");

    } else if ( req.url ~ "^/name_usage" || req.url ~ "^/name_list") {
      set req.url = regsub(req.url, "^/", "/checklistbank-ws/");

    } else if ( req.url ~ "^/map") {
      set req.url = regsub(req.url, "^/map", "/tile-server");

    } else if ( req.url ~ "^/occurrence/metrics") {
      set req.url = regsub(req.url, "^/", "/metrics-ws/");

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

  # cache for 12h
  set beresp.ttl = 12h;
  return (deliver);
}
