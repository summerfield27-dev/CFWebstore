<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Used to create the persistent login box. Call from your layout pages --->

<cfsavecontent variable="loginbox">	
	<cfset attributes.format = "_box">
	<cfset fusebox.nextaction="users.loginbox">
	<cfinclude template="../lbb_runaction.cfm">

	<br/>		
</cfsavecontent>			

</cfsilent>

<cfoutput>
	<!-- start layouts/put_loginbox.cfm -->
	<div id="putloginbox" class="layouts">
	#HTMLCompressFormat(variables.loginbox)#
	</div>
	<!-- end layouts/put_loginbox.cfm -->
</cfoutput>	
				