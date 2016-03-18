
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the tracking information for an order. Called by shopping.tracking --->

<cfset order_no = attributes.ordernum - Get_Order_Settings.BaseOrderNum>

<cfparam name="attributes.Shipper" default="UPS">

<!--- Get order information --->
<cfquery name="qry_get_tracking" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT O.Order_No, O.Shipper, O.Tracking, C.Zip
	FROM #Request.DB_Prefix#Order_No O, #Request.DB_Prefix#Customers C
	WHERE O.Customer_ID = C.Customer_ID
	AND O.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_no#">
</cfquery>

<cfquery name="qry_get_PO_tracking" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT PO.Tracking
	FROM #Request.DB_Prefix#Order_No O, #Request.DB_Prefix#Order_PO PO
	WHERE O.Order_No = PO.Order_No
	AND O.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_no#">
	AND PO.Shipper = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipper#">
</cfquery>


