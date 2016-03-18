
<!--- CFWebstore, version 6.50 --->

<!--- Called from users.logout, users.purgecookie, users.loginbox and users.kill circuits to log the user out. --->
<cfif isdefined("attributes.submit_logout")>

<!--- Do Logout ----------------------------------------->
	<cfset Session.Group_ID = 0>
	<cfset Session.User_ID = 0>
	<cfset Session.RealName = "">
	<cfset Session.UserPermissions = "">
	<cfset Session.Coup_Code = "">
	<cfset Session.Gift_Cert = "">
	<cfset Session.Wholesaler = 0>
	<cfset Session.BasketNum = 0>

	<cfif isDefined("cookie.#request.ds#_Username")>
		<cfcookie name="#request.DS#_username" value="0" expires="NOW">
		<cfcookie name="#request.DS#_password" value="0" expires="NOW">	
	</cfif> 
	
	<!--- If using the admin login as another user function, remove the variable --->
	<cfif StructKeyExists(Session,"AnotherUserLogin")>
		<cfset StructDelete(Session, "AnotherUserLogin")>
	</cfif>
	
	<!--- Clear Shopping Cart --->
	<cfcookie name="#request.DS#_Basket" value="0" expires="NOW">
	
	<!--- Clear shopping variables --->
	<cfinclude template="../../shopping/checkout/act_clear_order_vars.cfm">
	
	<!--- If items in the shopping cart, recalculate --->
	<cfif qry_Get_Basket.Recordcount>
		<cfinclude template="../../shopping/basket/act_recalc.cfm">
	</cfif>
	
	<!--- Make sure it doesn't redirect back to the same page --->
	<cfif FindNoCase("users.logout", attributes.xfa_logout_successful)>
		<cfset attributes.xfa_logout_successful = "fuseaction=page.home">
	</cfif>
	
	<!--- Redirect user back to the page they were on --->
	<cfinclude template="dsp_result.cfm">

</cfif>


