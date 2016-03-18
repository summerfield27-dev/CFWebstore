
<!--- CFWebstore, version 6.50 --->

<!--- Makes a user an affiliate by assigning an Affiliate Code. Called by users.admin&user=affiliate --->

<!--- CSRF Check --->
<cfset keyname = "affiliateEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfset message="">

<cfif attributes.percentage is "">
	<cfset attributes.percentage = 0>
</cfif>

<cfset Percent = attributes.Percentage/100>

<!--- Affiliate Update --->
<cfif attributes.Affiliate_ID IS NOT 0 AND attributes.submit_aff IS "Save">

	<cfquery name="EditAff" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Affiliates
		SET AffPercent = <cfqueryparam cfsqltype="cf_sql_double" value="#Percent#">,
		Aff_Site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Aff_Site#">
		WHERE Affiliate_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Affiliate_ID#">
	</cfquery>
	
	<cfset message="Affiliate Updated" />
	
<!--- Affiliate Removal --->
<cfelseif attributes.Affiliate_ID IS NOT 0 AND attributes.submit_aff IS "Remove">

	<!--- Update any orders for this affiliate first --->
	<cfquery name="UpdOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Order_No
		SET Affiliate = 0
		WHERE Affiliate = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.AffCode#">	
	</cfquery>
	
	<!--- Update the user account --->
	<cfquery name="UpdUser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Users
		SET Affiliate_ID = 0
		WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#">
	</cfquery>
	
	<!--- Remove the affiliate record --->
	<cfquery name="EditAff" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#Affiliates
		WHERE Affiliate_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Affiliate_ID#">
	</cfquery>
	
	<cfset message="Affiliate Removed" />
	
<!--- Add new affiliate --->
<cfelse>
	
	<!--- UUID to tag new inserts --->
	<cfset NewIDTag = CreateUUID()>
	<!--- Remove dashes --->
	<cfset NewIDTag = Replace(NewIDTag, "-", "", "All")>

	<cfset Code = "">

	<cfloop condition="NOT len(Code)">
		<!--- Generate an affiliate code --->
		<cfset r = Randomize(Minute(now())&Second(now()))>
		<cfset Code = RandRange(10000,99999)>
	
		<!--- Make sure code is not already in use --->
		<cfquery name="GetCode" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT AffCode FROM #Request.DB_Prefix#Affiliates
			WHERE AffCode = <cfqueryparam cfsqltype="cf_sql_integer" value="#Code#">
		</cfquery>
	
		<cfif GetCode.RecordCount>
			<cfset Code = "">
		</cfif>
	</cfloop>

	<cftransaction>	
				
		<cfquery name="AddAffiliate" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			<cfif Request.dbtype IS "MSSQL">
				SET NOCOUNT ON
			</cfif>
			INSERT INTO #Request.DB_Prefix#Affiliates
			(ID_Tag, AffPercent, AffCode, Aff_Site)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">, 
				<cfqueryparam cfsqltype="cf_sql_double" value="#Percent#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Code#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Aff_Site#"> )
			<cfif Request.dbtype IS "MSSQL">
				SELECT @@Identity AS newID
				SET NOCOUNT OFF
			</cfif>
		</cfquery>
		
		<!--- Get New Affiliate Number --->
		<cfif Request.dbtype IS NOT "MSSQL">
			<cfquery name="AddAffiliate" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Affiliate_ID AS newID 
			FROM #Request.DB_Prefix#Affiliates
			WHERE ID_Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">
			</cfquery>
		</cfif>

	</cftransaction>

	<cfset attributes.affiliate_ID = AddAffiliate.newID>

	<cfquery name="EditUser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Users
		SET Affiliate_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.affiliate_ID#">
		WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.UID#">
	</cfquery>
	
	<cfset message="Affiliate Added<br/><br/>The Affiliate Code for this user is #Code#">

</cfif>
		
<cfset attributes.box_title="Affiliates">
<cfinclude template="../../../includes/admin_confirmation.cfm">	
      

