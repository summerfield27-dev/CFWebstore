
<!--- CFWebstore, version 6.50 --->

<!--- Performs actions on gift certificates: add, edit and delete. Called by shopping.admin&certificate=act --->

<!--- CSRF Check --->
<cfset keyname = "certificateEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfif isNumeric(attributes.Order_No)>
	<cfset Ordernum = attributes.Order_No-Get_Order_Settings.BaseOrderNum>
<cfelse>
	<cfset Ordernum = 0>
</cfif>
			
<cfswitch expression="#mode#">
	<cfcase value="i">

		<!--- Generate Cert_Code --->	
		<cfinclude template="act_generate_code.cfm">
						
		<cfquery name="AddCert" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Certificates
		(Cert_Code, Cust_Name, CertAmount, InitialAmount, Order_No, StartDate, EndDate, Valid)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Cert_Code#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Cust_Name)#">,
			<cfqueryparam cfsqltype="cf_sql_double" value="#attributes.CertAmount#">, 
			<cfqueryparam cfsqltype="cf_sql_double" value="#attributes.CertAmount#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Ordernum#" null="#YesNoFormat(Ordernum IS 0)#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.StartDate#" null="#YesNoFormat(NOT isDate(attributes.StartDate))#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.EndDate#" null="#YesNoFormat(NOT isDate(attributes.EndDate))#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Valid#">
			)
		</cfquery>	
				
	</cfcase>
					
	<cfcase value="u">
			
		<cfif submit is "Delete">
				
			<cfquery name="DeleteCert" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#Certificates
			WHERE Cert_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Cert_ID#">
			</cfquery>		
								
		<cfelse><!---- EDIT ---->
			
			<cfquery name="UpdCert" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Certificates
			SET 
			Cust_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Cust_Name)#">,
			CertAmount = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.CertAmount#">, 
			InitialAmount = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.InitialAmount#">,
			Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ordernum#" null="#YesNoFormat(Ordernum IS 0)#">,
			StartDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.StartDate#" null="#YesNoFormat(NOT isDate(attributes.StartDate))#">,
			EndDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.EndDate#" null="#YesNoFormat(NOT isDate(attributes.EndDate))#">,
			Valid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Valid#">
			WHERE Cert_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Cert_ID#">
			</cfquery>
				
			</cfif><!---- update ---->
		
		</cfcase>

	</cfswitch>	
	
