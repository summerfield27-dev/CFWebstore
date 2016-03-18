
<!--- CFWebstore, version 6.50 --->

<!--- Get the list of discounts for user groups, called from dsp_group_form.cfm --->

<cfquery name="qry_Get_Discounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Discount_ID, Name 
	FROM #Request.DB_Prefix#Discounts
	WHERE Type5 = 1
	ORDER BY Name, MinOrder
</cfquery>


