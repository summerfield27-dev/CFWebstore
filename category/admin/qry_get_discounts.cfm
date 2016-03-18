
<!--- CFWebstore, version 6.50 --->

<!--- Get the list of discounts for categories, called from dsp_category_form.cfm --->

<cfquery name="qry_Get_Discounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT Discount_ID, Name 
FROM #Request.DB_Prefix#Discounts
WHERE Type3 = 1 
ORDER BY Name, MinOrder
</cfquery>




