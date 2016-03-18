
<!--- CFWebstore, version 6.50 --->

<!--- This page is called by put_order.cfm and is used for displaying the shipping information for an order --->
<cfif thistag.ExecutionMode is "Start">

	<cfparam name="Attributes.ShipTo" default="0">

	<cfquery name="GetShip" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows=1>
	SELECT * FROM #Request.DB_Prefix#Customers 
	WHERE Customer_ID = <cfqueryparam value="#Attributes.ShipTo#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>

	<!-- start shopping/order/dsp_shipto.cfm -->
	<div id="dspinvoiceshipto" class="shopping">
	<cfoutput>
	#GetShip.FirstName# #GetShip.LastName#<br/>
	<cfif len(GetShip.Company)>#GetShip.Company#<br/></cfif>
	#GetShip.Address1#<br/>
	 <cfif len(GetShip.Address2)>#GetShip.Address2#<br/></cfif>
	#GetShip.City#, <cfif Compare(GetShip.State, "Unlisted")>#GetShip.State# <cfelse>#GetShip.State2# </cfif> #GetShip.Zip#<br/>
	<cfif len(GetShip.Country) AND GetShip.Country IS NOT Request.AppSettings.HomeCountry>#ListGetAt(GetShip.Country, 2, "^")#<br/></cfif>
	<cfif len(GetShip.Phone)>Phone: #GetShip.Phone#<br/></cfif>
	<cfif len(GetShip.Phone2)>Other Phone: #GetShip.Phone2#<br/></cfif>
	<cfif GetShip.Email IS NOT ""><a href="mailto:#GetShip.Email#">#GetShip.Email#</a><br/></cfif>
 

	</cfoutput>
	</div>
	<!-- end shopping/order/dsp_shipto.cfm -->
</cfif>


