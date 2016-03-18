
<!--- CREATED BY: Chad M. Adamson | webmaster@hostbranson.com --->

<!--- CFWebstore, version 6.50 --->

<!--- This template is used to complete the payment processing on an order using Linkpoint. The order must have been previously authorized. It looks up the authorization number and bills.  Called from shopping\admin\act_billing.cfm
Required: Order_no --->

<!--- Retrieve Linkpoint settings --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT CCServer, Password, Transtype, Username, Setting1 
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>


<!--- Look up the Order Info --->
<cfquery name="GetOrderTx" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Order_No, Card_ID, TransactNum, OrderTotal, Notes 
	FROM #Request.DB_Prefix#Order_No 
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
	AND Paid = 0 AND Void = 0
</cfquery>

<!--- if record found, process the payment --->
<cfif GetOrderTx.recordcount is 1 AND GetOrderTx.TransactNum is not "">

  <cfquery name="GetCardData" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
  	SELECT * FROM #Request.DB_Prefix#CardData 
  	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOrderTx.Card_ID#">
  </cfquery>
  
  <cfset ordertype = "POSTAUTH">
  <cfset chargetotal = GetOrderTX.OrderTotal>
  <cfset cardnumber = GetCardData.CardNumber>
  <cfset cardexpmonth = GetCardData.Expires>
  <cfset cardexpyear = GetCardData.Expires>
  <cfset oID = GetOrderTX.TransactNum>
  
  <cfinclude template = "lpcfm.cfm">
  <cfinclude template = "status.cfm">
  <!---If the message is approved, continue processing the order---->
  
  <cfset thedate = dateformat(now(),"mm/dd/yy")>
  
  <cfif R_APPROVED IS "APPROVED">
    <cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	    UPDATE #Request.DB_Prefix#Order_No 
		SET Paid = 1, 
		Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="SETTLED #thedate#: #GetOrderTx.Notes#">,
		Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
		Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		WHERE Order_No =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
    </cfquery>
	
    <!---If the message is not approved ---->
    <cfelse>
	    <cfset ErrorMessage = R_ERROR>
	    <cfquery name="OrderPaid" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		    UPDATE #Request.DB_Prefix#Order_No 
			SET Notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="CC billing failed on #thedate#: #ErrorMessage# #GetOrderTx.Notes#">, 
			Admin_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Realname#">,
			Admin_Updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			WHERE Order_No =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_no#">
	    </cfquery>
  	</cfif>
</cfif>

