
<!--- CFWebstore, version 6.50 --->

<!--- This template is called by any of the detail pages to output a list of features that the detail item appears in. The output is a feature Listing. Called by feature.related

REQUIRED: DETAIL_TYPE -- Feature (Item), Product, etc.  --->

<!--- Related Features --->
<cfquery name="GetRelatedFeatures" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT F.Name, F.Feature_ID, F.Short_Desc
FROM #Request.DB_Prefix#Features F, #Request.DB_Prefix#Feature_#attributes.DETAIL_TYPE# FD
WHERE F.Feature_ID = FD.Feature_ID 
AND FD.#attributes.DETAIL_TYPE#_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DETAIL_ID#">
AND F.Display = 1
AND F.Approved = 1
AND (F.Start <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR F.Start IS NULL)
AND (F.Expire >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> OR F.Expire IS NULL)
</cfquery>



