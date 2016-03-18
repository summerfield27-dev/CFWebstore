
<!--- CFWebstore, version 6.50 --->

<!--- Performs the category delete. Called by act_categories.cfm --->


<cfset attributes.error_message = "">
		
<!--- Check if this category currently has subcategories under it. --->
<cfquery name="CheckCategories" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
SELECT Category_ID FROM #Request.DB_Prefix#Categories
WHERE Parent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
</cfquery>

<!--- If it has subcategories, add error message --->
<cfif CheckCategories.RecordCount IS NOT 0>
	<cfset attributes.error_message = attributes.error_message & "<br/>This category has subcategories in it. Please delete or edit them first.">

<!--- Check if the category has products assigned --->
<cfelse>	
	<cfquery name="CheckProducts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Product_ID FROM #Request.DB_Prefix#Product_Category
	WHERE Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
	</cfquery>
	
	<!--- If it has subcategories, add error message --->
	<cfif CheckProducts.RecordCount IS NOT 0>
		<cfset attributes.error_message = attributes.error_message & "<br/>This category has products in it. Please reassign them first.">
	</cfif>

</cfif>


<!--- If no products or subcategories, delete the group --->
<cfif NOT len(attributes.error_message)>

	<!--- Delete the category discounts --->
	<cfquery name="DropDiscounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#Discount_Categories
	WHERE Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
	</cfquery>

	<cfquery name="delete_images"  datasource="#Request.ds#" 
		username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Sm_Image, Lg_Image, Sm_Title, Lg_Title
		FROM #Request.DB_Prefix#Categories
		WHERE Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
		</cfquery>		
		
		<!--- Sets the list of images to delete --->
		<cfset attributes.image_list="">		
		<cfif len(delete_images.sm_image)>
			<cfset attributes.image_list = listappend(attributes.image_list,delete_images.sm_image)>
		</cfif>
		<cfif len(delete_images.sm_title)>
			<cfset attributes.image_list = listappend(attributes.image_list,delete_images.sm_title)>
		</cfif>
		<cfif len(delete_images.lg_image)>
			<cfset attributes.image_list = listappend(attributes.image_list,delete_images.lg_image)>
		</cfif>
		<cfif len(delete_images.lg_title)>
			<cfset attributes.image_list = listappend(attributes.image_list,delete_images.lg_title)>
		</cfif>

	<cfquery name="Deletefeature_cateogry" datasource="#Request.DS#" 
	username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#Feature_Category
	WHERE Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
	</cfquery>

	<cfquery name="DeleteProduct_cateogry" datasource="#Request.DS#" 
	username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#Product_Category
	WHERE Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
	</cfquery>
	
	<cfquery name="DeleteCategory" datasource="#Request.DS#" 
	username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#Categories
	WHERE Category_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CID#">
	</cfquery>
	
	<cfscript>
		//Update top category queries
		Application.objMenus.getTopCats(rootcat="0", reset='yes');
		//Update all categories query
		Application.objMenus.getAllCats(reset='yes');
		
		//Update current user's menus
		StructDelete(Session, 'SideMenus');
	</cfscript>	

	
<cfelse>
			
	<cfset attributes.error_message = "This category could not be deleted for the following reasons:<br/>" &  attributes.error_message >
			
</cfif>		




