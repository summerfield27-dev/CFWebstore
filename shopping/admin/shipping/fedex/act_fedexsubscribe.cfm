<!--- CFWebstore, version 6.50 --->

<!--- Used to process the FedEx Subsciption form. Called by shopping.admin&shipping=fedexregister --->

<!--- Get FedEx Settings --->
<cfquery name="FedEx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Debug, Logging FROM #Request.DB_Prefix#FedEx_Settings
</cfquery>

<cfparam name="attributes.error_message" default="">

<!--- <cftry>  --->

<cfinvoke component="#Request.CFCMapping#.shipping.fedex" 
	method="doFedExSubscribe" 
	returnvariable="Subscribe" 
	argumentcollection="#Form#"
	debug="#FedEx.Debug#"
	logging="#FedEx.Logging#"
	test="#YesNoFormat(Request.DemoMode)#">
	
<!--- Output debug if returned --->
<cfif len(Subscribe.Debug)>
	<cfoutput>#putDebug(Subscribe.Debug)#</cfoutput>
</cfif>

<!--- If subscription is successful, save the meter number to the database --->
<cfif Subscribe.Success>

	<cfquery name="UpdFedEx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#FedEx_Settings
	SET AccountNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AccountNo#">, 
	MeterNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Subscribe.MeterNum#">
	</cfquery>
	
	<!--- Run the zip inquiry transaction --->
	<cfinvoke component="#Request.CFCMapping#.shipping.fedex" 
		method="doFedExZipInquiry" 
		returnvariable="ZipInquiry" 
		accountno="#attributes.AccountNo#"
		meternum="#Subscribe.MeterNum#"
		Zip="#attributes.Zip#"
		Country="#attributes.Country#"
		debug="#FedEx.Debug#"
		logging="#FedEx.Logging#"
		test="#YesNoFormat(Request.DemoMode)#">
		
	<!--- Output debug if returned --->
	<cfif len(ZipInquiry.Debug)>
		<cfoutput>#putDebug(ZipInquiry.Debug)#</cfoutput>
	</cfif>
		
	<cfif ZipInquiry.Success>
	
		<cfset LocationID = ZipInquiry.LocationID>
	
		<!--- Run the version capture transaction --->
		<cfinvoke component="#Request.CFCMapping#.shipping.fedex" 
			method="doFedExVerCapture" 
			returnvariable="Capture" 
			accountno="#attributes.AccountNo#"
			meternum="#Subscribe.MeterNum#"
			LocationID="#LocationID#"
			debug="#FedEx.Debug#"
			logging="#FedEx.Logging#"
			test="#YesNoFormat(Request.DemoMode)#">
			
		<!--- Output debug if returned --->
		<cfif len(Capture.Debug)>
			<cfoutput>#putDebug(Capture.Debug)#</cfoutput>
		</cfif>
			
		<cfif NOT Capture.Success>
			<cfset attributes.error_message = Capture.ErrorMessage>
		</cfif>
		
	
	<cfelse>

		<cfset attributes.error_message = ZipInquiry.ErrorMessage>

	</cfif>

<cfelse>

	<cfset attributes.error_message = Subscribe.ErrorMessage>

</cfif>

<!---  <cfcatch type="Any">
	<cfset attributes.error_message = "There was an error in running the FedEx Subscription. Please contact the system administrator for assistance.">
</cfcatch>
</cftry>  --->

