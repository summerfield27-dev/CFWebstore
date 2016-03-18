
<!--- CFWebstore, version 6.50 --->

<!--- This Template put a button in the shopping cart to allow user to add the products in the basket to a Gift Registry. Called from shopping/basket/dsp_basket.cfm.

If there is only one gift registry, the ID is passed. --->

<!--- User Must be logged in ---->
<!--- <cfif Session.User_ID> --->

	<!--- Check if user has a Registry ---->
<!--- 	<cfset variables.uid = Session.User_ID>
	<cfinclude template="../qry_get_giftregistries.cfm"> --->
	
	<!--- If a registry exists, display link --->
	<!--- <cfif qry_Get_registries.recordcount>	 --->	
	<!-- start shopping/giftregistry/manager/put_registry_product_button.cfm -->
		&nbsp;<input type="submit" value="Add to Registry" name="AddtoRegistry" class="formbutton"/>	
		<!-- end shopping/giftregistry/manager/put_registry_basket_button.cfm -->
	<!--- </cfif> --->
<!--- </cfif> --->
