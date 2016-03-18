
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of gift certificates. Called by shopping.admin&certificate=list --->

<cfloop index="namedex" list="Cert_Code,Cust_Name,CertAmount,Order_No,current,valid">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>

<cfparam name="attributes.Show" default="recent">
				
<cfquery name="qry_get_certificates" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#" >
	SELECT *
	FROM #Request.DB_Prefix#Certificates
	WHERE 1 = 1

<cfif attributes.show is "recent">
	AND StartDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd("ww", -2, Now())#">
</cfif>
<cfif len(trim(attributes.Cert_Code))>
		AND Cert_Code like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.Cert_Code#%"> </cfif>
<cfif len(trim(attributes.Cust_Name))>
		AND Cust_Name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.Cust_Name#%"> </cfif>
<cfif len(trim(attributes.CertAmount))>
		AND CertAmount = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.CertAmount#"> </cfif>
<cfif isNumeric(attributes.Order_No)>
		AND Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#(attributes.Order_No-Get_Order_Settings.BaseOrderNum)#"> </cfif>
<cfif trim(attributes.current) is "current">
		AND (EndDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
		OR EndDate IS NULL)	</cfif>
<cfif trim(attributes.current) is "expired">
		AND EndDate < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> </cfif>
<cfif trim(attributes.current) is "scheduled">
		AND StartDate > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">	</cfif>		
<cfif len(trim(attributes.valid))>
		AND Valid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.valid#"> </cfif>	
	ORDER BY Cert_Code
</cfquery>
		
		


		