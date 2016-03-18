
<!--- CFWebstore, version 6.50 --->

<!--- Get the list of discounts for the selected category, called from dsp_category_form.cfm --->

<cfparam name="attributes.CID" default="0">

<cfquery name="qry_Get_Cat_Discounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT D.Discount_ID 
	FROM #Request.DB_Prefix#Discounts D, #Request.DB_Prefix#Discount_Categories DC
	WHERE DC.Category_ID = #attributes.CID#
	AND D.Discount_ID = DC.Discount_ID
	ORDER BY D.Name, D.MinOrder
</cfquery>

