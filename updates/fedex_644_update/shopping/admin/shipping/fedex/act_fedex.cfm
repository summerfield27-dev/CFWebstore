<!--- CFWebstore®, version 6.44 --->

<!--- CFWebstore® is ©Copyright 1998-2009 by Dogpatch Software, All Rights Reserved. This code may not be copied or sold without permission of the original author. Dogpatch Software may be contacted at info@cfwebstore.com --->

<!--- Used to save the FedEx Settings for the store. Called by shopping.admin&shipping=fedex --->

<cfparam name="attributes.UseGround" default="0">
<cfparam name="attributes.UseExpress" default="0">

<cfquery name="UpdFedEx" datasource="#Request.DS#" username="#Request.user#" password="#Request.pass#">
	UPDATE #Request.DB_Prefix#FedEx_Settings
	SET MaxWeight = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MaxWeight#">,
	UnitsofMeasure = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.UnitsofMeasure#">,
	Dropoff = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Dropoff#">,
	Packaging = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Packaging#">,
	<!---OrigZip = '#attributes.OrigZip#',
	OrigState = '#attributes.OrigState#',
	OrigCountry = '#attributes.OrigCountry#',--->
	UseGround = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseGround#">,
	UseExpress = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseExpress#">,
	<!---UseSmartPost = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseSmartPost#">,--->
	Logging = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Logging#">,
	Debug = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Debug#">
</cfquery>

<!--- Update Cached Settings --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfset Application.objShipping.getFedExSettings()>



