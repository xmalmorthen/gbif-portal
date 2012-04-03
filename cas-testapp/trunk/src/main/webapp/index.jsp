<html>
	<head> 
        <title>CAS SSO Test Application #1 - Unprotected Page</title>
    </head>
    <body>
    	<% String hostname = request.getServerName(); %>
        <h2 align="center">CAS SSO Test Application #1 on <%= hostname %></h2>
		<img src="images/green_1.jpg" alt="Should see big green 1!" />
        <p>
           The context root name of this application is <%=request.getContextPath()%>.
           <%= new java.util.Date() %>
        </p>
        <p>Click the links below to access the protected pages.  
        You will be redirected to the CAS SSO server to log in. 
        If login fails, a forbidden-access browser message will be displayed.</p>

        <b><a href="sso/ProtectedServlet">
        	Access the Test App #1 protected page
        </a></b><br/><br/>

        <b><a href=<%= "https://"+ hostname +":8443/TestApp2/index.jsp" %>>
        	Access the Test App #2 home page
        </a></b><br/>
        <b><a href=<%= "https://"+ hostname +":8443/TestApp2/sso/ProtectedServlet" %>>
        	Access the Test App #2 protected page
        </a></b><br/><br/>
    </body>
</html>
