
<!--- CFWebstore, version 6.50 --->

<!--- Displays the order sales summary on the main admin home page.  Called by dsp_admin_home.cfm --->

<!--- Order reports permissions --->
<cfmodule template="../access/secure.cfm"
	keyname="shopping"
	requiredPermission="128"
	>
	<cfif ispermitted>
	
	<cfoutput>
	<span class="mainpage">
	<table cellspacing="2" cellpadding="2" border="0" class="mainpage">
	<tr>
	    <td align="right"><strong>Today: </strong></td>
	    <td>#OrdersToday.NumOrders# Order<cfif OrdersToday.NumOrders IS NOT 1>s</cfif>, 
	    <cfif isNumeric(OrdersToday.TotalSales)>
	  	  <cfset SalesTotal = OrdersToday.TotalSales - OrdersToday.TotalTax - OrdersToday.TotalShipping - OrdersToday.TotalDisc + OrdersToday.TotalCredit>
		<cfelse>
			<cfset SalesTotal = 0>
		</cfif>
			#LSCurrencyFormat(Val(SalesTotal))# Total</td>
	</tr>
	<tr>
	    <td align="right"><strong>Yesterday: </strong></td>
	    <td>#OrdersYester.NumOrders# Order<cfif OrdersYester.NumOrders IS NOT 1>s</cfif>, 
	    <cfif isNumeric(OrdersYester.TotalSales)>
	  	  <cfset SalesTotal = OrdersYester.TotalSales - OrdersYester.TotalTax - OrdersYester.TotalShipping - OrdersYester.TotalDisc + OrdersYester.TotalCredit>
		<cfelse>
			<cfset SalesTotal = 0>
		</cfif>
			#LSCurrencyFormat(Val(SalesTotal))# Total</td>
	</tr>
	<tr>
	    <td align="right"><br/><strong>This Month: </strong></td>
	    <td><br/>#OrdersMonth.NumOrders# Order<cfif OrdersMonth.NumOrders IS NOT 1>s</cfif>, 
	    <cfif isNumeric(OrdersMonth.TotalSales)>
	  	  <cfset SalesTotal = OrdersMonth.TotalSales - OrdersMonth.TotalTax - OrdersMonth.TotalShipping - OrdersMonth.TotalDisc + OrdersMonth.TotalCredit>
		<cfelse>
			<cfset SalesTotal = 0>
		</cfif>
			#LSCurrencyFormat(Val(SalesTotal))# Total</td>
	</tr>
	<tr>
	    <td align="right"><strong>Last Month: </strong></td>
	    <td>#OrdersLastMonth.NumOrders# Order<cfif OrdersLastMonth.NumOrders IS NOT 1>s</cfif>, 
	    <cfif isNumeric(OrdersLastMonth.TotalSales)>
	  	  <cfset SalesTotal = OrdersLastMonth.TotalSales - OrdersLastMonth.TotalTax - OrdersLastMonth.TotalShipping - OrdersLastMonth.TotalDisc + OrdersLastMonth.TotalCredit>
		<cfelse>
			<cfset SalesTotal = 0>
		</cfif>
			#LSCurrencyFormat(Val(SalesTotal))# Total</td>
	</tr>
	<tr align="right">
	    <td><br/><strong>This Year: </strong></td>
	    <td><br/>#OrdersYear.NumOrders# Order<cfif OrdersYear.NumOrders IS NOT 1>s</cfif>, 
	    <cfif isNumeric(OrdersYear.TotalSales)>
	  	  <cfset SalesTotal = OrdersYear.TotalSales - OrdersYear.TotalTax - OrdersYear.TotalShipping - OrdersYear.TotalDisc + OrdersYear.TotalCredit>
		<cfelse>
			<cfset SalesTotal = 0>
		</cfif>
			#LSCurrencyFormat(Val(SalesTotal))# Total</td>
	</tr>
	<tr  align="right">
	    <td><strong>Last Year: </strong></td>
	    <td>#OrdersLastYear.NumOrders# Order<cfif OrdersLastYear.NumOrders IS NOT 1>s</cfif>, 
	    <cfif isNumeric(OrdersLastYear.TotalSales)>
	  	  <cfset SalesTotal = OrdersLastYear.TotalSales - OrdersLastYear.TotalTax - OrdersLastYear.TotalShipping - OrdersLastYear.TotalDisc + OrdersLastYear.TotalCredit>
		<cfelse>
			<cfset SalesTotal = 0>
		</cfif>
			#LSCurrencyFormat(Val(SalesTotal))# Total</td>
	</tr>
	</table>

	</cfoutput>
	
	<cfelse>
	<span class="mainpage">	
	Order Reports not available.<br/><br/>
	</span>
	</cfif>
	
	