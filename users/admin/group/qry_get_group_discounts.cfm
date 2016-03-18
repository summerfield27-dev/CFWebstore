
<!--- CFWebstore, version 6.50 --->

<!--- Get the list of discounts for the selected group, called from dsp_group_form.cfm --->

<cfparam name="attributes.GID" default="0">

<cfquery name="qry_Get_Group_Discounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Discount_ID FROM #Request.DB_Prefix#Discount_Groups
	WHERE Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GID#">
	ORDER BY Discount_ID
</cfquery>

<cfset DiscountList = ValueList(qry_Get_Group_Discounts.Discount_ID)>

