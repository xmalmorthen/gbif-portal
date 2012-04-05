/*
 * Copyright 2007 The JA-SIG Collaborative. All rights reserved. See license
 * distributed with this file and available online at
 * http://www.ja-sig.org/products/cas/overview/license/
 */
package org.gbif.cas;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.springframework.webflow.action.AbstractAction;
import org.springframework.webflow.context.servlet.ServletExternalContext;
import org.springframework.webflow.execution.Event;
import org.springframework.webflow.execution.RequestContext;

/**
 * Action that destroys the Cookie set by the Drupal cas_module to remember it has checked a user login with CAS already.
 * This action always returns "success".
 * 
 * @author Markus Döring
 */
public final class DestroyDrupalCookieAction extends AbstractAction {
    
    private String cookieName = "cas_login_checked";
    
    protected Event doExecute(final RequestContext context) {
      ServletExternalContext externalContext = (ServletExternalContext)context.getExternalContext();
      HttpServletResponse response = (HttpServletResponse) externalContext.getNativeResponse();

      if (response != null) {
        Cookie drupalCasCookie = new Cookie(cookieName, "");
        drupalCasCookie.setMaxAge(0);
        drupalCasCookie.setDomain("gbif.org");
        drupalCasCookie.setPath("/");
        response.addCookie(drupalCasCookie);

        Cookie testCookie = new Cookie("cas_test_cookie", "true");
        testCookie.setMaxAge(10000);
        testCookie.setDomain("gbif.org");
        testCookie.setPath("/");
        response.addCookie(testCookie);
      }
        
      return success();
    }
    
    public void setCookieName(String cookieName) {
      this.cookieName = cookieName;
    }
}
