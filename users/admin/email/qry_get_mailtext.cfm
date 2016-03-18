<!--- CFWebstore, version 6.50 --->

<!--- We need to get the message requested. --->
<cfparam name="attributes.MailAction" default="">
<cfparam name="attributes.mailtext_id" default="">

<cfquery name="qry_get_mailtext" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM  #Request.DB_Prefix#MailText
	WHERE 1 = 1
		<cfif len(attributes.MailAction)>
			AND MailAction = '#attributes.MailAction#'
		</cfif>
		<cfif len(attributes.mailtext_id)>
			AND MailText_ID = #attributes.mailtext_id#
		</cfif>
</cfquery>
	

		
	
