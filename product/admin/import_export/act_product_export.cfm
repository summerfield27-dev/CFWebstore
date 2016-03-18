
<!--- CFWebstore, version 6.50 --->

<!--- Runs the function to download the product data to an excel spreadsheet. Called by product.admin&do=export --->

<cfif isDefined("attributes.submit_export")>

	<!--- CSRF Check --->
	<cfset keyname = "prodExport">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<cfparam name="attributes.cid_list" default="">

	<cfscript>
		attributes.error_message = "";
		fieldlist = "";
		querylist = "";
		fieldtypes = "";
		
		// Determine the column list 
		for (num=1; num lte 30; num=num+1) {
			colInfo = attributes['Field_' & num];
			if (len(colInfo)) {				
				colName = ListGetAt(colInfo, 1, "^");
				colType = ListGetAt(colInfo, 2, "^");
				fieldlist = ListAppend(fieldlist, colName);
				if ( colName IS "Product_ID") {
					querylist = ListAppend(querylist, "P.Product_ID");
				} else {
					querylist = ListAppend(querylist, colName);
				}
				//determine the datatype
				if (ListFindNoCase('integer,tinyint', colType))
					datatype = 'integer';
				else if (ListFindNoCase('double,float', colType))
					datatype = 'double';
				else if (ListFindNoCase('bit', colType))
					datatype = 'bit';
				else if (ListFindNoCase('timestamp', colType))
					datatype = 'date';
				else 
					datatype = 'varchar';
				fieldtypes = ListAppend(fieldtypes, datatype);
			}
		}
		
		numfields = ListLen(fieldlist);
		
		if (NOT len(attributes.cid_list)) 
			attributes.error_message = "No categories selected";
		
		else if (NOT len(fieldlist)) 
			attributes.error_message = "No product export fields selected";
	</cfscript>
		
	
	<cfif NOT len(attributes.error_message)>	
		<cfquery name="Download_products" datasource="#Request.ds#"	username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT #querylist# 
			FROM #Request.DB_Prefix#Products P
			<cfif NOT ListFind(attributes.cid_list, "ALL")>
				INNER JOIN #Request.DB_Prefix#Product_Category PCat ON P.Product_ID = PCat.Product_ID
				WHERE PCat.Category_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid_list#" list="true">)
			</cfif>
		</cfquery>

		<cfif NOT Download_products.Recordcount>
			<cfset attributes.error_message = "No products found to export!">	
		</cfif>
	</cfif>
	
	<cfif NOT len(attributes.error_message)>
		<cfset csvstring = CSVFormat(Download_products, fieldlist, fieldtypes, """")>
		
		<!--- Set file path --->
		<cfset FilePath = GetDirectoryFromPath(ExpandPath(Request.StorePath))>
		<cfset theFile = "#FilePath#files#request.slash#products.csv">
		
		<!--- Write out the file --->
		<cffile action="WRITE" file="#theFile#" output="#csvstring#" nameconflict="OVERWRITE" addnewline="Yes">
		
		<!--- Send down to the user --->
		<cfheader name="Content-Disposition" value="attachment; filename=products.csv">
		<cfcontent type="text/csv" file="#theFile#" deletefile="Yes" reset="No">
	<cfelse>
		<cfinclude template="../../../includes/admin_confirmation.cfm">
	</cfif>	
		
</cfif>	

