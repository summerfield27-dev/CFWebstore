<!--- CFWebstore, version 6.50 --->

<!--- Outputs the form button to order through CRESecure. --->

<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Username, Password, CCServer
	FROM #Request.DB_Prefix#CCProcess
	WHERE Setting3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="CRESecure">
</cfquery>

<cfset session.formKeys.cre_form = CreateUUID()>

<cfset fieldlist = "firstname,lastname,company,email,phone,city,state">

<!-- start shopping/checkout/cresecure/put_cresecure.cfm -->
	<tr>
		<cfoutput>
		<td colspan="3">
		Pay securely with your credit card, click here to continue to our secure payment form.
		<br/><br/>
		<div align="center">
		<cfif GetSettings.CCServer IS "LIVE">
			<form action="https://safe.cresecure.net/securepayments/a1/cc_collection.php" method="post" >
		<cfelse>
			<form action="https://safe.sandbox-cresecure.net/securepayments/a1/cc_collection.php" method="post" >		
		</cfif>		
		<input type="hidden" name="CRESecureID" value="#GetSettings.Username#" />
		<input type="hidden" name="CRESecureAPIToken" value="#GetSettings.Password#" />		
		<input type="hidden" name="sess_id" value="#session.formKeys.cre_form#">
		<input type="hidden" name="total_amt" value="#Total#" />		
		<input type="hidden" name="total_weight" value="#Session.CheckoutVars.TotalWeight#" />
		<input type="hidden" name="order_desc" value="#Request.AppSettings.SiteName# Order" />
		<input type="hidden" name="currency_code" value="#Left(LSCurrencyFormat(10, "international"),3)#" />
		<input type="hidden" name="order_id" value="#Session.BasketNum#" />
		<!--- output billing fields ---> 
		<cfloop index="field" list="#fieldlist#">
			<input type="hidden" name="customer_#field#" value="#GetCustomer[field][1]#" />
		</cfloop>
		<!--- add additional billing fields --->
		<input type="hidden" name="customer_address" value="#GetCustomer['address1'][1]#" />
		<input type="hidden" name="customer_postal_code" value="#GetCustomer['zip'][1]#" />
		<input type="hidden" name="customer_country" value="#ListGetAt(GetCustomer['country'][1], 1, "^")#" />
		<!--- output shipping fields ---> 
		<cfif GetShipTo.RecordCount>
			<cfset shipInfo = GetShipTo>
		<cfelse>
			<cfset shipInfo = GetCustomer>		
		</cfif>
		<cfloop index="field" list="#fieldlist#">
			<input type="hidden" name="delivery_#field#" value="#shipInfo[field][1]#" />
		</cfloop>
		<!--- add additional shipping fields --->
		<input type="hidden" name="delivery_address" value="#shipInfo['address1'][1]#" />
		<input type="hidden" name="delivery_postal_code" value="#shipInfo['zip'][1]#" />
		<input type="hidden" name="delivery_country" value="#ListGetAt(shipInfo['country'][1], 1, "^")#" />
		<!--- additional info ---->
		<input type="hidden" name="allowed_types" value="Visa|MasterCard|American Express">
		<input type="hidden" name="return_url" value="#XHTMLFormat('#Request.SecureSelf#?fuseaction=shopping.checkout&step=cresecure&redirect=yes&#Session.URLToken#')#" />
		<input type="hidden" name="content_template_url" value="#XHTMLFormat('#Request.SecureSelf#?fuseaction=shopping.checkout&step=payment&show=template&useJS=no&redirect=yes&custom=#Session.BasketNum#&#Session.URLToken#')#" />
		</cfoutput>		
		<input type="submit" value="Continue" class="formbutton" />
		</form></div>
		</td></tr>
	<!-- start shopping/checkout/cresecure/put_cresecure.cfm -->
	
	
	