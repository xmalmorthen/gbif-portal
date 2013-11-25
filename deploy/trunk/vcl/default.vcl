# The tomcat backend serving the portal application and web services
# Timeouts are aggressive to encourage Varnish to discard stale connections
# The backend is never marked as bad (saintmode = 0)
# Polling is added only for heartbeating, to keep connections open (just in case)
backend tomcat {
  .host = "jawa.gbif.org";
#  .host = "staging.gbif.org";    
  .port = "8080";
  .connect_timeout = 2s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 60s;
  # never discard a backend
  .saintmode_threshold = 0;
  # don't overload tomcat (it has 100 connection pool)
  .max_connections = 75;
}

backend struts {
  .host = "v-prod1-tomcat.gbif.org";    
#  .host = "v-staging.gbif.org";
  .port = "80";
  .connect_timeout = 2s;
  .first_byte_timeout = 30s;
  .between_bytes_timeout = 30s;
}

backend drupal {    
  .host = "v-prod1-drupal.gbif.org";
#  .host = "v-drupaldev.gbif.org";
  .port = "80";   
  .connect_timeout = 2s;
  .first_byte_timeout = 30s;
  .between_bytes_timeout = 30s;  
}

backend geocode {
  .host = "boma.gbif.org";    
  .port = "8080";   
  .connect_timeout = 2s;
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
	# this evicts single objects from the cache
  if (req.request == "PURGE") {
    if (!client.ip ~ GBIFS) {
      error 403 "Forbidden.";
    } else {
      return (lookup);
    }
  }

	# this bans matching objects via regex from being served if older than the ban
  if (req.request == "BAN") {
    if (!client.ip ~ GBIFS) {
      error 403 "Forbidden.";
    } else {
			ban("obj.http.x-api-url ~ " + req.http.x-ban-url);
      error 200 "Banned";
    }
  }

  # keep original URL in custom header for the ban lurker process later one in vcl_fetch. We modify the request URL here to match the backend apps
  set req.http.x-api-url = req.url;
  # temporarily until the java clients set the headers themselves
  if (!req.http.x-url) {
   set req.http.x-url = req.url;
  }  
	
  # is this a frontend or webservice request?
  if (req.http.host ~ "^api") {
		# sets a custom header so we can easily detect this was a webservice call to our API in later routines of varnish
    set req.http.x-api = "true";
    call recv_ws;
  } else {
    call recv_portal;
  }
}

sub recv_ws {
  # remove whatever host we got, as varnish adds the backend hostname if none exists in the request
  remove req.http.host;

  # remove cookies in weird case they exist
  remove req.http.Cookie;

  if ( req.url ~ "^/favicon.ico") {
    error 404 "Not found";
  }
 
  # require and remove version prefix - we do not have multiple versions yet
  if ( req.url ~ "^/v0.9/") {
    set req.url = regsub(req.url, "^/v0.9/", "/");
  } else {
    error 404 "Not found. Latest API version is v0.9";
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

  # geocode
  } else if (req.url ~ "^/lookup/reverse_geocode"){
    set req.backend = geocode;
    set req.url = regsub(req.url, "^/lookup/reverse_geocode", "/geocode-ws/reverse");

  # nub lookup
  } else if (req.url ~ "^/species/match"){
    set req.backend = nublookup;
    set req.url = regsub(req.url, "^/species/match", "/nub-ws/species/match");
    
  } else if ( req.url ~ "^/species/(search|suggest)") {
      set req.url = regsub(req.url, "^/species/", "/b_checklistbank-search-ws/");
  
  } else if ( req.url ~ "^/(parser/name|species|dataset_metrics|description|name_list)" ) {
    set req.url = regsub(req.url, "^/", "/b_checklistbank-ws/");
  
  } else if ( req.url ~ "^/map") {
    set req.url = regsub(req.url, "^/map", "/b_tile-server");
  
  } else if ( req.url ~ "^/occurrence/(count|counts|datasets|countries|publishing_countries)") {
    set req.url = regsub(req.url, "^/", "/b_metrics-ws/");
  
  } else if ( req.url ~ "^/occurrence/download/request") {
    set req.url = regsub(req.url, "^/", "/b_occurrence-download-ws/");
    # not cache any download response
    return (pass);

  } else if ( req.url ~ "^/occurrence/download") {
    set req.url = regsub(req.url, "^/", "/b_registry-ws/");
    # not cache any download response
    return (pass);
  
  } else if ( req.url ~ "^/occurrence") {
    set req.url = regsub(req.url, "^/", "/b_occurrence-ws/");
  
  } else if ( req.url ~ "^/dataset/metrics") {
    # not existing yet for all datasets - use checklist service for now
    set req.url = regsub(req.url, "^/dataset/metrics", "/b_checklistbank-ws/dataset_metrics");
  
  } else if ( req.url ~ "^/dataset/process") {
    set req.url = regsub(req.url, "^/", "/b_crawler-ws/");
  
  } else if ( req.url ~ "^/image") {
    set req.url = regsub(req.url, "^/image", "/b_image-cache/");
  
  } else if (req.url !~ "^/web") {
    # anything left should be registry calls
    set req.url = regsub(req.url, "^/", "/b_registry-ws/");
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
  # remove whatever host we got, as varnish adds the backend hostname if none exists in the request
  remove req.http.host;

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
  if ( req.url ~ "^/(dataset|occurrence|species|installation|member|node/|network/|ipt|publisher|developer|country|cfg|css|fonts|img|js|favicon|participation/list|infrastructure)" || (req.url ~ "^/user/(download|namelist)")) {
    set req.backend = struts;

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
	# keep original request url in cache for varnishs ban lurker thread:
	# https://www.varnish-software.com/static/book/Cache_invalidation.html#smart-bans
	# x-api-url is set in vcl_recv BAN
	set beresp.http.x-api-url = req.http.x-api-url;

  # ban (flush) entire registry cache
  if(req.request != "GET" && req.http.x-api-url ~ "/(organization|node|dataset|network|installation)") {
		ban("obj.http.x-api-url ~ /(organization|node|dataset|network|installation)");
  }

  # remove portal context from redirects
  if ( beresp.status == 302 || beresp.status == 301 ) {
    if (beresp.http.Location ~ "/b_portal/") {
      set beresp.http.Location = regsub(beresp.http.Location, "/b_portal/", "/");
    }
    set beresp.http.Location = regsub(beresp.http.Location, "v-[a-z0-9-]+.gbif.org", "www.gbif.org");
  }
  

  #
  # CACHE CONTROL
  #
  # remove no cache headers. 
  # Cache-Control: mag-age takes precendence over Last-Modified or ETags:
  # https://www.varnish-cache.org/trac/wiki/VCLExampleLongerCaching
  # http://stackoverflow.com/questions/6451137/etag-attribute-present-but-no-cache-control-present-in-http-header
  # http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html
  remove beresp.http.Cache-Control;
 
  # dont cache redirects or errors - especially for staging errors can be temporary only
  if ( beresp.status >= 300 ) {
    set beresp.ttl = 0s;
	} else {
	  if ( req.url ~ "^/tile-server") {
	    # cache map tiles
	    set beresp.ttl = 3600s;
	    set beresp.http.Cache-Control = "public, max-age=3600";
	  } else if( req.url ~ "^/(cfg|css|img|js|favicon|sites|misc|modules)" ) {
	    # cache static files
	    set beresp.ttl = 3600s;
	    set beresp.http.Cache-Control = "public, max-age=3600";
	  } else if( req.http.x-api ) {
	    # cache all API calls
	    set beresp.ttl = 3600s;
	  }
	}

  if ( beresp.http.Cookie ) {
    set beresp.http.Cache-Control = "no-cache, must-revalidate, private";
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

sub vcl_deliver {
	# remove vcl internal headers
	# Keep headers for better debugging until API stabilizes
#	unset resp.http.x-url;
#	unset resp.http.x-api-url;
# unset resp.http.x-api;
}

sub vcl_hit {
	if (req.request == "PURGE") {
		purge;
		error 200 "Purged.";
	}
}

# we also purge cache misses as there might be variants (Vary) of the resource
sub vcl_miss {
	if (req.request == "PURGE") {
		purge;
		error 200 "Purged.";
	}
}
