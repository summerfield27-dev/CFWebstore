
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of pages. Called by page.admin&do=list|listform. Also used on dsp_page_form.cfm to output the list of page to select the menu position for the page being added/edited. --->

<cfquery name="qry_get_Pages" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
<cfif Request.dbtype IS "Access">
	SELECT IIF(A.Title_Priority=0,B.Title_Priority,A.Title_Priority) AS titlepriority,
<cfelse>
	SELECT CASE WHEN A.Title_Priority=0 THEN B.Title_Priority ELSE A.Title_Priority END AS titlepriority,
</cfif>
A.Title_Priority AS istitle, A.Parent_ID, A.Priority, B.Title_Priority, A.Page_ID, A.Sm_Image, A.Sm_Title, A.Page_URL, A.Page_Name, A.Href_Attributes, A.Display, A.Parent_ID, A.System
FROM #Request.DB_Prefix#Pages A, #Request.DB_Prefix#Pages B
WHERE 
A.Parent_ID = B.Page_ID
ORDER BY A.Display, 1, 2 DESC, A.Priority, A.PageAction
</cfquery>


