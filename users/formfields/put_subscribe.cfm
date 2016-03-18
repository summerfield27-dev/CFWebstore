<!--- CFWebstore, version 6.50 --->

<!--- Inserts the subscribe form field. Called during user registration from the users\dsp_account_form.cfm, users\dsp_member_form.cfm and users\dsp_registration_form.cfm templates. ---->


<cfif get_User_Settings.ShowSubscribe>	
	<cfoutput>
	<!-- start users/formfields/put_subscribe.cfm -->
		<tr align="left">
		<td align="right" valign="baseline">Join our email list? </td><td></td>
		<td><input type="radio" name="subscribe" value="1" class="formtext" #doChecked(attributes.subscribe)# /> Yes
		 <input type="radio" name="subscribe" value="0" class="formtext" #doChecked(attributes.subscribe,0)# /> No
		<br/><span class="formtextsmall">Receive news and special offers.</span>
		</td></tr>
	</cfoutput>
	<!-- end users/formfields/put_subscribe.cfm -->
</cfif>