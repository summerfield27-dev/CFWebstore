<!--- CFWebstore, version 6.50 --->

<!--- Called from users.addressbook circuit this template saves a customer record as the user's default billing, shipping, account address, OR updates the billing or shipping address on an order. --->

<!--- CSRF Check --->
<cfset keyname = "addressbookEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<cfset ErrorMessage="">
<cfparam name="attributes.selected_id" default="">

<!--- Only allow updates to orders for order managers --->
<cfmodule template="../../access/secure.cfm"
	keyname="shopping"
	requiredPermission="2"
	/>

<!--- Check that an address has been selected --->
<cfif len(attributes.selected_id)>

	<cfswitch expression = "#attributes.show#">

		<!--- Make selected address the default Customer address (users.customer_id) --->
		<cfcase value="customer">
				
			<cfquery name="UpdateUser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Users
				SET Customer_ID = <cfqueryparam value="#attributes.selected_id#" cfsqltype="cf_sql_integer">
				WHERE User_ID = <cfqueryparam value="#Session.User_ID#" cfsqltype="cf_sql_integer">
			</cfquery>
			
			<cfinclude template="../act_set_registration_permissions.cfm">
	
		</cfcase>

		<!--- Make selected address the default shipping address (users.shipto) --->		
		<cfcase value="ship">
	
			<cfquery name="UpdateUser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Users
				SET ShipTo = <cfqueryparam value="#attributes.selected_id#" cfsqltype="cf_sql_integer">
				WHERE User_ID = <cfqueryparam value="#Session.User_ID#" cfsqltype="cf_sql_integer">
			</cfquery>	
			
		</cfcase>
		
		<!--- Make selected address the default Account address (account.customer_id) --->
		<cfcase value="bill">
			
			<cfinclude template="../qry_get_user.cfm">
			
			<cfquery name="UpdateAccount" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Account
				SET Customer_ID = <cfqueryparam value="#attributes.selected_id#" cfsqltype="cf_sql_integer">
				WHERE Account_ID = <cfqueryparam value="#qry_get_user.account_id#" cfsqltype="cf_sql_integer">
			</cfquery>	
			
		</cfcase>
			
			
		<!--- Make selected address the order's billing address --->
		<cfcase value="billto">
					
			<cfif isdefined("attributes.order_no") AND ispermitted>
			
				<cfquery name="UpdateOrderBillto" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					UPDATE #Request.DB_Prefix#Order_No
					SET Customer_ID = <cfqueryparam value="#attributes.selected_id#" cfsqltype="cf_sql_integer">
					WHERE Order_No = <cfqueryparam value="#attributes.order_no#" cfsqltype="cf_sql_integer">
				</cfquery>
				
			<cfelse>
			
				<cfquery name="UpdateUser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					UPDATE #Request.DB_Prefix#Users
					SET Customer_ID = <cfqueryparam value="#attributes.selected_id#" cfsqltype="cf_sql_integer">
					WHERE User_ID = <cfqueryparam value="#Session.User_ID#" cfsqltype="cf_sql_integer">
				</cfquery>
			
			</cfif>

		</cfcase>
		

		<!--- Make selected address the order's shipping address --->
		<cfcase value="shipto">

			<cfif isdefined("attributes.order_no") AND ispermitted>
			
				<cfquery name="UpdateOrderShipto" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					UPDATE #Request.DB_Prefix#Order_No
					SET ShipTo = <cfqueryparam value="#attributes.selected_id#" cfsqltype="cf_sql_integer">
					WHERE Order_No = <cfqueryparam value="#attributes.order_no#" cfsqltype="cf_sql_integer">
				</cfquery>
			
			<cfelse>
			
				<cfquery name="UpdateUser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					UPDATE #Request.DB_Prefix#Users
					SET ShipTo = <cfqueryparam value="#attributes.selected_id#" cfsqltype="cf_sql_integer">
					WHERE User_ID = <cfqueryparam value="#Session.User_ID#" cfsqltype="cf_sql_integer">
				</cfquery>	
			
			</cfif>
			
		</cfcase>
	
	</cfswitch>

	<cflocation url="#doReturn(attributes.xfa_success)##Request.Token2#" addtoken="No">

	
<!--- if no address has been selected, redisplay form --->
<cfelseif not isdefined("attributes.order_no")>
	
	<cfset ErrorMessage = "Please select your default address">

<cfelse>
	
	<cflocation url="#doReturn(attributes.xfa_success)##Request.Token2#" addtoken="No">

</cfif>

