
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to create the affiliate code and set up the user as an affiliate. Called by shopping.affiliate&do=register --->

<!--- CSRF Check --->
<cfset keyname = "affiliateRegister">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfquery name="GetAffiliate" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Affiliate_ID, Username
	FROM #Request.DB_Prefix#Users
	WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
</cfquery>

<cfif getaffiliate.affiliate_id is 0 OR NOT len(getaffiliate.affiliate_id)>
	
	<cfinclude template="../../users/qry_get_user_settings.cfm">
	
	<cfset Code = "">
	
	<!--- UUID to tag new inserts --->
	<cfset NewIDTag = CreateUUID()>
	<!--- Remove dashes --->
	<cfset NewIDTag = Replace(NewIDTag, "-", "", "All")>
	
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
		VALUES 
			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">, 
			<cfqueryparam cfsqltype="cf_sql_double" value="#get_User_Settings.AffPercent#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Code#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Aff_Site#">)
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
	
	<cfset attributes.affiliate_id = AddAffiliate.newID>
	
	<cfquery name="EditUser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Users
		SET Affiliate_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.affiliate_id#">
		WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
	</cfquery>
	
	<!--- Send Admin email notice --->
	<cfset LineBreak = Chr(13) & Chr(10)>
	<cfset MergeContent = "User Name:  #GetAffiliate.Username#" & LineBreak & LineBreak>
	<cfset MergeContent = MergeContent & "Affiliate Code:  #Code#" & LineBreak & LineBreak>
	<cfset MergeContent = MergeContent & "Site URL:  #attributes.Aff_Site#" & LineBreak & LineBreak>
	
	<cfinvoke component="#Request.CFCMapping#.global" 
		method="sendAutoEmail" Email="#Request.AppSettings.Webmaster#" 
		MailAction="NewAffiliateNotice" MergeContent="#MergeContent#">
		

<cfelse>

	<!--- Make sure code is not already in use --->
	<cfquery name="GetCode" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT AffCode FROM #Request.DB_Prefix#Affiliates
		WHERE Affiliate_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getaffiliate.affiliate_id#">
	</cfquery>

	<cfset code = getcode.affcode>

</cfif>



