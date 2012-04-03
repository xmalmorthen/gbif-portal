package org.gbif.sso;

import java.io.IOException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet 
{
	protected String mCasLogoutUrl;
	
	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		mCasLogoutUrl = config.getInitParameter("casServerLogoutUrl");
	}
	
	// action for single application logout
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
    {
		String[] values = request.getParameterValues("LogoutType");
		if (values != null && values.length >= 1) {
			if (values[0].equals("ApplicationLogout")) {
				doApplicationLogout(request, response);
			}
			else if (values[0].equals("SingleSignOut")) {
				doSingleSignOut(request, response);
			}
		}
    }
    
    public void doApplicationLogout(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
    {
        String endl = System.getProperty("line.separator");
        String baseUrl = "https://"+ request.getServerName() +":8443/TestApp";

        StringBuilder sb = new StringBuilder();
        sb.append("<html><head>");
        sb.append("<title>Application Logout</title>");
        sb.append("</head><body>");
        sb.append("<h2>You have logged out of one application only</h2>").append(endl);
        
        sb.append("<b><a href=\"").append(baseUrl).append("1/sso/ProtectedServlet\">").append(endl);
        sb.append("Access the Test App #1 protected page").append(endl);
        sb.append("</a></b><br/>").append(endl);

        sb.append("<b><a href=\"").append(baseUrl).append("2/sso/ProtectedServlet\">").append(endl);
        sb.append("Access the Test App #2 protected page").append(endl);
        sb.append("</a></b><br/>").append(endl);

        sb.append("</body></html>").append(endl);

        response.setContentType("text/html");
        response.getWriter().println(sb.toString());
        
    	HttpSession session = request.getSession(false);
    	session.invalidate();
    }

    public void doSingleSignOut(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
    {
    	if (mCasLogoutUrl != null) { 
            response.sendRedirect(mCasLogoutUrl);
    	} else {
	        String endl = System.getProperty("line.separator");
	
	        StringBuilder sb = new StringBuilder();
	        sb.append("<html><head>").append(endl);
	        sb.append("<title>Single Sign-out Logout</title>").append(endl);
	        sb.append("</head><body>").append(endl);
	        sb.append("<h2>ERROR - mCasLogoutUrl is NULL</h2>").append(endl);
	        sb.append("</body></html>").append(endl);

	        response.setContentType("text/html");
	        response.getWriter().println(sb.toString());
    	}
    }
}
