
<!--- CFWebstore, version 6.50 --->

<!--- This sends an email to the customer with their gift certificate codes. Called from shopping\admin\index.cfm --->

<cfset keyname = "CertCodes">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Initialize the content of the message --->
<cfset LineBreak = Chr(13) & Chr(10)>
<cfset Message = "The following gift certificates you purchased are now active and can be used for purchases in our store:" & LineBreak & LineBreak>

<!--- Loop through the list of gift cert codes --->
<cfloop query="GetCerts">

	<cfset Message = Message & "#LSCurrencyFormat(CertAmount)# Gift Certificate: #Cert_Code#" & LineBreak>
	
	<cfquery name="UpdateCert" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Certificates
		SET Valid = 1
		WHERE Cert_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cert_ID#">
	</cfquery>

</cfloop>

<cfinvoke component="#Request.CFCMapping#.global" UID="#GetCust.User_ID#" 
	method="sendAutoEmail" Email="#GetCust.Email#" MergeName="#GetCust.Firstname# #GetCust.Lastname#" 
	MailAction="GiftCertPurchase" MergeContent="#Message#">


<cfquery name="UpdateOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Order_No
	SET CodesSent = 1
	WHERE Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#">
</cfquery>

<!--- Redo the order queries --->
<cfinclude template="qry_order.cfm">