
<!--- CFWebstore, version 6.50 --->

<!--- Saves the payment settings for the store. Called by shopping.admin&payment=cards --->
<!--- CSRF Check --->
<cfset keyname = "paymentSettings">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Enter credit card changes --->	
<cfquery name="EditCards" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#CreditCards
	SET Used = 1
	WHERE ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CreditCards#" list="true">)
</cfquery>	

<cfquery name="EditCards" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#CreditCards
	SET Used = 0
	WHERE ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CreditCards#" list="true">)
</cfquery>	

<!--- Only save card data if using Shift4 processing --->
<cfif CCProcess IS NOT "Shift4OTN">
	<cfset attributes.StoreCardInfo = 0>
</cfif>


	<cfquery name="EditSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#OrderSettings
		SET AllowOffline = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.AllowOffline#">,
		StoreCardInfo = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.StoreCardInfo#">,
		UseCVV2 = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseCVV2#">,
		OnlyOffline = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.OnlyOffline#">,
		UseCRESecure = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseCRESecure#">,
		AllowPO = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.AllowPO#">,
		UsePayPal = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UsePayPal#">,
		PayPalMethod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.PayPalMethod)#">,
		PayPalEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.PayPalEmail)#">,
		PayPalServer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.PayPalServer)#">,
		PayPalLog = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.PayPalLog#">,
		PDT_Token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.PDT_Token)#">,
		CCProcess = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CCProcess#">,
		UseBilling = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.UseBilling#">,
		OfflineMessage = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Trim(attributes.OfflineMessage)#">
	</cfquery>

	<!--- Get New Settings --->
	<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
	<cfinclude template="../../qry_get_order_settings.cfm">

<!-----
	<cfmodule template="../../../customtags/format_admin_form.cfm"
		box_title="Payment Manager"
		width="350"
		required_fields="0"
		>
		
	<tr><td align="center" class="formtitle">
		<br/>
		Payment Options Saved
		<cfoutput>
		<form action="#self#?fuseaction=shopping.admin&payment=cards#request.token2#" method="post">
		</cfoutput>
		<input class="formbutton" type="submit" value="Continue"/>
		</form>	
			
	</td></tr>
	</cfmodule> 	
---->
