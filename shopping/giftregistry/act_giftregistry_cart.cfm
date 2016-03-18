
<!--- CFWebstore, version 6.50 --->

<!--- This template adds content of gift registry to the cart --->

<!--- Loop through the registry items --->
<cfloop index="num" list="#attributes.ItemList#">

	<!--- Fulfilled items will not have form field --->
	<cfparam name="attributes.Quantity_Add#num#" default="">

	<!--- If Quantity then add to cart --->
	<cfif isNumeric(attributes['Quantity_Add' & num])>

	 	<cfset attributes.Quantity = attributes['Quantity_Add' & num]>
		
	 	<!--- Look up the item --->
		<cfquery name="Item" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
			SELECT * FROM #Request.DB_Prefix#GiftItems
			WHERE GiftItem_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#num#">
		</cfquery>
	 
		<!--- Add item to the basket --->
	 	<cfif Item.Recordcount>
		
			<!--- Move the item information into attributes scope --->
			<cfloop index="fieldname" list="#Item.ColumnList#">
				<cfset attributes[fieldname] = Item[fieldname][1]>
			</cfloop> 
			
			<cfset Application.objCart.doAddCartItem(argumentcollection=attributes)>
			
		</cfif>
		
	</cfif>
	
</cfloop>

