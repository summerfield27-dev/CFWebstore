
<!--- CFWebstore, version 6.50 --->

<!--- This template inserts a confirmation box to confirm admin actions
	An alert box is used unless an error occurs. Then a text box.
INPUT:
	attributes.box_title	 - optional, used for box style (as opposed to "alert")
	attributes.XFA_success	 - where to return to... if blank, a "back" is used
	attributes.message		 - message displayed at successful completion
	attributes.error_message - if the update was not successful.
--->	
<cfparam name = "attributes.message" default="Changes Saved!">
<cfparam name = "attributes.error_message" default="">
<cfparam name = "attributes.box_title" default="Error">
<cfparam name = "attributes.XFA_success" default="">
<cfparam name = "attributes.XFA_failure" default="">
<cfparam name = "attributes.admin_reload" default="">
<cfparam name = "attributes.menu_reload" default="no">


<!--- If an error_message exists, use confirmation BOX ---->
<cfif len(attributes.error_message)>	
	
	<cfoutput>
	<cfmodule template="../customtags/format_admin_form.cfm"
		box_title="#attributes.box_title#"
		width="450"
		required_fields= "0"
		>
		<tr><td align="center">
		<br/>
		<p class="formerror"><strong>#attributes.error_message#</strong></p>

		<cfif len(attributes.XFA_Failure)>
			<input type="button" value="Return" onclick="javascript:window.location.href='#attributes.XFA_failure#&redirect=1';" class="formbutton"/>
		<cfelse>
			<input type="button" value="Return" onclick="javascript:window.history.go(-1);" class="formbutton"/>
		</cfif>
		
		<br/><br/>	
		
		</td></tr>
	</cfmodule> 
	</cfoutput>

<!--- if no error, then use an alert style confirmation ---->
<cfelse>

	<!---<cfif NOT FindNoCase(request.self, attributes.XFA_success)>
		<cfset redirectURL = "#request.self#?#attributes.XFA_success#&redirect=yes">
	<cfelse>
		<cfset redirectURL = "#attributes.XFA_success#&redirect=yes">
	</cfif>--->
	
	<cfset redirectURL = doReturn(attributes.XFA_success)>
	
	<!--- Check if redirecting to an admin or user page, if so add full token for shared ssl --->
	<cfif Left(redirectURL,5) IS "https">
		<cfset redirectURL = redirectURL & Request.AddToken>
	<cfelse>
		<cfset redirectURL = redirectURL & Request.Token2>
	</cfif>
	
	<!--- <cfif len(attributes.admin_reload)>
		<cfswitch expression="#attributes.admin_reload#">
			<cfcase value="membershipcount">
				<cfset innertext = Application.objMenus.getValidMemberships()>
			</cfcase>
			<cfcase value="usercount">
				<cfset innertext = Application.objMenus.getValidUserCCs()>
			</cfcase>
			<cfcase value="commentcount">
				<cfset innertext = Application.objMenus.getPendingComments()>
			</cfcase>
			<cfcase value="reviewcount">
				<cfset innertext = Application.objMenus.getPendingReviews()>
			</cfcase>
		</cfswitch>		
	</cfif> --->
		
	<!--- if admin confirmation, add inframes attribute to link --->
	<cfset Session.result_message = attributes.message>
	
	<cfoutput>
	<cfprocessingdirective suppresswhitespace="no">
	<script type="text/javascript">
	<!--- if reloading an admin menu, and not on SSL, output JS code to update counter --->
	<!--- <cfif len(attributes.admin_reload) AND CGI.SERVER_PORT IS NOT 443>
		if (parent.AdminMenu.document.getElementById('#attributes.admin_reload#') != null) {
		  parent.AdminMenu.document.getElementById('#attributes.admin_reload#').innerHTML = '#innertext#';
		}
	</cfif> --->
  	//alert('#attributes.message#');	
	<!--- if admin confirmation, add inframes attribute to link to stay in the frameset --->
	<cfif FindNoCase(".admin", redirectURL) AND NOT attributes.menu_reload>
		setTimeout("location.href = '#redirectURL#&inframes=yes'",1200);
	<!--- Otherwise, load to top of frameset --->
	<cfelse>
		setTimeout("top.location.href = '#redirectURL#'",1200);
	</cfif>
	
    </script>
	</cfprocessingdirective>
	
	</cfoutput>

</cfif>

