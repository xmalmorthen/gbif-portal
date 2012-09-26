backend jawa {    
  .host = "130.226.238.239";       
  .port = "8080";     
}

backend balancer {    
  .host = "130.226.238.134";       
  .port = "http";     
}       

backend staging {
  .host = "staging.gbif.org";
  .port = "8080";
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
      error 200 "Purged";
    }
  }

  if ( req.url ~ "^/favicon.ico") {
    error 404 "Not found";
  }
  
  if (req.url ~ "^/tile") {
    set  req.http.host = "staging.gbif.org" ;
    set req.backend = staging;
    set req.url = regsub(req.url, "^/tile", "/tile-server");

  } else if (req.url ~ "^/nub_match"){
    set req.http.host="balancer.gbif.org";
    set req.backend = balancer;
    set req.url = regsub(req.url, "^/nub_match", "/ws-nub/nub");

  } else {
    set req.http.host="jawa.gbif.org";
    set req.backend = jawa;

    if ( req.url ~ "^/name_usage/search") {
      set req.url = regsub(req.url, "^/name_usage/", "/checklistbank-search-ws/");

    } else if ( req.url ~ "^/name_usage" || req.url ~ "^/name_list") {
      set req.url = regsub(req.url, "^/", "/checklistbank-ws/");

    } else if ( req.url ~ "^/occurrence") {
      set req.url = regsub(req.url, "^/", "/occurrence-ws/");

    } else if ( req.url ~ "^/dataset/search") {
      set req.url = regsub(req.url, "^/dataset/", "/registry-search-ws/");

    } else {
      # should be all registry calls
      set req.url = regsub(req.url, "^/", "/registry-ws/");
    }
  }

  unset req.http.Cookie;
  return (pass);
}


sub vcl_deliver {
  if((req.request == "PUT" || req.request == "POST") && (req.url ~ "/registry-ws") && (resp.status <= 400)) {
    purge_url("/registry-ws/*");                        
  }
  return (deliver);
 }