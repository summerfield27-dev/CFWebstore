
<!--- CFWebstore, version 6.50 --->

<!--- Retrieves the list of purchase order. Includes date search fields and other filters. Called by shopping.admin&po=list --->

<cfloop index="namedex" list="order_no,order_num,po_no,account_ID,printdate,status,open,shipdate">
	<cfparam name="attributes.#namedex#" default="">
</cfloop>
	

<!--- If we have an print date, set the start and end date --->
<cfif len(attributes.printdate)>
	<cfset Year = ListGetAt(attributes.printdate, 1, "-")>
	<!--- Check if month entered --->
	<cfif listlen(attributes.printdate,'-') gte 2>
		<cfset StartMonth = ListGetAt(attributes.printdate, 2, "-")>
		<cfset EndMonth = ListGetAt(attributes.printdate, 2, "-")>
	<cfelse>
		<cfset StartMonth = 1>
		<cfset EndMonth = 12>
	</cfif>
	<!--- Check if day entered --->
	<cfif listlen(attributes.printdate,'-') is 3>
		<cfset StartDay = ListGetAt(attributes.printdate, 3, "-")>
		<cfset EndDay = ListGetAt(attributes.printdate, 3, "-")>
	<cfelse>
		<cfset StartDay = 1>
		<cfset EndDay = DaysinMonth(CreateDate(Year, StartMonth, StartDay))>
	</cfif>
	
	<!--- Make sure this is a valid date --->
	<cfif isNumeric(Year) AND isNumeric(StartMonth) AND isNumeric(StartDay)>
		<cfset startdate = CreateDate(Year, StartMonth, StartDay)>
		<cfset todate = CreateDate(Year, EndMonth, EndDay)>
	</cfif>
</cfif>
	
<!--- Clear variables --->
<cfset Year = "">
<cfset StartMonth = "">
<cfset EndMonth = "">
<cfset StartDay = "">
<cfset EndDay = "">

<!--- If we have a ship date, set the shipstart and shipend date --->
<cfif len(attributes.shipdate)>
	<cfset Year = ListGetAt(attributes.shipdate, 1, "-")>
	<!--- Check if month entered --->
	<cfif listlen(attributes.shipdate,'-') gte 2>
		<cfset StartMonth = ListGetAt(attributes.shipdate, 2, "-")>
		<cfset EndMonth = ListGetAt(attributes.shipdate, 2, "-")>
	<cfelse>
		<cfset StartMonth = 1>
		<cfset EndMonth = 12>
	</cfif>
	<!--- Check if day entered --->
	<cfif listlen(attributes.shipdate,'-') is 3>
		<cfset StartDay = ListGetAt(attributes.shipdate, 3, "-")>
		<cfset EndDay = ListGetAt(attributes.shipdate, 3, "-")>
	<cfelse>
		<cfset StartDay = 1>
		<cfset EndDay = DaysinMonth(CreateDate(Year, StartMonth, StartDay))>
	</cfif>
	
	<!--- Make sure this is a valid date --->
	<cfif isNumeric(Year) AND isNumeric(StartMonth) AND isNumeric(StartDay)>
		<cfset shipstart = CreateDate(Year, StartMonth, StartDay)>
		<cfset shipto = CreateDate(Year, EndMonth, EndDay)>
	</cfif>
</cfif>

<cfquery name="qry_get_Order_PO"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT O.Order_PO_ID, O.Order_No, O.PO_No, O.Account_ID, O.PrintDate, 
		O.PO_Status, O.PO_Open, O.ShipDate, A.Account_Name, A.PO_Text, A.Dropship_Email
		FROM #Request.DB_Prefix#Order_PO O, #Request.DB_Prefix#Account A
		WHERE O.Account_ID = A.Account_ID

		<cfif len(attributes.order_no)>AND O.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_no#"> 
		<cfelseif len(attributes.order_num)> 
			AND O.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_Num - Get_Order_Settings.BaseOrderNum#"> 
		</cfif>	
		<cfif len(attributes.po_no)>AND O.PO_No = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.po_no#"> </cfif>		
		<cfif len(attributes.account_ID)>AND A.Account_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_ID#"> </cfif>		
		<cfif len(attributes.status)>AND O.PO_Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.status#"> </cfif>			
		<cfif len(attributes.open)>AND O.PO_Open = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.open#"> </cfif>		
		<cfif isDefined("startdate")>
			AND PrintDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> 
			AND PrintDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#todate#"> 
		</cfif>				
		<cfif isDefined("shipstart")>
			AND ShipDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#shipstart#"> 
			AND ShipDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#shipto#"> 
		</cfif>				
		ORDER BY Order_PO_ID DESC
</cfquery>
		