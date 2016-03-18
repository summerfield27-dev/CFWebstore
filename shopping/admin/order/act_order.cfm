<!--- CFWebstore, version 6.50 --->

<!--- This template provides order processing functions. It can be called from order listings or detail page 
	attributes.order_no:	required
	attributes.act:			invoice - display invoice for printing
							packlist - display packing list for printing
							fill - set filled = 1; email
							process - set process =1; email
							pending - set process = 0
							void-cancelled 
							void-fraud
							delete
							update - process the order status screen
 --->
 
 <!--- Called by shopping.admin&order=display and from act_orders.cfm for bulk order processing --->
 
 <!--- First, retrieve the current status of this order, used for inventory tracking purposes --->
<cfquery name="GetInfo" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
	SELECT Process, Filled, Void, InvDone, OfflinePayment, PayPalStatus 
	FROM #Request.DB_Prefix#Order_No
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
</cfquery>

	
<!--- By default, do not add or remove inventory --->
<cfset RemoveInt = "No">
<cfset ReturnInt = "No">
<cfset VoidOrder = "No">
<!--- Default is to remove credit card data --->
<cfset RemoveCard = "Yes">

<cfswitch expression="#attributes.act#">

	<!--- Print Invoice --->
	<cfcase value="invoice">
			
		<cfprocessingdirective suppresswhitespace="no">
		<script type="text/javascript">
			function openWin( windowURL, windowName, windowFeatures ) { 
			return window.open( windowURL, windowName, windowFeatures ) ; 
			} 
						
			window.open('<cfoutput>#request.self#?fuseaction=shopping.admin&order=print&print=invoice&Order_No=#attributes.order_no##Request.Token2#</cfoutput>', 'order');
		</script>
	</cfprocessingdirective>
		
		<!-------------- Handled in index page above 
		<cfquery name="getinvoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			SELECT Print FROM #Request.DB_Prefix#Order_No
			WHERE Order_No = #attributes.Order_No#
			</cfquery>

		<cfif getinvoice.print is not 1 and getinvoice.print is not 3>
			<cfquery name="invoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
				UPDATE #Request.DB_Prefix#Order_No
				Set Print = #(getinvoice.print + 1)#
				WHERE Order_No = #attributes.Order_No#
				</cfquery>
		</cfif>
		--------->
			
		<cfset RemoveCard = "No">
			
	</cfcase>
 

 
	<!--- Print Pick List --->
 	<cfcase value="packlist">
	<cfprocessingdirective suppresswhitespace="no">
		<script type="text/javascript">
			function openWin( windowURL, windowName, windowFeatures ) { 
			return window.open( windowURL, windowName, windowFeatures ) ; 
			} 
	
			window.open('<cfoutput>#self#?fuseaction=shopping.admin&order=print&print=invoice&Order_No=#attributes.order_no##Request.Token2#</cfoutput>', 'order');
		</script>
		</cfprocessingdirective>
		
		<!---------------- handled within the index page above 
		<cfquery name="getinvoice" datasource="#Request.DS#" 
		username="#Request.DSuser#" password="#Request.DSpass#">	
			SELECT Print FROM #Request.DB_Prefix#Order_No
			WHERE Order_No = #attributes.Order_No#
			</cfquery>

		<cfif getinvoice.print lt 2>
			<cfquery name="invoice" datasource="#Request.DS#" 
			username="#Request.DSuser#" password="#Request.DSpass#">	
				UPDATE #Request.DB_Prefix#Order_No
				Set Print = #(getinvoice.print + 2)#
				WHERE Order_No = #attributes.Order_No#
			</cfquery>
		</cfif>
		--------------->
		
		<cfset RemoveCard = "No">
		
	</cfcase>
	
	
	<cfcase value="Fill">

		<cfquery name="fillorder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Order_No
			SET Process = 1,
			Filled = 1,
			DateFilled = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
		</cfquery>
		
		<!--- Check if we need to remove inventory --->
		<cfif GetInfo.Process IS 0 AND GetInfo.Filled IS 0>
			<cfset RemoveInt = "Yes">
		<cfelseif GetInfo.Void IS 1>
			<cfset RemoveInt = "Yes">
		</cfif>

		<!--- If set to email dropshipper when order filled, send emails --->
		<cfif get_order_settings.EmailDrop and len(get_order_settings.DropEmail) AND
		 get_order_settings.EmailDropWhen IS "Filled">
			<cfinclude template="act_maildrop.cfm">
		</cfif>

	</cfcase>
	
	
	<cfcase value="Process">
		<cfquery name="processorder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET Process = 1,
			Filled = 0,
			DateFilled = NULL
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
		</cfquery>
		
		<!--- Check if we need to remove inventory --->
		<cfif GetInfo.Process IS 0 AND GetInfo.Filled IS 0>
			<cfset RemoveInt = "Yes">
		<cfelseif GetInfo.Void IS 1>
			<cfset RemoveInt = "Yes">
		</cfif>
		
		<!--- If set to email dropshipper when order processed, send emails --->
		<cfif get_order_settings.EmailDrop and len(get_order_settings.DropEmail) AND 
		get_order_settings.EmailDropWhen IS "Processed">
			<cfinclude template="act_maildrop.cfm">
		</cfif>

	</cfcase>

	
	
	<cfcase value="Pending">
		<cfquery name="pendingorder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET Process = 0,		
			Filled = 0,
			DateFilled = NULL
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
		</cfquery>
		
		<!--- Check if we need to return inventory --->
		<cfif (GetInfo.Process IS 1 OR GetInfo.Filled IS 1) AND GetInfo.Void IS 0>
			<cfset ReturnInt = "Yes">
		</cfif>

	</cfcase>
	
	
	<cfcase value="Update">
		<!---- processes the 'edit status' form on order managers edit order template.
		Attributes.void is either 0 or a void status (fraud,cancelled) ----->
		
		<!--- CSRF Check --->
		<cfset keyname = "orderBasketUpdate">
		<cfinclude template="../../../includes/act_check_csrf_key.cfm">
		
		<cfif NOT len(Trim(attributes.Affiliate))>
			<cfset Affiliate = 0>
		<cfelse>
			<cfset Affiliate = attributes.Affiliate>
		</cfif>
		
		<cfparam name="attributes.printed" default="0">
		<cfif listlen(attributes.printed) is 2>
			<cfset attributes.printed = 3>
		</cfif>
		
		<cfset attributes.act = attributes.moveto>

		<cfquery name="Update" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET 

			<cfif attributes.moveto is "pending">
				Process = 0,
				Filled = 0,
				DateFilled = NULL,
				Void = 0,
				Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.status#">,
			<cfelseif attributes.moveto is "process">
				Process = 1,
				Filled = 0,
				DateFilled = NULL,
				Void = 0,
				Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.status#">,
			<cfelseif attributes.moveto is "fill">
				Process = 1,
				Filled = 1,
				<cfif GetInfo.Filled IS 0>DateFilled = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,</cfif> 
				Void = 0,
				Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.status#">,
			<cfelseif attributes.moveto is "cancelled" or attributes.moveto is "fraud">
				Process = 1,
				Filled = 1,
				Void = 1,
				Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.moveto#">,
			</cfif>	
				Paid = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.paid#">,
				Affiliate = <cfqueryparam cfsqltype="cf_sql_integer" value="#Affiliate#">,
				Printed = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.printed#">,
				Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#attributes.notes#">,
				Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
				Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
		</cfquery>
		
		<!--- Check if we need to remove inventory --->
		<cfif attributes.moveto is "process" OR attributes.moveto is "fill">
			<cfif GetInfo.Process IS 0 AND GetInfo.Filled IS 0>
				<cfset RemoveInt = "Yes">
			<cfelseif GetInfo.Void IS 1>
				<cfset RemoveInt = "Yes">
			</cfif>
		<cfelseif attributes.moveto is "pending">
			<!--- Check if we need to return inventory --->
			<cfif (GetInfo.Process IS 1 OR GetInfo.Filled IS 1) AND GetInfo.Void IS 0>
				<cfset ReturnInt = "Yes">
			<!--- Check if this is a pending order that is staying pending --->
			<cfelseif GetInfo.Process IS 0 AND GetInfo.Filled IS 0 AND GetInfo.Void IS 0>
				<cfset RemoveCard = "No">
			</cfif>
		<cfelseif attributes.moveto is "cancelled" or attributes.moveto is "fraud" AND GetInfo.Void IS 0>
			<cfset ReturnInt = "Yes">
			<cfset VoidOrder = "Yes">
		</cfif>
		
		<!--- Send drop-shipper emails --->
		<cfif attributes.moveto is "process" AND get_order_settings.EmailDrop 
			AND len(get_order_settings.DropEmail) AND get_order_settings.EmailDropWhen IS "Processed">
			<cfinclude template="act_maildrop.cfm">
		<cfelseif attributes.moveto is "fill" AND get_order_settings.EmailDrop AND 
			len(get_order_settings.DropEmail) AND get_order_settings.EmailDropWhen IS "Filled">
			<cfinclude template="act_maildrop.cfm">
		</cfif>
		
		<!--- Check if we are also voiding the credit card --->
		<cfif isDefined("attributes.CCvoid") AND attributes.CCvoid IS 1>
			<cfif get_Order_Settings.CCProcess IS "AuthorizeNet3">
				<cfinclude template="../../checkout/creditcards/authorizenet/act_authnet3_void.cfm">
			<cfelseif get_Order_Settings.CCProcess IS "PayFlowPro4">
				<cfinclude template="../../checkout/creditcards/payflowpro/act_payflowpro4_void.cfm">
			<cfelseif get_Order_Settings.CCProcess IS "Shift4">
				<cfinclude template="../../checkout/creditcards/shift4/act_shift4_void.cfm">
			</cfif>
		</cfif>
		
	</cfcase>
	
		
	<cfcase value="edit">
		<cfquery name="editorder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
			UPDATE #Request.DB_Prefix#Order_No
			SET 
				Shipping = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.shipping#">,
				Tax = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.tax#">,
				AdminCreditText = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.adminCredittext#">,
				AdminCredit = <cfqueryparam cfsqltype="cf_sql_double" value="#attributes.adminCredit#">,
				Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
				Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
		</cfquery>
		
		<cfset RemoveCard = "No">
	</cfcase>
	
	
	<cfcase value="Delete">
		<cfset ReturnInt = "Yes">
		<cfset VoidOrder = "Yes">
		<cfinclude template="act_delete_order.cfm">		
	</cfcase>
	
	<cfdefaultcase>
		<cfset RemoveCard = "No">
	</cfdefaultcase>

</cfswitch> 


<!--- Check for voided order --->
<cfif left(attributes.act,4) is "Void">
			
	<cfquery name="voidorder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">	
		UPDATE #Request.DB_Prefix#Order_No
		SET Void = 1,
		Process = 1,
		Filled = 1,
		Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.act,"-")#">,
		DateFilled = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
	</cfquery>
	
	<!--- Check if we need to return inventory --->
	<cfif GetInfo.Void IS 0>
		<cfset ReturnInt = "Yes">
		<cfset VoidOrder = "Yes">
	</cfif>
		
</cfif>  
 
 
<!--- Remove full credit card information --->
<cfif RemoveCard>
	<cfinclude template="act_update_card.cfm"> 
</cfif> 

<!--- Double-check that inventory not removed yet and inventory management is turned on --->
<cfif RemoveInt AND NOT GetInfo.InvDone AND Request.AppSettings.InvLevel IS NOT "None">
	<cfinclude template="act_remove_inventory.cfm">
</cfif>


<!--- Only return inventory if it has previously been removed --->
<cfif ReturnInt AND GetInfo.InvDone>
	<cfinclude template="act_reverse_inventory.cfm">
</cfif>



