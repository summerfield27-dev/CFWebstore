<!--- CFWebstore, version 6.50 --->

<!--- Used for entering in new email templates. --->

<cfset fieldlist="mailtext_Name,mailtext_Message,mailtext_subject,System,MailAction">

<cfswitch expression="#attributes.mailtext#">
		
	<cfcase value="add">
		<cfloop list="#fieldlist#" index="counter">
				<cfset temp = setvariable("attributes.#counter#", "")>
		</cfloop>
		<cfset attributes.mailtext_id="0">	
		<cfset action="#self#?fuseaction=users.admin&mailtext=act&mode=i">
    	<cfset act_title="Add">	
			
	</cfcase>
			
	<cfcase value="edit,copy">
				
		<cfloop list="#fieldlist#" index="counter">
				<cfset "attributes.#counter#" = evaluate("qry_get_mailtext." & counter)>
		</cfloop>
		<cfset action="#self#?fuseaction=users.admin&mailtext=act&mode=u">
		<cfset act_title="Update">
				
	</cfcase>

</cfswitch>

<cfinclude template="../../../customtags/ckeditor_config.cfm">

<cfmodule template="../../../customtags/format_output_admin.cfm"
	box_title="Email Template"
	Width="750"
	menutabs="yes">	
		
	<cfinclude template="dsp_menu.cfm">
<cfoutput>	
	<table border="0" cellpadding="0" cellspacing="4" width="100%" class="formtext" style="color:###Request.GetColors.InputTText#">

	<form name="editform" action="#action#" method="post" >
	<input type="hidden" name="XFA_failure" value="#Request.CurrentURL#">
	<cfset keyname = "emailTextEdit">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">
	
	<!--- mailtext ID --->
			<tr valign="top">
			<td align="right">Message ID:</td>
			<td></td>
			<td><input type="hidden" name="mailtext_id" value="#attributes.mailtext_id#" required="no"/>
			<cfif attributes.mailtext_id>#attributes.mailtext_id#<cfelse>New</cfif></td>
			</tr>
			
	<!--- Name --->
			<tr valign="top">
			<td align="right">Message Name:</td>
			<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
			<td>
			<input type="text" name="mailtext_name" value="#attributes.mailtext_Name#" size="35" maxlength="50" class="formfield"/>
			</td>
			</tr>
			
	<!--- MailAction --->
			<tr valign="top">
			<td align="right">System Name:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td>
			<cfif attributes.system is 1>
			#attributes.MailAction# (system email)
			<input type="hidden" name="MailAction" value="#attributes.MailAction#"/>
			<cfelse>
			<input type="text" name="MailAction" value="#attributes.MailAction#" size="35" maxlength="50" class="formfield"/>
			</cfif>
			</td>
			</tr>
		
	<!--- Subject --->
			<tr valign="top">
			<td align="right">Subject:</td>
			<td style="background-color: ###Request.GetColors.formreq#;"></td>
			<td><input type="text" name="mailtext_subject" value="#attributes.mailtext_Subject#" size="60" maxlength="75" class="formfield"/></td>
			</tr>
			
			
		<cfinclude template="../../../includes/form/put_space.cfm">
		<!--- text --->
			<tr>
				<td align="right" valign="top">Message (HTML):</td>
				<td style="background-color: ###Request.GetColors.formreq#;"></td>
		 		<td>
				<textarea id="mailtext_Message" name="mailtext_Message">#attributes.mailtext_Message#</textarea>
				<script type="text/javascript">
					CKEDITOR.replace( 'mailtext_Message', { #ck_default# #ck_image#
					<cfif NOT Request.DemoMode>
					#ck_files#
					</cfif>
					 #full_tool# } );
				</script>
			</td>
				</td>
			</tr>
			
			<tr><td></td>
			<td colspan="2" class="formtextsmall">You can use the following mailmerge fields in the subject and content:<br/> %SiteName%, %SiteURL%, %Merchant% (address), %MerchantEmail% and %Date%.
<cfif attributes.system is 1><br/><br/>%MergeName% and %MergeContent% are also available in some system emails.</cfif>
<br/><br/>User fields %Email%, %Username%, %EmailLock%, %LastLogin% <br/>and %Created% are available for user-related functions.
</td></tr>
				
	<!----SUMBIT ---->
		<cfinclude template="../../../includes/form/put_space.cfm">
	
		<tr>
			<td>&nbsp;</td><td></td>
			<td>			
			<input type="submit" name="submit" value="#act_title#" class="formbutton"/> 
			<input type="button" value="Cancel" onclick="javascript:window.history.go(-1);" class="formbutton"/>
			<cfif attributes.system is 0>
			<input type="submit" name="submit" value="Delete" class="formbutton" onclick="return confirm('Are you sure you want to delete this email text?');" /></cfif>
			
			</td></tr>
			
		<cfinclude template="../../../includes/form/put_requiredfields.cfm">
			</form>
	</cfoutput>
	
		</table>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">

objForm = new qForm("editform");

objForm.required("mailtext_name");

qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";

</script>
</cfprocessingdirective>
	
</cfmodule>
