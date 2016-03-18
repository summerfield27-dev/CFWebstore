<!--- CFWebstore, version 6.50 --->

<!--- Saves product information. Called by product.admin&do=info --->

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<!--- if not full product admin, make sure they have access to this product --->
<cfif NOT ispermitted>
	<cfmodule template="../../../access/useraccess.cfm" ID="#attributes.Product_ID#">
	<cfset editproduct = useraccess>
<cfelse>
	<cfset editproduct = "yes">
</cfif>

<cfif editproduct>
	
	<!--- CSRF Check --->
	<cfset keyname = "prodInfoForm">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">

	<!--- Get current custom data for the product --->
	<cfinclude template="qry_get_custominfo.cfm">
	
	<!--- Loop through custom fields. If data entered, insert/update it. If not, delete any old data --->
	<cfloop index="CustomID" list="#attributes.customfields#">
	
		<cfif len(Trim(attributes['Custom' & CustomID]))>
		<!--- Check if this is an update --->
			<cfquery name="CheckInfo" dbtype="query">
				SELECT Custom_ID FROM qry_Get_Custominfo
				WHERE Custom_ID = #CustomID#
			</cfquery>
	
			<cfif CheckInfo.RecordCount>
				<cfquery name="UpdateInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					UPDATE #Request.DB_Prefix#Prod_CustInfo
					SET CustomInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes['Custom' & CustomID])#">
					WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
					AND Custom_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CustomID#">				
				</cfquery>
			<cfelse>
				<cfquery name="InsertInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					INSERT INTO #Request.DB_Prefix#Prod_CustInfo
					(Product_ID, Custom_ID, CustomInfo)
					VALUES 
					(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#CustomID#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes['Custom' & CustomID])#"> )
				</cfquery>
			</cfif>
	
		<cfelse>
			<!--- No info entered, delete old data --->
			<cfquery name="DeleteInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Prod_CustInfo
				WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				AND Custom_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CustomID#">		
			</cfquery>
		
		</cfif>
	
	</cfloop>
	
	
	<!--- Update other info fields --->
	<cfquery name="UpdateProduct" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Products
		SET Goog_Brand = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Goog_Brand)#">,
			Goog_Condition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Goog_Condition)#">,
			Goog_Expire = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.Goog_Expire#" null="#YesNoFormat(NOT isDate(attributes.Goog_Expire))#">,
			Goog_Prodtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Goog_Prodtype)#">
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
	</cfquery>
	
	<cfset mode="u">	
	<cfinclude template="dsp_act_confirmation.cfm">
				
<!--- user did not have access --->
<cfelse>
	<cfset attributes.message = "You do not have access to edit this product.">
	<cfset attributes.XFA_success = "fuseaction=product.admin&do=list&cid=0">
	<cfinclude template="../../../includes/admin_confirmation.cfm">

</cfif>


