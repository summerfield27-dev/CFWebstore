<!--- CFWebstore, version 6.50 --->

<!--- Adds an item to the wishlist. Called by shopping.wishlist --->

<!--- Make sure user is logged in --->

<cfparam name="attributes.message" default="">

<!--- check if there is a product to add! --->
<cfif isdefined("attributes.product_id") AND isNumeric(attributes.product_id)>

	<!--- Make sure product is not already on the list  --->
	<cfquery name="CheckList" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
		SELECT Product_ID FROM #Request.DB_Prefix#WishList
		WHERE ListNum = 1
		AND User_ID = <cfqueryparam value="#Session.User_ID#" cfsqltype="CF_SQL_INTEGER">
		AND Product_ID = <cfqueryparam value="#attributes.product_id#" cfsqltype="CF_SQL_INTEGER">
	</cfquery>
	
	<cfif CheckList.RecordCount>
	
	<!--- Product is already on the list --->
		<cfset attributes.message = "This product is already on the wishlist!">
	
	
	<cfelse>
	
		<!--- Retrieve next item number for the wishlist for this user and add this item  --->
		<cftransaction>
		
			<cfquery name="GetNum" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT MAX(ItemNum) AS LastNum FROM #Request.DB_Prefix#WishList 
				WHERE ListNum = 1
				AND User_ID = <cfqueryparam value="#Session.User_ID#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
			
			<cfquery name="AddItem" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#WishList
				(User_ID, ListNum, ListName, ItemNum, Product_ID, DateAdded, NumDesired, Comments)
				VALUES
				(<cfqueryparam value="#Session.User_ID#" cfsqltype="CF_SQL_INTEGER">, 
				1, 'default', 
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#iif(isNumeric(GetNum.LastNum), Evaluate(DE('GetNum.LastNum+1')), 1)#">,
				<cfqueryparam value="#attributes.Product_ID#" cfsqltype="CF_SQL_INTEGER">, 
				<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#Now()#">, 1, Null)
			</cfquery>
	
		</cftransaction>
	
	</cfif>

</cfif>


