<!--- CFWebstore, version 6.50 --->


<!--- This page displays the terms of agreement accepted by the customer when the order was placed
	--->
	
	<!--- Called by shopping.admin&order=viewterms --->

<cfparam name="attributes.Order_No" default="0">

<cfquery name="GetOrder" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT O.TermsUsed
	FROM #Request.DB_Prefix#Order_No O
	WHERE O.Order_No = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Order_No#"> 
</cfquery>

<p>&nbsp;</p>
	<cfmodule template="../../../customtags/format_input_form.cfm"
	box_title="Terms of Purchase"
	width="500"
	required_fields="0"
	>

	<cfoutput>#GetOrder.TermsUsed#</cfoutput>

	
	</cfmodule>
	
<!--- Bring window to the front --->
<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
window.focus();
</script>
</cfprocessingdirective>

