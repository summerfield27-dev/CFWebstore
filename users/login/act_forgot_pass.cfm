<!--- CFWebstore, version 6.50 --->

<!--- This page is called by the users.forgot circuit and is used to email a user their username and password. --->

<!--- lookup user by email address submitted --->
<cfquery name="GetCustInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT User_ID, EmailIsBad, Disable FROM #Request.DB_Prefix#Users
	WHERE Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#">
</cfquery>

<cfif GetCustInfo.RecordCount is 1>
	
	<!--- Make sure account is active --->
	<cfif GetCustInfo.EmailIsBad OR GetCustInfo.Disable>
		
		<cfset errormess = "This email account is not currently active. Please contact us for assistance.">
		
	<cfelse>

		<!--- Get Password --->
		<cfinvoke component="#Request.CFCMapping#.global" method="randomPassword" 
		returnvariable="GetPass" Length="8" ExcludedValues="O,I,L,0,i,l">
	
		<!--- Update password with new random password ---->
		<cfquery name="UpdatePassword" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Users 
			SET Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Hash(GetPass.new_password)#">
			WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetCustInfo.user_ID#">
		</cfquery>		
	
		<!--- Send Confirmation Email --->
		<!--- BlueDragon was passing URL variable into the module call, so we'll delete it. ---> 
		<cfset variables.Result = StructDelete(url, "user")>
		
		<cfinvoke component="#Request.CFCMapping#.global" 
			method="sendAutoEmail" UID="#GetCustInfo.User_ID#" 
			MailAction="ForgotPassword" MergeContent="#GetPass.new_password#">
		
	</cfif>

</cfif>




