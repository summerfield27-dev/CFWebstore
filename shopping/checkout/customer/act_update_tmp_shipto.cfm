
<!--- CFWebstore, version 6.50 --->

<!--- Used to temporarily save the shipping information entered in the address form. Called by shopping.checkout (step=address) --->

<!--- Remove any current shipping record --->

<cfquery name="RemoveRecord" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#TempShipTo
	WHERE TempShip_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>

<!--- if shipping to a separate address, enter into the temporary table ---->
<cfif attributes.shiptoyes is "0">

	<!--- Copy the form variables into a new structure --->
	<cfset ShipInfo = StructNew()>
	<cfloop collection="#attributes#" item="thefield">
		<cfif ListLen(thefield, "_") GT 1>
			<cfset newname = ListGetAt(thefield, 1, "_")>
			<cfset ShipInfo[newname] = attributes[thefield]>	
		</cfif>
	</cfloop>
	
	<!--- Check for blank state field --->
	<cfif NOT len(attributes.State_shipto)>
		<cfset ShipInfo['State'] = "Unlisted">
	</cfif>
	
	<!--- Add the shipping record --->
	<cfset ShipInfo.TableName = "TempShipTo">
	<cfset TempShip_ID = Application.objUsers.AddCustomer(argumentcollection=ShipInfo)>
		

</cfif>

