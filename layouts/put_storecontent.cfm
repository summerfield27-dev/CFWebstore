
<!--- CFWebstore, version 6.50 --->


<!--- Outputs a div holder for form submission results --->
<cfparam name="session.result_message" default="">

<cfoutput>
<cfif len(session.result_message)>
	<div id="messages" class="messages">
		#session.result_message#
	</div>
	
	<cfset Session.result_message = "">
</cfif>

#HTMLCompressFormat(fusebox.layout)#
</cfoutput>


