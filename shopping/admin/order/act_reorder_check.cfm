
<!--- CFWebstore, version 6.50 --->

<!--- This page checks to see if the new product inventory level is at or below the product re-order level. If so, an email is generated to the store admin. --->

<!--- Called from act_remove_inventory.cfm and in the checkout area from act_save_order.cfm --->

<!--- Look up product's re-order level --->
<cfquery name="reorder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Name, Reorder_Level, NumInStock, SKU 
	FROM #Request.DB_Prefix#Products 
	WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Product_ID#">
</cfquery>

<!--- if it exists, compare to current inventory level --->
<cfif Request.AppSettings.InvLevel IS NOT "None" AND len(reorder.reorder_level) and reorder.reorder_level IS NOT 0 AND reorder.reorder_level gte reorder.NumInStock>

	<!--- send an email to the site admin ---->

<cfmail to="#get_order_settings.OrderEmail#"
        from="#request.appsettings.merchantemail#"
        subject="Time To Reorder"
		server="#request.appsettings.email_server#" port="#request.appsettings.email_port#">
		<cfmailparam name="Message-id" value="<#CreateUUID()#@#ListGetAt(request.appsettings.merchantemail, 2, "@")#>">
		<cfmailparam name="Reply-To" Value="#request.appsettings.merchantemail#">

It's time to reorder #reorder.name# (#reorder.SKU#). 
The current inventory level of this product is now #reorder.NumInStock# 
and you have set the re-order level at #reorder.reorder_level#.

</cfmail>

</cfif>



