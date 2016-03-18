
<!--- CFWebstore, version 6.50 --->

<!--- Get the list of promotions for the selected group, called from dsp_group_form.cfm --->

<cfparam name="attributes.GID" default="0">

<cfquery name="qry_Get_Group_Promotions" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Promotion_ID FROM #Request.DB_Prefix#Promotion_Groups
	WHERE Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GID#">
	ORDER BY Promotion_ID
</cfquery>

<cfset PromotionList = ValueList(qry_Get_Group_Promotions.Promotion_ID)>

