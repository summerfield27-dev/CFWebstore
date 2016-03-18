<!--- CFWebstore, version 6.50 --->

<!--- Used to process the UPS registration form. Called by shopping.admin&shipping=upsregister --->

<!--- CSRF Check --->
<cfset keyname = "upsRegister">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<!--- Get UPS Settings --->
<cfquery name="UPS" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Debug FROM #Request.DB_Prefix#UPS_Settings
</cfquery>

<cfparam name="ErrorMessage" default="">

<!--- Make sure registration request only started once --->
<cfif NOT isDefined("Session.StartRegister")>

<cftry>

<cfinvoke component="#Request.CFCMapping#.shipping.upssecurity" 
	method="getAccessKey" 
	returnvariable="getKey" 
	argumentcollection="#Form#"
	debug="#UPS.Debug#"
	test="#YesNoFormat(Request.DemoMode)#">
	
<!--- Output debug if returned --->
<cfif len(getKey.Debug)>
	<cfoutput>#putDebug(getKey.Debug)#</cfoutput>
</cfif>

<!--- If registration is successful, save the access key to the database --->
<cfif getKey.Success>

	<cfquery name="UpdUPS" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#UPS_Settings
		SET AccessKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getKey.AccessKey#">
	</cfquery>

	<!--- Process the Registration --->
	
	<cfinvoke component="#Request.CFCMapping#.shipping.upssecurity" 
		method="doUPSRegister" 
		returnvariable="Register" 
		argumentcollection="#Form#"
		debug="#UPS.Debug#"
		test="#YesNoFormat(Request.DemoMode)#">
		
		<!--- Output debug if returned --->
		<cfif len(Register.Debug)>
			<cfoutput>#putDebug(Register.Debug)#</cfoutput>
		</cfif>
	
	<!--- If registration is successful, save the username and password to the database --->
	<cfif Register.Success>
	
		<cfparam name="Session.StartRegister" default="Yes">
	
		<cfquery name="UpdUPS" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#UPS_Settings
			SET Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Register.username#">,
			Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Register.Password#">,
			AccountNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Register.AccountNo#">,
			OrigZip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Zip#">
		</cfquery>
	
	<cfelse>
	
		<cfset ErrorMessage = Register.ErrorMessage>
	
	</cfif>

<cfelse>

	<cfset ErrorMessage = getKey.ErrorMessage>

</cfif>


<cfcatch type="Any">
	<cfset ErrorMessage = "There was an error in running the UPS Registration Tool. Please contact the system administrator for assistance.">
</cfcatch>
</cftry>

<cfelse>

	<cfset ErrorMessage = "The registration request has already been processed. Please do not submit the registration more than once.">

</cfif>

