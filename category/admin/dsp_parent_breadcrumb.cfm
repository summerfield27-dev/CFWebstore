
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to create a breadcrumb list of the parent categories for a select category, used for the list views in various admin pages. ------->

<cfparam name="attributes.PID" default="0"><!--- used in category admin --->
<cfparam name="attributes.CID" default=""><!--- used for other admins --->
<cfparam name="attributes.separator" default="&raquo;">
<cfparam name="addedpath" default="&">

<cfif len(attributes.cid)>
	<cfset id = attributes.cid>
	<cfset id_type = "cid">
<cfelse>
	<cfset id = attributes.pid>
	<cfset id_type = "pid">
</cfif>

<cfquery name="qry_get_cat" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT 	ParentIDs, ParentNames, Name
	FROM 	#Request.DB_Prefix#Categories
	WHERE	Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
</cfquery>

<cfset replacetext = "&#id_type#=#id#">
<cfset linkstring="#Replace(addedpath,replacetext,'')#">
<cfset linkstring="#RemoveChars(linkstring,1,1)#">
<cfset ParentString = "">

<!--- Change the 0 below to adjust when the parent categories show up --->
<cfif Listlen(Trim(qry_get_cat.ParentIDs)) GT 0>
	<cfloop index="num" from="1" to="#Listlen(Trim(qry_get_cat.ParentIDs))#">
		<cfif linkstring is not "">
			<cfset ParentString = ListAppend(Parentstring, "<a href=""#self#?#id_type#=", "^")>
			<cfset ParentString = Parentstring & ListGetAt(Trim(qry_get_cat.ParentIDs), num)  & "&" & linkstring & """>">
		</cfif>
		<cfset ParentString = Parentstring & ListGetAt(qry_get_cat.ParentNames, num, ":")>
		<cfif linkstring is not "">
			<cfset ParentString = Parentstring & "</a>">
		</cfif>
	</cfloop>

	<cfset ParentString = "#attributes.separator# " & Replace(ParentString, "^", " #attributes.separator# ", "ALL")>

</cfif>

<cfif id is "0">
	<cfoutput><b>Home</b></cfoutput>
<cfelse>
	<cfoutput>
	<cfif linkstring is not "">
		<a href="#self#?#linkstring#&#id_type#=0#Request.Token2#">Home</a> 
	<cfelse>
		Home
	</cfif> #ParentString# #attributes.separator# <b>#qry_get_cat.name#</b></cfoutput>
</cfif>



