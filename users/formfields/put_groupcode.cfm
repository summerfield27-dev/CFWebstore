<!--- CFWebstore, version 6.50 --->

	
<!--- Inserts group code form field. Called during user registration from the users\dsp_account_form.cfm, users\dsp_member_form.cfm and users\dsp_registration_form.cfm templates. ---->


<cfif get_User_Settings.UseGroupCode>
	<!-- start users/formfields/put_groupcode.cfm -->
	<cfoutput>
		<tr align="left">
			<td align="right">Group Code (if any):</td>
			<td></td>
			<td><input type="text" size="30" name="groupcode" value="#HTMLEditFormat(attributes.groupcode)#" class="formfield"/></td></tr>
	</cfoutput>
	<!-- end users/formfields/put_groupcode.cfm -->
</cfif>
	