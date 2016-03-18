
<!--- CFWebstore, version 6.50 --->

<!--- This template updates the temp_customer table with the other order info from the shipping page. Called by shopping.checkout (step=shipping) --->

<!--- Clear any previous totals for this basket --->
<cfquery name="DeleteTotals" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	DELETE FROM #Request.DB_Prefix#TempOrder
	WHERE BasketNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
</cfquery>

<cfset Affiliate = Session.Affiliate>
<cfset Referrer = Session.Referrer>

<cfset Comments = iif(isDefined("attributes.Comments"), "trim(attributes.Comments)", DE(''))>
<cfset Delivery = iif(isDefined("attributes.Delivery"), "trim(attributes.Delivery)", DE(''))>
<cfset GiftCard = iif(isDefined("attributes.GiftCard"), "trim(attributes.GiftCard)", DE(''))>

<!--- Custom textbox fields --->
<cfloop index="x" from="1" to="3">
	<cfset variables['customtext' & x] = iif(StructKeyExists(attributes,'CustomText'& x),"attributes['CustomText' & x]",DE(''))>
</cfloop>
<!--- Custom selectbox fields --->
<cfloop index="x" from="1" to="2">
	<cfset variables['customselect' & x] = iif(StructKeyExists(attributes,'CustomSelect'& x),"attributes['CustomSelect' & x]",DE(''))>
</cfloop>

<!--- Store totals for this order in database --->
<cfquery name="AddTotals" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	INSERT INTO #Request.DB_Prefix#TempOrder
	(BasketNum, Affiliate, Referrer, GiftCard, Delivery, Comments, 
	<!--- Custom textbox fields --->
	<cfloop index="num" from="1" to="3">
		CustomText#num#,
	</cfloop>
	<!--- Custom selectbox fields --->
	<cfloop index="num" from="1" to="2">
		CustomSelect#num#, 
	</cfloop> 
	DateAdded)
	
	VALUES
	(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Affiliate#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Referrer#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Giftcard#" null="#YesNoFormat(NOT len(Giftcard))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Delivery#" null="#YesNoFormat(NOT len(Delivery))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Comments#" null="#YesNoFormat(NOT len(Comments))#">,
	<!--- Custom textbox fields --->
	<cfloop index="x" from="1" to="3">
		<cfset entry = trim(variables['customtext' & x])>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#entry#" null="#YesNoFormat(NOT len(entry))#">,
	</cfloop>
	<!--- Custom selectbox fields --->
	<cfloop index="x" from="1" to="2">
		<cfset entry = trim(variables['customselect' & x])>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#entry#" null="#YesNoFormat(NOT len(entry))#">,
	</cfloop> 
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
</cfquery>

