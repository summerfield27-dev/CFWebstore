<!--- CFWebstore, version 6.50 --->

<!--- Previews and sends an email to the list. Called from users.admin&email=send. --->

<cfparam name="attributes.preview" default="0">

<!--- Set timeout to prevent lots of emails from timing out the page --->
<cfsetting requesttimeout="600">

<!--- Preview message --->
<cfif attributes.Preview is "1">
	
	<cfinvoke component="#Request.CFCMapping#.global" method="doTextReplace" returnvariable="subject"
		EmailText="#attributes.subject#" />
	<!--- Check if there is user information in the query --->
	<cfif isDefined("qry_getemails.User_ID") AND qry_getemails.User_ID IS NOT 0 AND qry_getemails.RecordCount IS 1>
		<cfinvoke component="#Request.CFCMapping#.global" method="doTextReplace" returnvariable="body"
			EmailText="#attributes.body#" UserQuery="#qry_getemails#" UserRow="#qry_getemails.currentrow#" />
	<cfelse>
		<cfinvoke component="#Request.CFCMapping#.global" method="doTextReplace" returnvariable="body"
		EmailText="#attributes.body#" />
	</cfif>

	<cfinclude template="../../../customtags/ckeditor_config.cfm">


	<cfmodule template="../../../customtags/format_admin_form.cfm"
		box_title="Preview Email"
		width="600"
		required_fields="0"
		>
	
		<cfoutput>
		<form name="users"  action="#self#?Fuseaction=users.admin&email=send#Request.Token2#" method="post"  >
		<input type="hidden" name="xfa_success" value="#attributes.xfa_success#"/>
		<cfloop list="customer_id,un,uid,verified,subscribe,GID,wholesale,affiliate,acct,lastLogin,lastLogin_is,created,created_is,product_ID,SKU,dateOrdered,dateFilled,dateOrdered_is,dateFilled_is,member" index="counter">
		<input type="hidden" name="#counter#" value="#attributes[counter]#"/>
		</cfloop>
		<cfset keyname = "sendAdminEmail">
		<cfinclude template="../../../includes/act_add_csrf_key.cfm">
		
		<tr>
			<td colspan="3">
			<blockquote><font size="-1">A preview of your message is displayed below.  Please review it and confirm that you would like this message sent.</font><br/><br/>
				<cfif (len(attributes.un) OR len(attributes.uid) OR len(attributes.customer_id))AND qry_getemails.recordcount is 1>
					#qry_getemails.email#
				<cfelse>
					#qry_getemails.recordcount# email addresses selected 
				</cfif>

</blockquote>
<br/><br/>
			
			<cfmodule template="../../../customtags/putline.cfm" linetype="thick" linecolor="#Request.GetColors.InputHBgcolor#"/>
			<table border="0" class="formtext" style="color:###Request.GetColors.InputTText#">
			<tr>
					<td align="right">FROM:</td>
					<td>#Request.AppSettings.MerchantEmail#</td>
				</tr>
				<tr>
					<td align="right">SUBJECT:</td>
					<td>#Subject#</td>
				</tr>
				<tr>
					<td align="right">DATE:</td>
					<td>#LSDateFormat(Now(),'dddd, mmm dd, yyyy')#</td>
				</tr>
				<tr>
					<td></td>
					<td><br/>#Body#</td>
				</tr>
			</table>
			<br/><br/>
			<cfmodule template="../../../customtags/putline.cfm" linetype="thick" linecolor="#Request.GetColors.InputHBgcolor#"/>
	
			</td>
		</tr>

		 <!--- Subject --->
			<tr>
				<td align="right">Subject:</td>
				<td style="background-color: ###Request.GetColors.formreq#;" width="4">&nbsp;</td>
		 		<td><input type="text" name="Subject" value="#attributes.Subject#" size="48" class="formfield"/></td>
			</tr>	
			
	 	<!--- message --->
			<tr>
				<td align="right" valign="top">Message:</td>
				<td style="background-color: ###Request.GetColors.formreq#;"></td>
		 		<td>
			 	<textarea id="body" name="body">#attributes.body#</textarea>
				<script type="text/javascript">
				CKEDITOR.replace( 'body', { #ck_default# #ck_image#
				<cfif NOT Request.DemoMode>
				#ck_files#
				</cfif>
				 #full_tool# } );
				</script>
				</td>
			</tr>	
			
			
			<tr>
			<td colspan="2"></td>
			<td><br/>
			<input type="submit" name="Submit" value=" Send Message " class="formbutton"/> &nbsp;
			<input type="button" value="Cancel" onclick="javascript:window.location.href='#self#?#xfa_success##request.token2#';" class="formbutton"/>
			</td>
			</tr>	
			<cfinclude template="../../../includes/form/put_requiredfields.cfm">
			
			</form>	
			</cfoutput>
			
	</cfmodule>
	
<cfelse>
	
	<!--- CSRF Check --->
	<cfset keyname = "sendAdminEmail">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
	
	<cfset attributes.message="Your message has been sent.">
	
<!--- Send message ---->
	<cfloop query="qry_getemails">
		<cfinvoke component="#Request.CFCMapping#.global" method="doTextReplace" returnvariable="subject"
		EmailText="#attributes.subject#" />
	<!--- Check if there is user information in the query --->
	<cfif isDefined("qry_getemails.User_ID") AND qry_getemails.User_ID IS NOT 0>
		<cfinvoke component="#Request.CFCMapping#.global" method="doTextReplace" returnvariable="emailbody"
			EmailText="#attributes.body#" UserQuery="#qry_getemails#" UserRow="#qry_getemails.currentrow#" />
	<cfelse>
		<cfinvoke component="#Request.CFCMapping#.global" method="doTextReplace" returnvariable="emailbody"
		EmailText="#attributes.body#" />
	</cfif>
		

<cfif isEmail(qry_getemails.email)>
	<cfprocessingdirective suppresswhitespace="no">
		
		<cfmail to="#qry_getemails.email#" 
			from="#request.appsettings.merchantemail#" 
			subject="#subject#"
			type="html" server="#request.appsettings.email_server#" port="#request.appsettings.email_port#">
			<cfmailparam name="Message-id" value="<#CreateUUID()#@#ListGetAt(request.appsettings.merchantemail, 2, "@")#>">
			<cfmailparam name="Reply-To" Value="#request.appsettings.merchantemail#">
	#emailbody#
	
			</cfmail>
	</cfprocessingdirective>

<cfelse>

	<cfset attributes.message="Some emails were not sent due to invalid email addresses.">

</cfif>

	</cfloop>

</cfif>

