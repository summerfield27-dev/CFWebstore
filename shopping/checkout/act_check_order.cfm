<!--- CFWebstore, version 6.50 --->

<!--- Verify that nothing new has been added to the shopping cart, prevents user from adding items to the cart from a separate window while checking out. Called by shopping.checkout (step=receipt) --->

<!--- Get Order Start Times --->
<cfquery name="GetStartTime" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT DateAdded FROM #Request.DB_Prefix#TempCustomer
	WHERE TempCust_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>		
		
<cfquery name="GetLast" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT MAX(DateAdded) AS ItemDate 
	FROM #Request.DB_Prefix#TempBasket 
	WHERE BasketNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>

<cfif DateCompare(GetLast.ItemDate, GetStartTime.DateAdded, "s") IS 1>
	<!--- Clear checkout variables and restart checkout from shipping page --->
	<cfset StructDelete(Session, "CheckoutVars")>
	
	<!--- Update Customer date --->
	<cfquery name="GetStartTime" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#TempCustomer
		SET DateAdded = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		WHERE TempCust_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
	</cfquery>	
	
	<cflocation url="#self#?fuseaction=shopping.checkout&step=shipping#Request.Token2#" addtoken="No"> 
</cfif>
