
<!--- CFWebstore, version 6.50 --->

<!--- Performs the updates from the List Edit Form for categories. Called by category.admin&category=actform --->

<!--- CSRF Check --->
<cfset keyname = "categoryListEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<!--- Create the string with the filter parameters --->	
<cfset addedpath="&fuseaction=category.admin&category=list">
<cfset fieldlist = "pid,cid,catcore_id,name,accesskey,catdisplay,highlight,sale">
<cfinclude template="../../includes/act_setpathvars.cfm">	


<cfloop index="Category_ID" list="#attributes.CategoryList#">

<cfset Priority = attributes["Priority" & Category_ID]>
<cfset CColumns = Val(attributes["CColumns" & Category_ID])>
<cfset PColumns = Val(attributes["PColumns" & Category_ID])>
<cfset Display = iif(StructKeyExists(attributes,'CatDisplay' & Category_ID),1,0)>
<cfset Highlight = iif(StructKeyExists(attributes,'Highlight' & Category_ID),1,0)>
<cfset Sale = iif(StructKeyExists(attributes,'Sale' & Category_ID),1,0)>


<cfif NOT isNumeric(Priority) OR Priority IS 0>
<cfset Priority = 9999>
</cfif>

<cfquery name="UpdateCategory" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
UPDATE #Request.DB_Prefix#Categories
SET Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">,
CColumns = <cfqueryparam cfsqltype="cf_sql_integer" value="#CColumns#" null="#YesNoFormat(CColumns LTE 0)#">,
PColumns = <cfqueryparam cfsqltype="cf_sql_integer" value="#PColumns#" null="#YesNoFormat(PColumns LTE 0)#">,
Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#">,
Highlight = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Highlight#">,
Sale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Sale#">
WHERE Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Category_ID#">
</cfquery>
</cfloop>

<!--- Reset cached query --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfinclude template="../../category/qry_get_topcats.cfm">


		

		
			
