<!--- CFWebstore, version 6.50 --->

<!--- Inserts birthdate form fields. Used during user registration on the users\dsp_account_form.cfm, users\dsp_member_form.cfm and users\dsp_registration_form.cfm templates and dsp_birthdate_update.cfm form. ---->

<!-- start users/formfields/put_birthdate.cfm -->
<cfif get_User_Settings.UseBirthdate>
	<tr align="left">
		<td align="right" valign="baseline">Date of birth:</td>
		<td style="background-color: <cfoutput>###Request.GetColors.formreq#</cfoutput>;" width="3">&nbsp;</td>
		<td>
		<cfif attributes.birthdate is not "">
			<cfmodule template="../../customtags/form/dropdown.cfm"
			mode = "date"
			label = "bday"
			set_date = "#attributes.birthdate#"
			start_year = "1910"
			year_range = "0"
			>
		<cfelse>	
			<cfmodule template="../../customtags/form/dropdown.cfm"
			mode = "date"
			label = "bday"
			start_year = "1910"
			year_range = "0"
			blank = "yes"
			>
		</cfif>
	</td></tr>
</cfif>
<!-- end users/formfields/put_birthdate.cfm -->
