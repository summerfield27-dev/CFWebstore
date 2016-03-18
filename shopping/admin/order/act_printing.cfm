<!--- CFWebstore, version 6.50 --->


<!--- This page prints order invoices, packlists, or purchase orders.
	- Orderlist OR Order_no is required.
	- Account_ID is optional for purchase orders... so all purchase orders can be printed for a 
	  particular order or only one. 
	  
	This template also updates the order record to show that the invoice or packlist has been printed.
	--->
	
	<!--- Called by shopping.admin&order=print --->

<!--- Get stuff needed to draw the page ---->

<cfparam name="attributes.account_id" default="">	

<!--- Get query of orders to print. OrderList is a comma delimted list of order_nos. If OrderList is 'orderlist' it means the list has been passed in a session variable of the same name. ---->

<cfif attributes.order_no is "orderlist">

	<cfset orderlist = Session.orderlist>

<cfelseif isdefined("attributes.order_no")>
	
	<cfset orderlist = attributes.order_no>

</cfif>	

<cfquery name="PrintOrders" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT Order_No, Printed FROM #Request.DB_Prefix#Order_No
	WHERE Order_No IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#orderlist#" list="true">)
</cfquery>


<cfif attributes.print is "invoice">

	<cfloop query="PrintOrders">

		<cfmodule template="../../order/put_order.cfm" Order_No="#Order_No#" />
	
	  <cfif printorders.currentrow is not printorders.recordcount>
        <p class="pageEnd"></p>
      </cfif>

		<cfif printed is not 1 and printed is not 3>
			<cfquery name="invoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
				UPDATE #Request.DB_Prefix#Order_No
				SET Printed = <cfqueryparam cfsqltype="cf_sql_integer" value="#(printed + 1)#">
				WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#Order_No#">
			</cfquery>
		</cfif>
		
	</cfloop>

<cfelseif attributes.print is "packlist">

	<cfloop query="PrintOrders">

		<cfmodule template="dsp_print_packlists.cfm" Order_No="#Order_No#" />
	
		<cfif printorders.currentrow is not printorders.recordcount>
        	<p class="pageEnd"></p>
      	</cfif>
		
		<cfif printed lt 2>
			<cfquery name="invoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
				UPDATE #Request.DB_Prefix#Order_No
				SET Printed = <cfqueryparam cfsqltype="cf_sql_integer" value="#(printed + 2)#">
				WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#Order_No#">
			</cfquery>
		</cfif>
		
	</cfloop>	

<cfelseif attributes.print is "PO">

	<cfloop query="PrintOrders">

		<!--- loop through the list of orders & get list of Purchase Orders --->
		<cfquery name="Get_Order_PO" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT Order_PO_ID FROM #Request.DB_Prefix#Order_PO
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_no#">
			<cfif len(attributes.account_ID)>
				AND Account_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#account_ID#">
			</cfif>
		</cfquery>

		<!--- loop through the purchase orders & print --->
		<cfloop query="Get_Order_PO">
		
			<cfmodule template="../po/dsp_po_print.cfm" Order_PO_ID="#Order_PO_ID#"	/>
			
			<cfif Get_Order_PO.currentrow is not Get_Order_PO.recordcount>
	        	<p class="pageEnd"></p>
	        </cfif>
		
		</cfloop>
		
		<cfif printorders.currentrow is not printorders.recordcount>
        	<p class="pageEnd"></p>
      	</cfif>
		
	</cfloop>	
	
</cfif>

	
	
<!--- Bring window to the front --->
<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
window.focus();
</script>
</cfprocessingdirective>

