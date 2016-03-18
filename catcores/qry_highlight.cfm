
<!--- CFWebstore, version 6.50 --->

<!--------------- Get Highlighted and/or Sale Categories --------------------->

<!--- Used by the catcore_highlight.cfm and dsp_sale.cfm pages  --->

<cfquery name="qry_get_Hcats" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Category_ID, Name, Short_Desc, Sm_Image, Sm_Title, Highlight, Sale
	FROM #Request.DB_Prefix#Categories 
	WHERE Display = 1

	<cfif attributes.new is 1 AND attributes.onsale is 1>
		AND Highlight = 1 OR Sale = 1
	<cfelseif attributes.new is 0 AND attributes.onsale is 0>
		AND 1=0
	<cfelseif attributes.new is "1">
 		AND Highlight = 1
	<cfelseif attributes.onsale is "1">
 		AND Sale = 1
	</cfif>
ORDER BY Priority, Name
</cfquery>



