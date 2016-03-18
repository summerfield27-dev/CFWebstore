
<!--- CFWebstore, version 6.50 --->

<!--- Used to select the list of products when setting the discounted product for a promotion. Called by product.admin&promotion=disc_product --->

<!--- If no category selected, show uncategorized products --->

<cfif NOT isdefined("attributes.Action")>
	<cfset attributes.nocat = 1>
	<cfset attributes.pid = 0>

<cfelseif isdefined("attributes.Action") AND ListFind("view_subcats,view_parent",attributes.Action)>

	<cfif qry_get_categories.recordcount>
		<cfset attributes.cid = qry_get_categories.category_id>
	</cfif>
	
	
</cfif>

<cfinclude template="../../../product/admin/product/qry_get_products.cfm">


