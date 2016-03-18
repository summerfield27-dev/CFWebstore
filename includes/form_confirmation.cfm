
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
<cfparam name = "attributes.admin_reload" default="">
<cfparam name = "attributes.display_type" default="alert">
<cfparam name = "Session.result_message" default="">

<!---<cfif NOT FindNoCase(request.self, attributes.XFA_success)>
	<cfset redirectURL = "#request.self#?#attributes.XFA_success#&redirect=yes">
<cfelse>
	<cfset redirectURL = "#attributes.XFA_success#&amp;redirect=yes">
</cfif>--->
	
<cfset redirectURL = doReturn(attributes.XFA_success)>
	
<!--- Check if redirecting to an admin or user page, if so add full token for shared ssl --->
<cfif Left(redirectURL,5) IS "https">
	<cfset redirectURL = redirectURL & Request.AddToken>
<cfelse>
	<cfset redirectURL = redirectURL & Request.Token2>
</cfif>

<!-- start includes/form_confirmation.cfm -->
<div id="formconfirmation" class="includes">

<!--- If an error_message exists, use confirmation BOX ---->
<cfif len(attributes.error_message)>
	
	<cfoutput>
	<cfmodule template="../customtags/format_input_form.cfm"
		box_title="#HTMLEditFormat(attributes.box_title)#"
		width="450"
		required_fields= "0"
		>
		<tr><td align="center">
		<br/>
		<p class="formerror"><strong>#HTMLEditFormat(attributes.error_message)#</strong></p>

		<input type="button" value="Return" onclick="javascript:window.history.go(-1);" class="formbutton"/>
		<br/><br/>	
		
		</td></tr>
	</cfmodule> 
	</cfoutput>

<!--- if no error, then check if we set a session message ---->
<cfelseif len(Session.result_message)>
	
	<cflocation url="#redirectURL#" addtoken="no">


<!--- check for an alert style confirmation ---->
<cfelseif attributes.display_type IS "alert">	
	
	<cfif len(attributes.admin_reload)>
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
	</cfif>
		
	<!--- if admin confirmation, add inframes attribute to link --->	
	<cfif fusebox.fuseaction is "admin">
		<cfset redirectURL = redirectURL & "&inframes=yes">
	</cfif>
	
	<cfoutput>
	<cfprocessingdirective suppresswhitespace="no">
	<script type="text/javascript">
	<!--- if reloading an admin menu, output JS code --->
	<cfif len(attributes.admin_reload) AND CGI.SERVER_PORT IS NOT 443>
		if (parent.AdminMenu.document.getElementById('#attributes.admin_reload#') != null) {
		  parent.AdminMenu.document.getElementById('#attributes.admin_reload#').innerHTML = '#innertext#';
		}
	</cfif>
  	alert('#HTMLEditFormat(attributes.message)#');	
	location.href = '#redirectURL#';
    </script>
	</cfprocessingdirective>
	
	<!--- Output link if JS disabled --->
	#HTMLEditFormat(attributes.message)#<br/><br/>
	<a href="#XHTMLFormat(redirectURL)#">Click</a> to continue.
	</cfoutput>

<cfelse>

	<cfoutput>
	<cfmodule template="../customtags/format_input_form.cfm"
		box_title="#HTMLEditFormat(attributes.box_title)#"
		width="450"
		required_fields= "0"
		>
		<tr><td align="center">
		<br/>
		<strong>#HTMLEditFormat(attributes.message)#</strong><br/><br/>
		<form action="#Session.Page#" method="post" class="margins">
		<input type="submit" value="Return to the Store" class="formbutton"/>
		</form>
		</td></tr>
	</cfmodule> 
	</cfoutput>

</cfif>

</div>
<!-- end includes/form_confirmation.cfm -->

	
