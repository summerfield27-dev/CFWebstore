<!--- CFWebstore, version 6.50 --->

<!--- This page is run to check that if a coupon or certificate code is entered, that the code is a valid one. Called by shopping.checkout (step=shipping) and shopping/basket/act_recalc.cfm --->

<cfparam name="codeerror" default="1">
<cfparam name="attributes.Coupon" default="">

<cfset CheckCode = Trim(UCase(attributes.Coupon))>

<!--- Check if a code is entered --->
<cfif len(CheckCode)>
	
	<!--- Check for a discount or promotion based on the code --->
	<cfquery name="GetDiscount" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Discount_ID, StartDate, EndDate 
		FROM #Request.DB_Prefix#Discounts
		WHERE Coup_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CheckCode#">
		<cfif Session.User_ID IS NOT 0>
		AND (OneTime = 0 OR Coup_Code NOT IN 
				(SELECT Disc_Code FROM #Request.DB_Prefix#Order_Items I, #Request.DB_Prefix#Order_No N
				WHERE I.Order_No = N.Order_No AND I.Disc_Code IS NOT NULL
			 	AND I.Disc_Code <> '' 
				AND N.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">) )	
		</cfif>
		AND (StartDate IS NULL OR StartDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		AND (EndDate IS NULL OR EndDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
	</cfquery>
	
	<cfquery name="GetPromotion" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Promotion_ID, StartDate, EndDate 
		FROM #Request.DB_Prefix#Promotions
		WHERE Coup_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CheckCode#">
		<cfif Session.User_ID IS NOT 0>
		AND (OneTime = 0 OR Coup_Code NOT IN 
				(SELECT Disc_Code FROM #Request.DB_Prefix#Order_Items I, #Request.DB_Prefix#Order_No N
				WHERE I.Order_No = N.Order_No AND I.Disc_Code IS NOT NULL
			 	AND I.Disc_Code <> '' AND N.User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#"> ) )	
		</cfif>
		AND (StartDate IS NULL OR StartDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		AND (EndDate IS NULL OR EndDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
	</cfquery>
	
	<cfif GetDiscount.RecordCount OR GetPromotion.RecordCount>
		<cfset codeerror = 0>
		<!--- Update session --->
		<cfset Session.Coup_Code = CheckCode>
		
	<!--- Check for a certificate if no discount found --->
	<cfelse>
		<!--- Delete any previous coupon that might have been saved --->
		<cfset Session.Coup_Code = "">
		
		<cfset OrderDiscount = 0>
		<cfinclude template="../../basket/act_calc_giftcert.cfm">
		
		<!--- If certificate found, turn off error. --->
		<cfif GApproved>
			<cfset codeerror = 0>
			<!--- Update session --->
			<cfset Session.Gift_Cert = CheckCode>
		</cfif>	
	
	</cfif>
	
<cfelse>
	<!--- No coupon code entered --->
	<cfset codeerror = 0>
	
</cfif>
