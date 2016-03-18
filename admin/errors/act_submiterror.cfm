<!--- CFWebstore, version 6.50 --->


<cfmail to="#Request.AppSettings.Webmaster#"
        from="#Form.Email#"
        subject="#Request.AppSettings.siteName# Error Report"
        type="HTML"
	 	server="#request.appsettings.email_server#" port="#request.appsettings.email_port#">
		<cfmailparam name="Message-id" value="<#CreateUUID()#@#ListGetAt(request.appsettings.merchantemail, 2, "@")#>">
		<cfmailparam name="Reply-To" Value="#Form.Email#">
		
		From: #Form.Name#<br/>
		
		Description: #Form.Description#<p>
		
		DateTime: #Form.DateTime#<p>
		
		Template: #Form.Template#<p>
		
		HTTPReferer: #Form.HTTPReferer#<p>
		
		Browser: #Form.Browser#<p>
		
		Diagnostics: <p>
		
		#Form.Diagnostics#<p>
		
		QueryString: <p>
		
		#Form.QueryString#<p>
		
		</cfmail>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Thank You!</title>
</head>

<body>

<h2>Thanks!</h2>

<blockquote>

Thanks for your error report, you can now return to the<cfoutput> <a href="#Session.Page#"></cfoutput>store</a>.<p>

</blockquote>



</body>
</html>
