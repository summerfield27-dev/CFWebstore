
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to recharge a credit card using a PayFlowPro reference transaction. The order must have been previously authorized/captured and provide a transaction number. Called from access\admin\membership\act_bill_recurring.cfm

	Required: TransactionID
			  Amount
	
--->

<!--- Retrive PayFlowPro settings --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT Username, Password, CCServer, Setting1
	FROM #Request.DB_Prefix#CCProcess
	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<!--- Reference ID will normally have a '@' appended in the front --->
<cfif Left(attributes.TransactionID,1) is "@">
	<cfset attributes.TransactionID = Right(attributes.TransactionID,Len(attributes.TransactionID)-1)>
</cfif>

<CF_PayFlowPro4Action
	QUERYNAME="Results"
	USER="#GetSettings.Username#"
	VENDOR="#GetSettings.Username#"
   	PASSWORD="#GetSettings.Password#"
 	PARTNER="#GetSettings.Setting1#"
 	SERVER="#GetSettings.CCServer#"	 
     AMOUNT="#Total#"
     TransactNum="#attributes.TransactionID#"
     ACTION="S">

	<!--- Debug --->
	<!--- <cfdump var="#Result#"> --->

	<cfif Results.Result IS NOT 0>
	<cfset ErrorMessage = Results.Respmsg & " Please change the information entered, or return to the store.">      
	<cfset display = "Yes">
	
	<cfelse>
	
	<cfset AuthNumber = Results.AuthCode>
	<cfset TransactNum = Results.PNREF>
	<cfset token = attributes.TransactionID>
	<cfset attributes.step = "receipt">
	
	<!--- DEBUG 
	<cfoutput><h1>step #attributes.step#</h1></cfoutput> ----->
	<!----------
	<cfset AuthNumber = Results.authorization_code>
	<cfinclude template="../complete.cfm">
	<cfset display = "No">
	---->
	
	</cfif>
