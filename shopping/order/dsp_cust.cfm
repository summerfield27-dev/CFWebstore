
<!--- CFWebstore, version 6.50 --->

<!--- This page is called by put_order.cfm and is used for displaying the billing information for an order --->

<cfif thistag.ExecutionMode is "Start">

	<cfparam name="Attributes.Customer_ID" default="0">
	
	<cfquery name="GetCust" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
		SELECT * FROM #Request.DB_Prefix#Customers 
		WHERE Customer_ID = <cfqueryparam value="#Attributes.Customer_ID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<!-- start shopping/order/dsp_cust.cfm -->
	<div id="dspinvoicecust" class="shopping">

	<cfoutput>
	#GetCust.FirstName# #GetCust.LastName#<br/>
	<cfif len(GetCust.Company)>#GetCust.Company#<br/></cfif>
	<cfif GetCust.Company IS NOT "PayPal Account">
	#GetCust.Address1# <br/>
	 <cfif len(GetCust.Address2)>#GetCust.Address2#<br/></cfif>
	 <cfif len(GetCust.County)>#GetCust.County# County<br/></cfif>
	#GetCust.City#, <cfif Compare(GetCust.State, "Unlisted")>#GetCust.State# <cfelse>#GetCust.State2# </cfif> #GetCust.Zip#<br/>
	<cfif len(GetCust.Country) AND GetCust.Country IS NOT Request.AppSettings.HomeCountry>#ListGetAt(GetCust.Country, 2, "^")#<br/></cfif>
		Phone: #GetCust.Phone#<br/>
		<cfif len(GetCust.Phone2)>Other Phone: #GetCust.Phone2#<br/></cfif>
	</cfif>

	 <cfif len(GetCust.Email)><a href="mailto:#GetCust.Email#">#GetCust.Email#</a><br/></cfif>
	</cfoutput>
	
	</div>
	<!-- end shopping/order/dsp_cust.cfm -->

</cfif>



