<!--- CFWebstore, version 6.50 --->

<!--- Displays the affiliate order report. Called from dsp_report.cfm --->

<cfquery name="GetOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Order_No
	WHERE MONTH(DateOrdered) = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.Month, 1)#">
	AND YEAR(DateOrdered) = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.Month, 2)#">
	AND Affiliate = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetInfo.AffCode#">
	AND Void = 0
	ORDER BY Order_No
</cfquery>

<!-- start shopping/affiliate/put_aff_report.cfm -->
<div id="putaffreport" class="shopping">

<cfif NOT GetOrders.Recordcount>
	<tr>
		<td align="center" class="formtitle">
			No affiliate orders were found for this month.<br/><br/>
		</td>
	</tr>

<cfelse>

	<tr>
		<td>
		
<cfoutput>
<cfif len(GetInfo.FirstName)>
	Name: #GetInfo.FirstName# #GetInfo.LastName#<br/>
	<cfif len(GetInfo.Company)>Company: #GetInfo.Company#<br/></cfif>
<cfelse>
	User: #GetInfo.Username#<br/>
</cfif>
Affiliate ID: #GetInfo.AffCode#<br/>
Commission: <cfset Pct = (GetInfo.AffPercent * 100)>#Pct#%<p>
You generated #GetOrders.RecordCount# sale<cfif GetOrders.RecordCount GT 1>s</cfif> for this month.<p>
</cfoutput>
	
		<table width="100%" cellspacing="2" cellpadding="5" border="0" class="formtext">
			<tr>
   				<td align="center">Order</td>
    			<td align="center">Date</td>
    			<td align="center">Filled?</td>
				<td align="right">Gross</td>
  			    <td align="right">Shipping</td>
    			<td align="right">Tax</td>
				<td align="right">Discounts</td>
   			    <td align="right">Net</td>
				<td align="right">Commission</td>
			</tr>
			
		<cfset SubTotal = 0>
		<cfset NetTotal = 0>

		<cfoutput query="GetOrders">
			<cfset itemnumber = GetOrders.CurrentRow>

			<!--- Output Information for Each Sale --->
			<tr>
    			<td align="center">#(GetOrders.Order_No + Get_Order_Settings.BaseOrderNum)#</td>
    			<td align="center">#DateFormat(GetOrders.DateOrdered,"MM/DD/YY")#</td>
				<td align="center">#YesNoFormat(GetOrders.Filled)#</td>
    			<td align="right">#LSCurrencyFormat(GetOrders.OrderTotal+GetOrders.OrderDisc+GetOrders.Credits)#</td>
    			<td align="right">#LSCurrencyFormat(GetOrders.Shipping)#</td>
    			<td align="right">#LSCurrencyFormat(GetOrders.Tax)#</td>
				<td align="right">#LSCurrencyFormat(GetOrders.OrderDisc)#</td>
    			<td align="right"><cfset Net = (GetOrders.OrderTotal - GetOrders.Shipping - GetOrders.Tax + GetOrders.Credits)>#LSCurrencyFormat(Net)#</td>
				<td align="right"><cfset Ext = (Net * (GetInfo.AffPercent))> #LSCurrencyFormat(Ext)#</font></td>
			</tr>

			<cfset SubTotal = SubTotal + Ext>
			<cfset NetTotal = NetTotal + Net>
		</cfoutput>

		<!--- Output Basket Total --->
		<cfoutput>
		<tr>
			<td colspan="7" align="right"><b>Totals:</b></td>
			<td align="right">#LSCurrencyFormat(NetTotal)#</td>
			<td align="right">#LSCurrencyFormat(SubTotal)#</td>
		</tr>
		</cfoutput>

	</table>
	<br/>
	</cfif>

	</td></tr>
</div>
<!-- end shopping/affiliate/put_aff_report.cfm -->
