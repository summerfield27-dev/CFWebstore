
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to calculate an estimated shipping cost for the shopping cart. Called by fuseaction=shopping.basket --->
<!--- This page should be called before put_ship_estimator.cfm --->
	

<cfif attributes.ShowEstimator>

	<!--- Get list of all shippers currently used --->
	<cfset ShippersList = ValueList(ShipSettings.ShipType)>
	<cfset CustomType = "">
	<cfset totalMethods = 0>
	
	<!--- Get the table of active shipping methods for each shipping type used --->	
	<cfset allMethods = StructNew()>
	
		<cfloop query="ShipSettings">
			<cfset strMethods = StructNew()>
			<cfset strMethods.ShipType = ShipSettings.ShipType>
			<cfset strMethods.qryMethods = Application.objShipping.getShipMethods(ShipSettings.ShipType)>
			<cfset allMethods[ShipSettings.ShipType] = strMethods>
			<cfset totalMethods = totalMethods + strMethods.qryMethods.RecordCount>
			<!--- Check for a custom shipping type --->
			<cfif ListFind("Price,Price2,Weight,Weight2,Items",ShipSettings.ShipType)>
				<cfset CustomType = ShipSettings.ShipType>
			</cfif>
		
		</cfloop>	
	
	<cfset refresh_vars = "yes">
	<cfinclude template="../../checkout/act_get_checkout_vars.cfm">

	<cfparam name="attributes.est_zipcode" default="">
	<cfparam name="attributes.est_shipmethod" default="">
	<cfparam name="attributes.est_shipstate" default="">
	<cfparam name="theType" default="">
	<cfparam name="methodID" default="">
	<cfparam name="theMethod" default="">
	<cfparam name="attributes.est_shipcountry" default="#Request.AppSettings.HomeCountry#">

	<cfscript>
		// Check if the shipping method choice and zip has been saved in memory
		if (NOT len(attributes.est_shipmethod) AND isDefined("Session.EstShipping")) {
			attributes.est_zipcode = Session.EstShipping.Zipcode;
			attributes.est_shipmethod = Session.EstShipping.ShipMethod;
			attributes.est_shipstate = Session.EstShipping.ShipState;
			attributes.est_shipcountry = Session.EstShipping.ShipCountry;
		}
		
		//If no shipping methods, set so custom shipping will work
		else if (totalMethods IS 0) {
			attributes.est_zipcode = "99999";
			attributes.est_shipmethod = "#CustomType#^999^Standard Shipping";
		}
		
		//If custom shipping method, display a default shipping amount
		else if (NOT len(attributes.est_shipmethod) AND len(CustomType)) {
			attributes.est_zipcode = "99999";
			attributes.est_shipmethod = "#CustomType#^#allMethods[CustomType].qryMethods.ID[1]#^#allMethods[CustomType].qryMethods.Name[1]#";
		}
	
		EstShipping = StructNew();
		EstShipping.Zipcode = attributes.est_zipcode;
		EstShipping.ShipMethod = attributes.est_shipmethod;
		EstShipping.ShipState = attributes.est_shipState;
		EstShipping.ShipCountry = attributes.est_shipcountry;
		
		//Save current values back to the session
		Session.EstShipping = EstShipping;
		
		// Determine location
		if (CompareNoCase(attributes.est_shipcountry, Request.AppSettings.HomeCountry) IS 0) 
			ShipLocation = "Domestic";
		else
			ShipLocation = "International";
		
		// Set freight costs for domestic or international
		if (Compare(ShipLocation, "Domestic") IS 0)
			TotalFreight = FreightCost.Domestic;
		else
			TotalFreight = FreightCost.Intl;
	</cfscript>
	
	<!--- Continue if information found --->
	<cfif len(attributes.est_zipcode) AND ListLen(attributes.est_shipmethod, "^") GT 1>
	
		<cfset theMethod = ListGetAt(attributes.est_shipmethod, 3, "^")>
		<cfset methodID = ListGetAt(attributes.est_shipmethod, 2, "^")>
		<cfset theType = ListGetAt(attributes.est_shipmethod, 1, "^")>
		
		<!--- Get just the settings for this type of shipping --->
		<cfquery name="theseSettings" dbtype="query">
			SELECT * FROM ShipSettings
			WHERE ShipType LIKE '#theType#'
		</cfquery>
		
		<cfif TotalShip IS NOT 0>
		
			<!--- load temporary tables --->
			<cfinclude template="../../checkout/customer/act_newcustomer.cfm">	
			
			<!--- Update the temporary user tables with the selected zip code --->
			<cfquery name="UpdCustomer" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#TempCustomer 
				SET Zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.est_zipcode#">,
				State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.est_shipstate#">,
				Country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.est_shipcountry#">
				WHERE TempCust_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
			</cfquery>
			
			<cfquery name="UpdShipTo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#TempShipTo 
				SET Zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.est_zipcode#">,
				State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.est_shipstate#">,
				Country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.est_shipcountry#">
				WHERE TempShip_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
			</cfquery>
			
			<!--- get customer queries --->
			<cfinclude template="../../checkout/customer/qry_get_tempcustomer.cfm">
			<cfinclude template="../../checkout/customer/qry_get_tempshipto.cfm">
			
			<!--- Calculate the shipping rate --->
			<cfswitch expression="#theType#">
				
				<cfcase value="FedEx">
					<cfinclude template="act_fedex.cfm">
				</cfcase>
				
				<cfcase value="UPS">
					<cfinclude template="act_upstools.cfm">
				</cfcase>
				
				<cfcase value="USPS">
					<cfinclude template="act_uspostal.cfm">
				</cfcase>
				
				<cfcase value="Intershipper">
					<cfinclude template="act_intershipper.cfm">
				</cfcase>
				
				<cfcase value="Price,Price2,Weight,Weight2,Items">
					<cfinclude template="act_custom.cfm">
				</cfcase>
	
			</cfswitch>		
			
			<!--- If a shipping amount was returned, add the handling percentage and base rate --->
			<cfif isDefined("est_shipamount")>

				<!--- Check if this is a free shipping amount --->
				<cfif Session.CheckoutVars.TotalBasket GT theseSettings.freeship_min AND ListFind(theseSettings.freeship_shipIDs, methodID)>
					<cfset est_shipamount = 0>
				<cfelse>
					<cfset est_handling = Session.CheckoutVars.TotalCost * theseSettings.ShipHand>
					<cfset est_shipamount = est_shipamount + theseSettings.ShipBase + est_handling>
					<cfset est_shipamount = Round(est_shipamount*100)/100>
				</cfif>
				
			</cfif>
		
		<cfelse>
			<!--- TotalShip IS 0 --->
			<cfset est_shipamount = 0>
			
		
		</cfif>
	
	</cfif>	

</cfif>

<!--- If store is set to combine shipping and freight, add freight amount --->
<cfif isDefined("est_shipamount") AND NOT theseSettings.ShowFreight AND TotalFreight IS NOT 0>
	<cfset est_shipamount = est_shipamount + TotalFreight>
	<cfset TotalFreight = 0>
</cfif>
		