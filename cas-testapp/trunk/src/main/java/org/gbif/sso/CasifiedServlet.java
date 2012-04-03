package org.gbif.sso;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.Principal;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

import org.jasig.cas.client.authentication.AttributePrincipal;

public class CasifiedServlet extends HttpServlet
{
	String mServerName = null;
	
	@Override
	public void init(ServletConfig config) throws ServletException 
	{
		super.init(config);
		mServerName = config.getInitParameter("serverName");
	}

	protected void createPage(int pageId, HttpServletRequest request, PrintWriter out) throws IOException, ServletException
    {
        String endl = System.getProperty("line.separator");
        StringBuilder sb = new StringBuilder();

        String baseUrl = mServerName +"/TestApp";
        String thisPage = pageId == 1 ? "1" : "2";
        String thatPage = pageId == 1 ? "2" : "1";
    	
        sb.append("<html>");
        sb.append("<head>");
        sb.append("<title>CAS SSO Test Application #").append(thisPage).append(" - Protected Page</title>");
        sb.append("</head>");
        
        sb.append("<body>").append(endl);
        sb.append("<h2 align=\"center\">CAS SSO Test Application #").append(thisPage).append(" Protected Page on ").append(request.getServerName()).append("</h2>").append(endl);
        if (pageId == 1) {
        	sb.append("<p/><img src=\"").append(request.getContextPath()).append("/images/red_1.jpg\"/>").append(endl);
        } else {
        	sb.append("<p/><img src=\"").append(request.getContextPath()).append("/images/red_2.jpg\"/>").append(endl);
        }
        sb.append("<p>").append(endl);

        Principal p = request.getUserPrincipal();
        sb.append("request.getRemoteUser() = ").append(request.getRemoteUser()).append("<br/>").append(endl);
        sb.append("request.getUserPrincipal() = ").append(p.getName()).append("<br/><br/>").append(endl);

        sb.append("</p><p>").append(endl);
        sb.append("The context root name of this application is ").append(request.getContextPath()).append(endl);
        sb.append(new java.util.Date()).append(endl);
        sb.append("</p>").append(endl);
        
        sb.append("<b><a href=\"").append(baseUrl).append(thatPage).append("/index.jsp\">").append(endl);
        sb.append("Access the Test App #").append(thatPage).append(" home page").append(endl);
        sb.append("</a></b><br/>").append(endl);
        
        sb.append("<b><a href=\"").append(baseUrl).append(thatPage).append("/sso/ProtectedServlet\">").append(endl);
        sb.append("Access the Test App #").append(thatPage).append(" protected page").append(endl);
        sb.append("</a></b><br/><br/>").append(endl);

        //<input type="hidden" name="LogoutType" value="AppicationLogout">
        
        sb.append("<form name=\"Logout\" action=\"LogoutServlet\" method=\"get\">");
    		sb.append("<input type=\"hidden\" name=\"LogoutType\" value=\"ApplicationLogout\"/>").append(endl);
        	sb.append("<input type=\"submit\" value=\"Logout\"/></form><br/>").append(endl);
        sb.append("<form name=\"SSOLogout\" action=\"LogoutServlet\" method=\"get\">");
			sb.append("<input type=\"hidden\" name=\"LogoutType\" value=\"SingleSignOut\"/>").append(endl);
	    	sb.append("<input type=\"submit\" value=\"Single Sign-Out\"/></form><br/>").append(endl);

        sb.append("<h3>Released Attributes</h3>").append(endl);
        AttributePrincipal principal = (AttributePrincipal)p;
		Map attributes = principal.getAttributes();
		if (attributes != null && attributes.size() > 0) {
			Iterator iter = attributes.keySet().iterator();
			while (iter.hasNext()) {
				String key = (String)iter.next(); 
				Object value = attributes.get(key);
				if (value instanceof String) {
			        sb.append(key).append(": ").append(value).append("<br/>").append(endl);
				} else if (value instanceof List) {
			        sb.append(key).append(" is a List:<br/>").append(endl);
					for (Object o : ((List)value)) {
				        sb.append("&nbsp;&nbsp;&nbsp;").append(o.toString()).append("<br/>").append(endl);
					}
				}
			}
		} else {
	        sb.append("None").append(endl);
		}

		sb.append("<h3>Cookies</h3>").append(endl);
        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 0) {
        	sb.append("getCookies() = <br/>").append(endl);
			for (Cookie o : cookies) {
		        sb.append("&nbsp;&nbsp;&nbsp;").append(o.getName()).append(": ").append(o.getValue()).append("<br/>").append(endl);
			}
        } else {
        	sb.append("getCookies() = null<br/>").append(endl);
        }
        
        sb.append("<h3>Headers</h3>").append(endl);
        Enumeration hdrEnum = request.getHeaderNames();
        if (hdrEnum != null){
        	sb.append("getHeaders() = <br/>").append(endl);
    		while (hdrEnum.hasMoreElements()) {
    			String name = (String)hdrEnum.nextElement(); 
		        sb.append("&nbsp;&nbsp;&nbsp;").append(name).append(": ").append(request.getHeader(name)).append("<br/>").append(endl);
    		}
        } else {
        	sb.append("getHeaderNames() = null<br/>").append(endl);
        }
        sb.append("</body></html>").append(endl);
        out.println(sb.toString());
    }

}
