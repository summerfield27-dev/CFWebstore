
<!--- CFWebstore, version 6.50 --->

<!--- Updates the Registry Item list. --->

<!--- CSRF Check --->
<cfset keyname = "registryItemsList">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- User Check ----->
<cfloop index="GiftItem_ID" list="#attributes.ItemList#">

<cfset Quantity_Add = attributes['Quantity_Add' & GiftItem_ID]>
<cfset Quantity_Requested = attributes['Quantity_Requested' & GiftItem_ID]>
<cfset Quantity_Purchased = attributes['Quantity_Purchased' & GiftItem_ID]>
<cfset remove = iif(StructKeyExists(attributes,'remove' & GiftItem_ID),1,0)>

<!--- Check if this is a recurring item and still found in the database --->
<cfquery name="qry_check_recur" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT P.Recur FROM #Request.DB_Prefix#GiftItems G, #Request.DB_Prefix#Products P
	WHERE G.GiftItem_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GiftItem_ID#">
	AND G.Product_ID = P.Product_ID
</cfquery>

<cfif NOT qry_check_recur.Recordcount>
	<cfset remove = 1>
<cfelseif qry_check_recur.recur>
	<cfset Quantity_Add = 0>
</cfif>
	
<!--- If Remove and nothing purchased, delete item --->
<cfif remove AND NOT Quantity_Purchased>

	<cfquery name="RemoveItem" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#GiftItems
		WHERE GiftItem_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GiftItem_ID#">
	</cfquery>

<!--- Update Item Quantity --->
<cfelseif remove OR len(Quantity_Add)>

	<cfif Remove>
		<cfset NewQuantity = Quantity_Purchased>
	<cfelse>
		<cfset NewQuantity = Quantity_Requested + Quantity_Add>
	</cfif>	

	<cfquery name="UpdateItem" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#GiftItems
		SET 
		Quantity_Requested = <cfqueryparam cfsqltype="cf_sql_integer" value="#NewQuantity#">
		WHERE GiftItem_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GiftItem_ID#">
	</cfquery>

</cfif>

</cfloop>
			
