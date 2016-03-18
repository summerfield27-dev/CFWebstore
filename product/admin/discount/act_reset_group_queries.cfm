
<!--- CFWebstore, version 6.50 --->

<!--- Used to update the cached queries with the discount data set by group. Called by product.admin&discount=act --->

<cfquery name="get_groups"  datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Group_ID FROM #Request.DB_Prefix#Groups
</cfquery>		

<cfloop query="get_groups">

	<!----- RESET Discount Groups query ---->
	<cfset Application.objDiscounts.qryGroupDiscounts(get_groups.Group_ID, 'yes')>

</cfloop>
	
<!----- RESET Discount Groups query for un-logged in visitors ---->
<cfset Application.objDiscounts.qryGroupDiscounts(0, 'yes')>	
