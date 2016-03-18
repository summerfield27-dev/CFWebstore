<!--- CFWebstore, version 6.50 --->

<!--- Used to save the Custom Shipping Settings for the store. Called by shopping.admin&shipping=customsettings --->

<!--- CSRF Check --->
<cfset keyname = "customSettings">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfquery name="UpdCustom" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#CustomShipSettings
	SET ShowShipTable = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowShipTable#">,
	MultPerItem = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.MultPerItem#">,
	CumulativeAmounts = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.CumulativeAmounts#">,
	MultMethods = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.MultMethods#">,
	Debug = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Debug#">
</cfquery>

<!--- Update Cached Settings --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfset Application.objShipping.getCustomSettings()>



