
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of product-level discounts and discounts for the selected product. Called by dsp_price_form.cfm to display for the selectbox for discounts --->

<cfquery name="qry_Get_Discounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT Discount_ID, Name
FROM #Request.DB_Prefix#Discounts
WHERE Type3 = 0
ORDER BY Name, MinOrder
</cfquery>

<cfparam name="attributes.Product_ID" default="0">

<cfquery name="qry_Get_Prod_Discounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT Discount_ID FROM #Request.DB_Prefix#Discount_Products
WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
ORDER BY Discount_ID
</cfquery>

<cfset DiscountList = ValueList(qry_Get_Prod_Discounts.Discount_ID)>




