
<!--- CFWebstore, version 6.50 --->

<!--- Updates the wishlist with the user comments and desired quantities or deletes selected items. Called by shopping.wishlist --->

<!--- Make sure user is still logged in --->

<!--- CSRF Check --->
<cfset keyname = "wishlistEdit">
<cfinclude template="../../includes/act_check_csrf_key.cfm">

<!--- Check if update, if not, check which item to delete --->

<cfif NOT isDefined("attributes.Update")>

	<cfloop index="ProdID" list="#attributes.ProdList#">
	
		<cfif StructKeyExists(attributes,'Delete' & ProdID)>
		<!--- Delete this product from the wishlist --->
		
			<cfquery name="DeleteProd" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
				DELETE FROM #Request.DB_Prefix#WishList
				WHERE ListNum = 1
				AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
				AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ProdID#">
			</cfquery>
		
		</cfif>
	
	</cfloop>

</cfif>

<!--- Loop through the list and update all the fields --->
<cfloop index="ProdID" list="#attributes.ProdList#">
	<cfif StructKeyExists(attributes, 'NumDesired' & ProdID)>
		<!--- Update product's information on the wishlist --->
		
			<cfset NumDesired = attributes['NumDesired' & ProdID]>
			<cfset Comments = attributes['Comment' & ProdID]>
			
			<cfif NOT isNumeric(NumDesired)>
				<cfset NumDesired = 1>
			</cfif> 
		
			<cfquery name="UpdateProd" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
				UPDATE #Request.DB_Prefix#WishList
				SET NumDesired = <cfqueryparam cfsqltype="cf_sql_integer" value="#NumDesired#">,
				Comments = <cfqueryparam  cfsqltype="cf_sql_longvarchar" value="#Comments#" null="#YesNoFormat(NOT len(Comments))#">
				WHERE ListNum = 1
				AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
				AND Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ProdID#">
			</cfquery>
		
		</cfif>

</cfloop>

<!--- present confirmation if updating, not deleting --->
<cfif isDefined("attributes.Update")>

<script type="text/javascript">
	alert('Wishlist Updated!')
</script>
	
</cfif>

