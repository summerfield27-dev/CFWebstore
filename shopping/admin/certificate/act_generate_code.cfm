
<!--- CFWebstore, version 6.50 --->

<!--- Generates a random code for the gift certificate. You can modify the settings on the rdm_password custom tag to change the code that will be generated. Called by act_certificate.cfm --->

<cfset Cert_Code = "">

<cfloop condition="NOT len(Cert_Code)">

	<!--- Get Password --->
	<cfinvoke component="#Request.CFCMapping#.global" method="randomPassword" 
	returnvariable="NewCert" Length="15" AllowNums="yes" AllowSpecials="no" Case="Upper" 
	ExcludedValues="0,O,1,I">	
	
	<!--- Make sure code is not already in use --->
	<cfquery name="GetCert" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Cert_ID FROM #Request.DB_Prefix#Certificates
		WHERE Cert_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NewCert.new_password#">
	</cfquery>
	
	<cfif GetCert.RecordCount>
		<cfset Cert_Code = "">
	<cfelse>
		<cfset Cert_Code = NewCert.new_password>
	</cfif>

</cfloop>



