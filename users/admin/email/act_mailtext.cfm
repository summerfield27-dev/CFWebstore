<!--- CFWebstore, version 6.50 --->

<!--- Runs the CRUD functions for MailText table --->

<!--- CSRF Check --->
<cfset keyname = "emailTextEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">


<cfswitch expression="#mode#">

	<cfcase value="i">
	
			<cfquery name="Addmailtext" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			INSERT INTO #Request.DB_Prefix#MailText 
			(MailText_Name, MailText_Subject, MailText_Message, System, MailAction)
			VALUES
			('#Attributes.mailtext_name#',
			'#Attributes.mailtext_subject#', 
			'#Attributes.mailtext_message#',
			0,
			'#attributes.MailAction#'
			 )
			</cfquery>	

	</cfcase>
			
	<cfcase value="u">
	
		<cfif submit is "delete">
		
				<cfquery name="deletemailtext" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#MailText 
				WHERE MailText_ID = #attributes.mailtext_ID#
				</cfquery>
						
		<cfelse>
		
			<cfquery name="update_mailtext" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#MailText 
			SET MailText_Name = '#Attributes.mailtext_Name#',
			MailText_Subject = '#Attributes.mailtext_Subject#',
			MailText_Message = '#Attributes.mailtext_Message#',
			MailAction = '#Attributes.MailAction#'
			WHERE MailText_ID = #Attributes.mailtext_ID#
			</cfquery>	

		</cfif>
	</cfcase>

</cfswitch>
			

