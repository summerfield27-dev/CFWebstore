
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to process the complete list of Intershipper methods, to set which ones are being used by the store. Called by shopping.admin&shipping=intship_methods --->

<cfquery name="GetMethods" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT ID FROM #Request.DB_Prefix#IntShipTypes
</cfquery>

<cfloop query="GetMethods">

	<cfset Priority = Evaluate("attributes.Priority#ID#")>
		
	<cfif NOT isNumeric(Priority) OR Priority IS 0>
		<cfset Priority = 99>
	</cfif>

	<cfif isDefined("attributes.Used#ID#")>
	<cfset Used = 1>
	
	<cfquery name="UpdateMethod" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#IntShipTypes
	SET Used = #Used#,
	Priority = #Priority#
	WHERE ID = #ID#
	</cfquery>
	
	<cfelse>
	<cfquery name="UpdateMethod2" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#IntShipTypes
	SET Used = 0,
	Priority = #Priority#
	WHERE ID = #ID#
	</cfquery>
	</cfif>

</cfloop>

<cfinclude template="act_reset_intship.cfm">



<cfoutput>
<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
alert('Your changes have been saved!');
location.href = "#self#?fuseaction=shopping.admin&shipping=intship_methods&redirect=yes#request.token2#";
</script>
</cfprocessingdirective>
</cfoutput>



