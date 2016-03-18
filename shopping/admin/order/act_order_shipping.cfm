<!--- CFWebstore, version 6.50 --->

<!--- Processes the Order Shipping Screen. Updates the order information and sends emails. Called by shopping.admin&order=shipping --->

<!--- CSRF Check --->
<cfset keyname = "orderShipping">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- First, retrieve the current status of this order, used for inventory tracking purposes --->
<cfquery name="GetInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
	SELECT Process, Filled, Void, InvDone FROM #Request.DB_Prefix#Order_No
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
</cfquery>

	
<!--- By default, do not add or remove inventory --->
<cfset RemoveInt = "No">
	
	<!--- Update Order --->
	<cfquery name="UpdateOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Order_No
	SET Filled = 1,
	Process = 1,
	Tracking = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Tracking)#">,
	Shipper = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipper#">,
	DateFilled = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>
	
	<!--- Remove full credit card information --->
	<cfinclude template="act_update_card.cfm">

	<!--- If set to email dropshipper when order filled, send emails --->
	<cfif get_order_settings.EmailDrop and len(get_order_settings.DropEmail) AND get_order_settings.EmailDropWhen IS "Filled">
		<cfset Order_No = attributes.Order_No>
		<cfinclude template="act_maildrop.cfm">
	</cfif>
 
	<!--- If Email customer check, send email with tracking numbers --->
	<cfif attributes.EmailCustomer is "1">
		<cfinclude template="act_emailtrack.cfm"> 
	</cfif>	
	
	<!--- Check if we need to remove inventory --->
	<cfif GetInfo.Process IS 0 AND GetInfo.Filled IS 0>
		<cfset RemoveInt = "Yes">
	<cfelseif GetInfo.Void IS 1>
		<cfset RemoveInt = "Yes">
	</cfif>
	
	<cfif RemoveInt AND NOT GetInfo.InvDone>
		<cfinclude template="act_remove_inventory.cfm">
	</cfif>
	

