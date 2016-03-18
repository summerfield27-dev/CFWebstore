
<!--- CFWebstore, version 6.50 --->

<!--- Get the list of promotions for user groups, called from dsp_group_form.cfm --->

<cfquery name="qry_Get_Promotions" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Promotion_ID, Name 
	FROM #Request.DB_Prefix#Promotions
	WHERE Type4 = 1
	ORDER BY Name, StartDate
</cfquery>


