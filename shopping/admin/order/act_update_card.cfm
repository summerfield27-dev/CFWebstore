<!--- CFWebstore, version 6.50 --->

<!--- This page takes the full credit card data and updates it to only save the last 4 digits. Called from act_order.cfm and act_order_shipping.cfm --->

<!--- Remove full credit card information --->
<cfquery name="GetCard" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Card_ID FROM #Request.DB_Prefix#Order_No 
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
</cfquery>        

<cfquery name="GetCardData" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#CardData
	SET EncryptedCard = Null
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Getcard.Card_ID#">
</cfquery>


