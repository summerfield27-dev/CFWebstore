
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to process a credit card payment return from CRE Secure. Called by shopping.checkout (step=crereturn) --->
<cfparam name="attributes.FieldNames" default="">
<cfparam name="attributes.order_id" default="">
<cfparam name="attributes.action" default="">
<cfparam name="attributes.code" default="">
<cfparam name="attributes.sess_id" default="">
<cfparam name="attributes.msg" default="">
<cfparam name="attributes.error" default="">
<cfparam name="attributes.mPAN" default="">
<cfparam name="attributes.name" default="">
<cfparam name="attributes.type" default="">
<cfparam name="attributes.exp" default="">
<cfparam name="attributes.ApprovalCode" default="">
<cfparam name="attributes.TxnGUID" default="">
<cfparam name="attributes.ApprovalCode" default="">

<cfparam name="Session.BasketNum" default="">
<cfparam name="Session.User_ID" default="0">
<cfparam name="Reason" default="">
<cfparam name="Confirmed" default="0">
<cfparam name="dbUpdate" default="0">

<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Username, Password, CCServer
	FROM #Request.DB_Prefix#CCProcess
	WHERE Setting3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="CRESecure">
</cfquery>

<cfset theDirectory = GetDirectoryFromPath(ExpandPath(Request.StorePath))>
<cfset theDirectory = theDirectory & "logs">

<cfparam name="logmess" default="">

<cfset PayPalStatus = "Completed">
<cfset CRESecure = "yes">
<cfset AuthNumber = attributes.ApprovalCode>						

<cfset DateStamp = "Transaction " & AuthNumber & " received " & DateFormat(Now(), "mm/dd/yyyy")>
<cfset DateStamp = DateStamp & " " & Timeformat(Now(), "HH:mm") & " -">

<!--- check for cancelletion --->
<cfif attributes.action IS "cancel">

	<cflocation url="#self#?fuseaction=shopping.checkout&step=payment#Request.Token2#" addtoken="false">

<!--- Verfiy that the return post include the session key that we sent for this user --->
<cfelseif attributes.sess_id IS session.formKeys.cre_form>

	<cfif attributes.msg IS "Success" AND NOT len( attributes.error )>
	
		<!--- Check if the amount sent was correct and basket exists --->
		<cfquery name="GetTotal" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
			SELECT OrderTotal FROM #Request.DB_Prefix#TempOrder
			WHERE BasketNum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.BasketNum#">
		</cfquery>
		
		<!--- Could not find the order --->
		<cfif NOT GetTotal.RecordCount>
			<cfset logmess = "#DateStamp# The order could not be found in the database.">
			<cfset message = "Sorry, your order could not be found in our system. Please contact customer support."> 
			<cfset attributes.step = "error">
			
		<cfelse>							
			<!--- Validate the order with CRE Secure --->	
			<cfset orderTotal = Round(GetTotal.OrderTotal*100)/100 >
			<cfset valOrder = "CRESecureID=#GetSettings.Username#&CRESecureAPIToken=#GetSettings.Password#&order_id=#attributes.order_id#&total_amt=#orderTotal#&trans_id=#attributes.TxnGUID#">
			
			<!--- post back to CRE Secure system to validate --->
			<cfif GetSettings.CCServer IS "LIVE">
				<cfset serverURL = "https://direct.cresecure.net/direct/services/validation">
			<cfelse>
				<cfset serverURL = "https://direct.sandbox-cresecure.net/direct/services/validation">	
			</cfif>	
			
			<cfhttp url="#serverURL#?#valOrder#" method="get" resolveurl="false"></cfhttp>
			
			<cfscript>
				//Parse the response
				ParsedResults = StructNew();
				ResponseCodes = ListToArray(CFHTTP.FileContent, "&");
				//Save into structure of values
				for (i=1; i lte arrayLen( ResponseCodes ); i=i+1) { 
					code = ResponseCodes[i];
					CodeName = ListGetAt( code, 1, "=" );
					CodeValue = ListGetAt( code, 2, "=" );
					StructInsert(ParsedResults, CodeName, CodeValue);	
				}
			</cfscript>
	
			<!--- Check the validation response --->
			<cfif StructKeyExists( ParsedResults,"status" ) AND ParsedResults.status IS "success" 
					AND StructKeyExists( ParsedResults,"order_id_match" ) AND ParsedResults.order_id_match IS "YES" 
					AND StructKeyExists( ParsedResults,"total_amt_match" ) AND ParsedResults.total_amt_match IS "YES" 
					AND StructKeyExists( ParsedResults,"trans_id_match" ) AND ParsedResults.trans_id_match IS "YES">
	
				<!--- Copy variables --->
				<cfset attributes.CardType = attributes.type>
				<cfset attributes.NameonCard = attributes.name>
				<cfset attributes.cardnumber = attributes.mPAN>
				<cfset cardexp = Left(attributes.exp,2) & "/" & Right(attributes.exp,2)>
				<cfset TransactNum = attributes.TxnGUID>
				<cfset InvoiceNum = Session.BasketNum>
				
				<!--- Place the Order --->			
				<cfset logmess = "#DateStamp# Transaction has been placed.">
				<cfset attributes.step = "receipt">					
			
			<cfelse>
			
				<cfset logmess = "#DateStamp# The order could not be completed.">
				<cfset message = "The CRE Secure validation response for this order response was invalid.">
				<cfset attributes.step = "error">
				
			</cfif>
			
		</cfif>

	<cfelse>
		<cfset logmess = "#DateStamp# The order could not be completed.">
		<cfset message = "We did not receive a success from CRE Secure. Error: #attributes.msg#">
		<cfset attributes.step = "error">
		
	</cfif>
	
<cfelse>
	<cfset logmess = "#DateStamp# The order could not be completed.">
	<cfset message = "The session key returned by CRE Secure was not valid">
	<cfset attributes.step = "error">			
	
</cfif>

<cfif len(logmess) AND get_Order_Settings.PayPalLog>
	<cftry>
	<cffile action="append" file="#theDirectory##Request.slash#cresecure_log.txt" output="#logmess#">
	<cfcatch></cfcatch>
	</cftry>	
</cfif>

