
<!--- CFWebstore, version 6.50 --->

<!--- This is a custom tag designed specifically for checking that the user has access to a specific function. Used in conjunction with the user product permission and gift registry. --->

<!--- Settings for form confirmation --->
<cfparam name="attributes.XFA_success" default="fuseaction=product.admin&do=list&cid=0">
<cfparam name="attributes.type" default="product">

<!--- Check a product query recordcount if passed in --->
<cfparam name="attributes.recordcount" default="0">

<!--- Check the item ID if passed in --->
<cfparam name="attributes.ID" default="0">

<cfset permitted = false>

<cfif attributes.ID IS NOT 0>

	<cfswitch expression="#attributes.type#">
		<cfcase value="registry">
			<cfquery name="CheckAccess" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT GiftRegistry_ID FROM #Request.DB_Prefix#GiftRegistry
				WHERE GiftRegistry_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
				AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
			</cfquery>
		</cfcase>
		<cfcase value="stdoption">
			<cfquery name="CheckAccess" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Std_ID FROM #Request.DB_Prefix#StdOptions
				WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
				AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
			</cfquery>
		</cfcase>
		<cfcase value="stdaddon">
			<cfquery name="CheckAccess" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Std_ID FROM #Request.DB_Prefix#StdAddons
				WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
				AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
			</cfquery>
		</cfcase>
		<cfdefaultcase>
			<cfquery name="CheckAccess" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT Product_ID FROM #Request.DB_Prefix#Products
				WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
				AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
			</cfquery>
		</cfdefaultcase>	
	</cfswitch>

	<cfif CheckAccess.RecordCount>
		<cfset permitted = true>
	</cfif>
	
<cfelseif attributes.recordcount IS NOT 0>

	<cfset permitted = true>
	
</cfif>


<cfif ThisTag.HasEndTag>
	<cfif NOT permitted>
		<cfswitch expression="#attributes.type#">
			<cfcase value="registry">
				<cfset attributes.message = "You do not have permission to access this gift registry.">
			</cfcase>
			<cfcase value="product">
				<cfset attributes.message = "You do not have permission to edit this product.">
			</cfcase>
			<cfcase value="copy">
				<cfset attributes.message = "You do not have permission to copy this product.">
			</cfcase>
			<cfcase value="stdoption">
				<cfset attributes.message = "You do not have permission to edit this standard option.">
				<cfset attributes.XFA_success = "fuseaction=product.admin&stdoption=list">
			</cfcase>
			<cfcase value="stdaddon">
				<cfset attributes.message = "You do not have permission to edit this standard addon.">
				<cfset attributes.XFA_success = "fuseaction=product.admin&stdaddon=list">
			</cfcase>
			<cfcase value="option">
				<cfset attributes.message = "You do not have permission to edit this option.">
			</cfcase>
			<cfcase value="addon">
				<cfset attributes.message = "You do not have permission to edit this addon.">
			</cfcase>
		</cfswitch>
		
		<cfinclude template="../includes/admin_confirmation.cfm">
		<cfset caller.useraccess = false>
		<cfexit method="EXITtag">
	<cfelse>
		<cfset caller.useraccess = true>
	</cfif>						
<cfelse>
	<cfif NOT permitted>
		<cfset caller.useraccess = false>
	<cfelse>
		<cfset caller.useraccess = true>
	</cfif>
</cfif>

