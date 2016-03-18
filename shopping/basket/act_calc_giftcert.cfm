<!--- CFWebstore, version 6.50 --->

<!--- This page is used to check for a gift certificate and determine if it is valid. Called from do_checkout_basket.cfm and checkout\customer\act_check_code.cfm --->

<cfset Credits = 0>

<cfparam name="GApproved" default="No">

<cfif isDefined("attributes.Coupon") AND len(attributes.Coupon)>
	<cfquery name="GetCert" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Certificates
	WHERE Cert_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Coupon)#">
	AND (StartDate IS NULL OR StartDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
	AND (EndDate IS NULL OR EndDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
	AND Valid <> 0
	</cfquery>	
	
	<cfif GetCert.RecordCount>
		<cfset GApproved = "Yes">
		<cfset Credits = GetCert.CertAmount>
	</cfif>	
	
</cfif>
		
<cfif Credits IS 0 AND len(Session.Gift_Cert)>
	<!--- Check any current gift certificate in memory --->
	<cfquery name="GetSavedCert" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#Certificates
		WHERE Cert_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Gift_Cert#">
		AND (StartDate IS NULL OR StartDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		AND (EndDate IS NULL OR EndDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		AND Valid <> 0
	</cfquery>	
	
	<cfif GetSavedCert.RecordCount>
		<cfset GApproved = "Yes">
		<cfset Credits = GetSavedCert.CertAmount>
		<cfset CheckCode = Session.Gift_Cert>
	</cfif>


</cfif>	



