
<!--- CFWebstore, version 6.50 --->

<cfparam name="attributes.mailtext_name" default="">

<cfquery name="qry_get_mailtexts"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#MailText
		WHERE 1 = 1
		<cfif len(attributes.mailtext_name)>AND MailText_Name like '%#attributes.mailtext_name#%'</cfif>
		<cfif isdefined("attributes.email")>
		AND System = 0
		</cfif>		
		ORDER BY System DESC, MailAction
</cfquery>
		
