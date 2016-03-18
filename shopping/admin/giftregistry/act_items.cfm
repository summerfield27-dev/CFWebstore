
<!--- CFWebstore, version 6.50 --->

<!--- Updates the Registry Item list. --->

<!--- CSRF Check --->
<cfset keyname = "registryItemList">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- User Check ----->
<cfloop index="GiftItem_ID" list="#attributes.ItemList#">
	
	<cfset Quantity_Requested = attributes['Quantity_Requested' & GiftItem_ID]>
	<cfset Quantity_Purchased = attributes['Quantity_Purchased' & GiftItem_ID]>
	<cfset remove = iif(StructKeyExists(attributes,'remove' & GiftItem_ID),1,0)>
	
	<!--- If Remove and nothing purchased, delete item --->
	<cfif remove AND NOT Quantity_Purchased>
	
		<cfquery name="RemoveItem" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			DELETE FROM #Request.DB_Prefix#GiftItems
			WHERE GiftItem_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GiftItem_ID#">
		</cfquery>
	
	<!--- Update Item Quantity --->
	<cfelse>
	
		<cfquery name="UpdateItem" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#GiftItems
			SET 
			Quantity_Requested = <cfqueryparam cfsqltype="cf_sql_integer" value="#Quantity_Requested#">,
			Quantity_Purchased = <cfqueryparam cfsqltype="cf_sql_integer" value="#Quantity_Purchased#">
			WHERE GiftItem_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GiftItem_ID#">
		</cfquery>
	
	</cfif>

</cfloop>
			
