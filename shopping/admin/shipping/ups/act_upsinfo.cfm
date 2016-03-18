<!--- CFWebstore, version 6.50 --->

<!--- Used to process the UPS information form. Called by shopping.admin&shipping=upsinfo --->

<cfparam name="ErrorMessage" default="">

<!--- CSRF Check --->
<cfset keyname = "upsInfo">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<cftry> 

<cfinvoke component="#Request.CFCMapping#.shipping.upssecurity" 
	method="UPSInfo" 
	returnvariable="Info" 
	argumentcollection="#Form#">

<!--- Save the encrypted information to the database --->

	<cfquery name="UpdUPS" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#UPS_Settings
	SET AccessKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Info.AccessKey#">,
		Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Info.username#">,
		Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Info.password#">,
		AccountNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.accountno#">,
		OrigCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.OrigCity#">,
		OrigZip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.OrigZip#">,
		OrigCountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.OrigCountry#">
	</cfquery>


 <cfcatch type="Any">
	<cfset ErrorMessage = "There was an error in saving your UPS Account Information. Please contact the system administrator for assistance.">
</cfcatch>
</cftry> 






