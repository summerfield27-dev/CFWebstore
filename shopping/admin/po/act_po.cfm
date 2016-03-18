
<!--- CFWebstore, version 6.50 --->

<!--- Performs actions on purchase orders: add, edit and delete. Verifies the discount is not in use before deleting. Called by shopping.admin&po=act|add|ship and from order\act_maildrop.cfm --->

<!--- CSRF Check --->
<cfif attributes.fuseaction IS NOT "shopping.checkout">
	<cfset keyname = "poUpdate">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
</cfif>

<cfswitch expression="#po#">

	<cfcase value="add">
	
		<!--- UUID to tag new inserts --->
		<cfset NewIDTag = CreateUUID()>
		<!--- Remove dashes --->
		<cfset NewIDTag = Replace(NewIDTag, "-", "", "All")>
		
		<!--- check to see if purchase order exists for this order|account combo --->
		<cfquery name="findPO"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
			SELECT Order_PO_ID FROM #Request.DB_Prefix#Order_PO
			WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
			AND Account_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_ID#">
		</cfquery>

		<cfif findpo.recordcount is 1>
		
			<cfset attributes.order_po_ID = findpo.order_po_ID>
		
		<cfelse>
		
	 		<cftransaction>
			
			<!--- Determine which PO for this order we are adding --->
			<cfquery name="Get_po_num" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				SELECT COUNT(Order_PO_ID) AS Po_Num 
				FROM #Request.DB_Prefix#Order_PO
				WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
			</cfquery>
			
			<cfset NextPO = Get_po_num.Po_Num + 1>
			
			<cfquery name="GetPOID" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				<cfif Request.dbtype IS "MSSQL">
					SET NOCOUNT ON
				</cfif>
				INSERT INTO #Request.DB_Prefix#Order_PO 
				(ID_Tag, Order_No, PO_No, Account_ID, PrintDate, PO_Open)
				VALUES
				(<cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">, 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_no#">,
			     <cfqueryparam cfsqltype="cf_sql_varchar" value="#(Attributes.order_no + Get_Order_Settings.BaseorderNum)#-#NextPO#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.account_ID#">,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,  1 )
				 <cfif Request.dbtype IS "MSSQL">
					SELECT @@Identity AS New_ID
					SET NOCOUNT OFF
				</cfif>
			</cfquery>	
	
			<cfif Request.dbtype IS NOT "MSSQL">
				<cfquery name="GetPOID" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
				SELECT Order_PO_ID AS New_ID 
				FROM #Request.DB_Prefix#Order_PO
				WHERE ID_Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NewIDTag#">
				</cfquery>
			</cfif>
		
			</cftransaction>			
			
			<cfset attributes.Order_PO_id = GetPOID.New_ID>
		
		</cfif>
	</cfcase>

	
	<cfcase value="act">	
	
		<cfif submit is "delete">
		
			<cfquery name="Delete_PO" dbtype="ODBC" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#Order_PO 
				WHERE Order_PO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_po_ID#">
			</cfquery>
				
		<cfelse>

			<cfquery name="Update_PO" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Order_PO
				SET 	
				PO_No = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.po_no)#">,
				PrintDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.printdate#">,
				Notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.notes#">,
				PO_Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.po_status#">,
				PO_Open = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.po_open#">	
				WHERE Order_PO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_PO_ID#">
				</cfquery>

		</cfif>
	</cfcase>
	
	
	<cfcase value="ship">
	
		<!--- Update Order --->
		<cfquery name="Fill_PO" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Order_PO
				SET 	
				Tracking = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Tracking)#">,
				Shipper = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Shipper#">,
				ShipDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.ShipDate#">,
				PO_Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.po_status#">,
				PO_Open = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.po_open#">,
				Notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.notes#">
				WHERE Order_PO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_PO_ID#">
				</cfquery>

		<!--- If Email customer check, send email with tracking numbers --->	
		<cfif attributes.EmailCustomer is "1">
			<cfinclude template="../order/act_emailtrack.cfm"> 
		</cfif>	
		
	</cfcase>
	

</cfswitch>
			
