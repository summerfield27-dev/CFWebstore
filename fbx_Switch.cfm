
<!--- CFWebstore, version 6.50 --->

<!---
<fusedoc fuse="FBX_Switch.cfm">
	<responsibilities>
		I am the cfswitch statement that handles the fuseaction, delegating work to various fuses.
	</responsibilities>
	<io>
		<string name="fusebox.fuseaction" />
		<string name="fusebox.circuit" />
	</io>	
</fusedoc>
--->


<cfswitch expression = "#fusebox.fuseaction#">


<cfcase value="admin">
	<!--- USERS Permission 2 = access admin menu --->
	<cfmodule template="access/secure.cfm"
	keyname="users"
	requiredPermission="2"
	>	
	<!--- Check for session spoof --->
	<cfinclude template="includes/admin_access_check.cfm">
	<cfif ispermitted>
		<cfinclude template="admin/fbx_Switch.cfm">
	<cfelse>	
		<cfset attributes.xfa_logout_successful = "fuseaction=home.admin">
		<cfinclude template="users/login/act_logout.cfm">
	</cfif>
	
</cfcase>

<cfcase value="email">
	<cfinclude template="email/act_mailform.cfm">
</cfcase>

<!--- Allow direct indexing of verity collection, used for scheduling to run automatically --->
<cfcase value="verity">
	<cfinclude template="admin/settings/act_verity.cfm">
</cfcase>

<cfcase value="senderror">
	<cfinclude template="admin/errors/act_submiterror.cfm">
</cfcase>

<cfcase value="test">
	<cfinclude template="test.cfm">
</cfcase>

<cfcase value="nojs">
	Sorry, you cannot access the admin without javascript enabled.
</cfcase>

<cfcase value="csrferror">
	<cfoutput>
	Sorry, this form does not appear to have been properly submitted. Please reload the original form and try again. If you continue to have problems, contact the website administrator. 
	<cfif isDefined("attributes.missingkey")>#missingkey#</cfif>
	</cfoutput>
</cfcase>

<cfdefaultcase>
	<cfmodule template="#thisSelf#"
	fuseaction="page.pageNotFound">
</cfdefaultcase>
</cfswitch>


	