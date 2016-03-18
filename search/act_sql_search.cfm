
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to perform the SQL search. Called from act_search.cfm --->


<cfparam name="attributes.string" default="">
<cfparam name="attributes.all_words" default="1">

<!--- remove any characters, other than alphanumeric, space or dashes --->
<cfset search_string = Trim(ReReplace(attributes.string, "[^\w+^\s+^\-]", " ", "All"))>

<cfif Session.User_ID>
 	 <cfset key_loc = ListContainsNoCase(session.userPermissions,'contentkey_list',';')>
 	 <cfif key_loc>
  	 	<cfset accesskeys = ListLast(ListGetAt(session.userPermissions,key_loc,';'),'^')>
		<cfset accesskeys = ListAppend(accesskeys,'0')>
  	</cfif>
</cfif>
<cfparam name="accesskeys" default="0">


<cfquery name="GetProducts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT Product_ID, Name, Short_Desc, SKU, '' AS ChoiceName
FROM #Request.DB_Prefix#Products P
WHERE 
 	AccessKey IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">) 
	AND NOT EXISTS (SELECT C.AccessKey FROM #Request.DB_Prefix#Categories C 
		INNER JOIN #Request.DB_Prefix#Product_Category PCat ON C.Category_ID = PCat.Category_ID
		 WHERE PCat.Product_ID = P.Product_ID
		AND (C.Display = 0 OR (
			C.AccessKey IS NOT NULL AND C.AccessKey <> 0 
			AND C.AccessKey NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">) ) 
			) )
	AND
	(Sale_Start IS NULL OR Sale_Start < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) AND 
	(Sale_End IS NULL OR Sale_End ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) AND 
	<cfif Request.AppSettings.InvLevel IS NOT "None" AND NOT Request.AppSettings.OutOfStock>
	NumInStock > 0 AND</cfif>
<cfif len(search_string)> (
	<cfset sqltype = "longvarchar">
	<cfset fieldname = "Long_Desc">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset fieldname = "Short_Desc">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset sqltype = "varchar">
	<cfset fieldname = "Name">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset fieldname = "SKU">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset fieldname = "Metadescription">
	<cfinclude template="../customtags/safesearch.cfm"> OR
	<cfset fieldname = "Keywords">
	<cfinclude template="../customtags/safesearch.cfm"> ) AND
<cfelse>
	1=1 AND 
</cfif>
	Display = 1 
	
<!---- Add search by Option SKU, this is not currently working on MSSQL --->
<cfif Request.dbtype IS NOT "MSSQL">
	<cfif len(search_string)> 
	UNION <cfif Request.dbtype IS "MSSQL">ALL</cfif>
	SELECT P.Product_ID, P.Name, P.Short_Desc, PC.SKU, PC.ChoiceName
	FROM #Request.DB_Prefix#Products P
	INNER JOIN #Request.DB_Prefix#Product_Options PO ON P.Product_ID = PO.Product_ID
	INNER JOIN #Request.DB_Prefix#ProdOpt_Choices PC ON PO.Option_ID = PC.Option_ID
	<!---LEFT JOIN #Request.DB_Prefix#StdOpt_Choices SC ON PO.Std_ID = SC.Std_ID--->
	WHERE 
	P.AccessKey IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">) 
		AND NOT EXISTS (SELECT C.AccessKey FROM #Request.DB_Prefix#Categories C 
			INNER JOIN #Request.DB_Prefix#Product_Category PCat ON C.Category_ID = PCat.Category_ID
			 WHERE PCat.Product_ID = P.Product_ID
			AND (C.Display = 0 OR (
				C.AccessKey IS NOT NULL AND C.AccessKey <> 0 
				AND C.AccessKey NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">) ) 
				) )
		AND
		(P.Sale_Start IS NULL OR P.Sale_Start < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) AND 
		(P.Sale_End IS NULL OR P.Sale_End ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)  
		<cfif Request.AppSettings.InvLevel IS NOT "None" AND NOT Request.AppSettings.OutOfStock>
		AND P.NumInStock > 0 
			AND ( P.OptQuant = 0 
				OR ( PO.Option_ID = P.OptQuant 
						AND PC.NumInStock > 0 )
				)
		</cfif>
		AND P.Display = 1
		AND PC.Display = 1
		AND  
			<cfset fieldname = "PC.SKU">
			<cfinclude template="../customtags/safesearch.cfm">
	</cfif>
</cfif>
ORDER BY Name
</cfquery>
		  
<cfquery name="GetCategories" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT Category_ID, Name, Short_Desc
FROM #Request.DB_Prefix#Categories
WHERE Display = 1 AND 
AccessKey IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">) 
<cfif len(search_string)> AND (
	<cfset sqltype = "longvarchar">
	<cfset fieldname = "Long_Desc">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset fieldname = "Short_Desc">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset sqltype = "varchar">
	<cfset fieldname = "Name">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset fieldname = "Metadescription">
	<cfinclude template="../customtags/safesearch.cfm"> OR
	<cfset fieldname = "Keywords">
	<cfinclude template="../customtags/safesearch.cfm"> )
</cfif>
ORDER BY Name
</cfquery>

<cfquery name="GetFeatures" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT Feature_ID, Name, Short_Desc
FROM #Request.DB_Prefix#Features F
WHERE AccessKey IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">) AND
	NOT EXISTS (SELECT C.AccessKey FROM #Request.DB_Prefix#Categories C 
	INNER JOIN #Request.DB_Prefix#Feature_Category FCat ON C.Category_ID = FCat.Category_ID
	 WHERE FCat.Feature_ID = F.Feature_ID
	AND (C.Display = 0 OR (
			C.AccessKey IS NOT NULL AND C.AccessKey <> 0 AND C.AccessKey NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true"> )) 
			) ) AND
<cfif len(search_string)> (
<cfset sqltype = "longvarchar">
	<cfset fieldname = "Long_Desc">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset fieldname = "Short_Desc">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset sqltype = "varchar">
	<cfset fieldname = "Name">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset fieldname = "Author">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset fieldname = "Metadescription">
	<cfinclude template="../customtags/safesearch.cfm"> OR
	<cfset fieldname = "Keywords">
	<cfinclude template="../customtags/safesearch.cfm"> ) AND
</cfif>
Display = 1 
AND Approved = 1
AND (Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR Start is null)
AND (Expire >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR Expire is null)
ORDER BY Name
</cfquery>

<cfquery name="GetPages" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT Page_ID, Page_Name, PageText, Page_URL
FROM #Request.DB_Prefix#Pages
WHERE Display = 1
AND AccessKey IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#accesskeys#" list="true">) 
AND Page_URL <> 'none'
<cfif len(search_string)> AND (
	<cfset sqltype = "longvarchar">
	<cfset fieldname = "PageText">
	<cfinclude template="../customtags/safesearch.cfm"> OR 
	<cfset sqltype = "varchar">
	<cfset fieldname = "Page_Name">
	<cfinclude template="../customtags/safesearch.cfm"> )
</cfif>
ORDER BY Page_Name
</cfquery>

<cfquery name="CountProducts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT COUNT(Product_ID) AS TotalProducts
	FROM #Request.DB_Prefix#Products
</cfquery>
		  
<cfquery name="CountCategories" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT COUNT(Category_ID) AS TotalCategories
	FROM #Request.DB_Prefix#Categories
</cfquery>
		  
<cfquery name="CountFeatures" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT COUNT(Feature_ID) AS TotalFeatures
	FROM #Request.DB_Prefix#Features
</cfquery>

<cfquery name="CountPages" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT COUNT(Page_ID) AS TotalPages
	FROM #Request.DB_Prefix#Pages
</cfquery>

<cfset Results = GetProducts.RecordCount + GetCategories.RecordCount + GetFeatures.RecordCount + GetPages.RecordCount>
<cfset Searched = CountProducts.TotalProducts + CountCategories.TotalCategories + CountFeatures.TotalFeatures + CountPages.TotalPages>




