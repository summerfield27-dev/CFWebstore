
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the information for a purchase order for the PO shipping page. Called by shopping.admin&po=ship --->

<cfquery name="qry_ship"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT O.Order_PO_ID, O.Order_No, O.PO_No, O.Account_ID, O.PrintDate, O.Notes, O.PO_Status,
	O.PO_Open, O.ShipDate, O.Shipper, O.Tracking, N.Customer_ID, N.ShipTo, N.ShipType, 
	N.DateOrdered, C.FirstName, C.LastName, C.Email, A.Account_Name
	FROM #Request.DB_Prefix#Order_PO O, #Request.DB_Prefix#Order_No N, 
		 #Request.DB_Prefix#Customers C, #Request.DB_Prefix#Account A
	WHERE O.Order_PO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_po_ID#">
	AND O.Order_No = N.Order_No
	AND N.Customer_ID = C.Customer_ID
	AND O.Account_ID = A.Account_ID
</cfquery>
		
