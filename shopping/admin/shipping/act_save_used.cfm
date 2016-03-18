
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to process the complete list of shipping methods, to set which ones are being used by the store. Called by shopping.admin&shipping=method --->

<!--- CSRF Check --->
<cfset keyname = "customMethodList">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfquery name="GetMethods" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT ID FROM #Request.DB_Prefix#CustomMethods
</cfquery>

<cfloop query="GetMethods">

	<cfset Priority = attributes['Priority' & ID]>
		
	<cfif NOT isNumeric(Priority) OR Priority IS 0>
		<cfset Priority = 99>
	</cfif>	

	<cfif StructKeyExists(attributes,'Used' & ID)>
		
		<cfset Used = 1>

		<cfquery name="UpdateMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#CustomMethods
			SET Used = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Used#">,
			Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">
			WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
		</cfquery>

	<cfelse>
		<cfquery name="UpdateMethod2" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#CustomMethods
		SET Used = 0,
		Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ID#">
		</cfquery>
	</cfif>

</cfloop>

<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfset Application.objShipping.getCustomMethods()>

<!---------------------------->
<cfoutput>
<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
alert('Your changes have been saved!');
location.href = "#self#?fuseaction=shopping.admin&shipping=settings&redirect=yes#request.token2#";
</script>
</cfprocessingdirective>
</cfoutput>


