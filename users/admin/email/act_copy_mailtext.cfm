<!--- CFWebstore, version 6.50 --->

<!--- Creates a copy of a mailtext. Called by users.admin&mailtext=copy --->

<!--- Get the mailtext to copy --->
<cfinclude template="qry_get_mailtext.cfm">

<cfif qry_get_mailtext.recordcount>
	<cftransaction isolation="SERIALIZABLE">

	<cfquery name="Addmailtext" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#MailText 
		(MailText_Name, MailText_Subject, MailText_Message, System, MailAction)
		VALUES (
		'#qry_get_mailtext.mailtext_name#',
		'#qry_get_mailtext.mailtext_subject#',
		'#qry_get_mailtext.mailtext_message#',
		'#qry_get_mailtext.system#',
		'#qry_get_mailtext.MailAction#')
	</cfquery>	
			
	<cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
		   SELECT MAX(MailText_ID) AS maxid
		   FROM #Request.DB_Prefix#MailText
	</cfquery>
	
	<cfset attributes.mailtext_id = get_id.maxid>
	
	</cftransaction>
</cfif>		

<cfsetting enablecfoutputonly="no">
