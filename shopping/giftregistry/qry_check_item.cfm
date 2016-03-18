
<!--- CFWebstore, version 6.50 --->

<!--- Checks if a registry item is still available. Called by shopping.giftregistry --->
<cfquery name="CheckProd" dbtype="query">
	SELECT * FROM qry_Get_Products
	WHERE Product_ID = #qry_get_items.Product_ID#
</cfquery>

<!--- If this product was found, and is using option quantities, check that they exist in the database still --->
<cfif CheckProd.Recordcount>
	<cfquery name="CheckOptions"  dbtype="query">
		SELECT * FROM qry_get_Opt_Choices
		WHERE Option_ID = #qry_get_items.OptQuant#
		AND Choice_ID = #qry_get_items.OptChoice#
	</cfquery>
</cfif>