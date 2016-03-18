
<!--- CFWebstore, version 6.50 --->

<!--- Updates the picklists. Called by home.admin&picklists=edit --->

<!--- CSRF Check --->
<cfset keyname = "picklistEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfquery name="update_picklists" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#PickLists
		SET 
		<cfloop index="thisfield" list="#fieldlist#">
			#thisfield# = <cfif len(attributes[thisfield])>
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Trim(attributes[thisfield])#">
						<cfelse>NULL</cfif><cfif listlast(fieldlist) is not "#thisfield#">, </cfif>
		</cfloop>
		WHERE Picklist_ID = 1
</cfquery>
		



