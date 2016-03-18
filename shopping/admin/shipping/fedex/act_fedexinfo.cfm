<!--- CFWebstore, version 6.50 --->

<!--- Used to process the Fedex information form. Called by shopping.admin&shipping=fedexinfo --->

<cfparam name="ErrorMessage" default="">

<!--- CSRF Check --->
<cfset keyname = "fedexInfo">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

	<cfquery name="UpdFedex" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#FedEx_Settings
	SET UserKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Userid#">,
		Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.password#">,
		AccountNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.accountno#">,
		MeterNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.meternum#">,
		OrigState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipping_State#">,
		OrigZip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipping_Zip#">,
		OrigCountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipping_Country#">
	</cfquery>




