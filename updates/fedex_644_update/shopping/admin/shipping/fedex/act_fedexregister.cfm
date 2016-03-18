<!--- CFWebstore®, version 6.44 --->

<!--- CFWebstore® is ©Copyright 1998-2009 by Dogpatch Software, All Rights Reserved. This code may not be copied or sold without permission of the original author. Dogpatch Software may be contacted at info@cfwebstore.com --->

<!--- Used to process the FedEx Registration form. Called by shopping.admin&shipping=fedexregister --->

<!--- Get FedEx Settings --->
<cfquery name="FedEx" datasource="#Request.DS#" username="#Request.user#" 
password="#Request.pass#" maxrows="1">
SELECT Debug, Logging FROM #Request.DB_Prefix#FedEx_Settings
</cfquery>

<cfparam name="attributes.error_message" default="">

<!--- <cftry>  --->

<cfinvoke component="#Request.CFCMapping#.shipping.fedex" 
	method="doFedExRegistration" 
	returnvariable="RegResult" 
	argumentcollection="#Form#"
	debug="#FedEx.Debug#"
	logging="#FedEx.Logging#"
	test="#YesNoFormat(Request.DemoMode)#" />
	
<!--- Output debug if returned --->
<cfif len(RegResult.Debug)>
	<cfinvoke component="#Request.CFCMapping#.global" method="putDebug" debugtext="#RegResult.Debug#">
</cfif>

<!--- <cfdump var="#Result#"> --->
<!--- If subscription is successful, save the meter number to the database --->
<cfif RegResult.Success>

	<cfquery name="UpdFedEx" datasource="#Request.DS#" username="#Request.user#" password="#Request.pass#">
	UPDATE #Request.DB_Prefix#FedEx_Settings
	SET UserKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RegResult.UserKey#">, 
	Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RegResult.Password#">,
	AccountNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.accountno)#">
	</cfquery>
	
	<cfset Form['userKey'] = RegResult.UserKey>
	<cfset Form['password'] = RegResult.Password>
	
	<!--- Run the subscription transaction --->
	<cfinvoke component="#Request.CFCMapping#.shipping.fedex" 
		method="doFedExSubscribe" 
		returnvariable="SubResult" 
		argumentcollection="#Form#"	
		debug="#FedEx.Debug#"
		logging="#FedEx.Logging#"
		test="#YesNoFormat(Request.DemoMode)#">
		
	<!--- Output debug if returned --->
	<cfif len(SubResult.Debug)>
		<cfinvoke component="#Request.CFCMapping#.global" method="putDebug" debugtext="#SubResult.Debug#">
	</cfif>
		
	<cfif SubResult.Success>
		
		<cfif StructKeyExists( attributes, 'ShipToSame' ) >
			<cfset attributes.Shipping_State = attributes.State>
			<cfset attributes.Shipping_Zip = attributes.Zip>
			<cfset arguments.Shipping_Country = attributes.Country>
		</cfif>
	
		<cfquery name="UpdFedEx" datasource="#Request.DS#" username="#Request.user#" password="#Request.pass#">
			UPDATE #Request.DB_Prefix#FedEx_Settings
			SET MeterNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SubResult.MeterNum#">,
			OrigZip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipping_Zip#">,
			OrigState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipping_State#">,
			OrigCountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipping_Country#">
		</cfquery>
		
		<!--- Run the version capture transaction --->
		<cfinvoke component="#Request.CFCMapping#.shipping.fedex" 
			method="doFedExVerCapture" 
			returnvariable="CapResult" 
			accountno="#attributes.AccountNo#"
			meternum="#SubResult.MeterNum#"
			UserKey = "#RegResult.UserKey#"
			UserPass = "#RegResult.Password#"
			debug="#FedEx.Debug#"
			logging="#FedEx.Logging#"
			test="#YesNoFormat(Request.DemoMode)#">
			
		<!--- Output debug if returned --->
		<cfif len(CapResult.Debug)>
			<cfinvoke component="#Request.CFCMapping#.global" method="putDebug" debugtext="#CapResult.Debug#">
		</cfif>
			
		<cfif NOT CapResult.Success>
			<cfset attributes.error_message = CapResult.ErrorMessage>
		</cfif>
	
	<cfelse>

		<cfset attributes.error_message = SubResult.ErrorMessage>

	</cfif>

<cfelse>

	<cfset attributes.error_message = RegResult.ErrorMessage>

</cfif>

<!---  <cfcatch type="Any">
	<cfset attributes.error_message = "There was an error in running the FedEx Subscription. Please contact the system administrator for assistance.">
</cfcatch>
</cftry>  --->

