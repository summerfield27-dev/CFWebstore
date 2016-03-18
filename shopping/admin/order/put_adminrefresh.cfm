<!--- CFWebstore, version 6.50 --->

<!--- Displays the javascript to update the number of pending orders counter. Called after any possible actions to the order status --->

<!--- Refresh the admin menu counter if the page is not on SSL --->
<cfif CGI.SERVER_PORT IS NOT 443>
	<cfset innertext = Application.objMenus.getPendingOrders()>
	<script type="text/javascript">
	 	if (parent.AdminMenu.document.getElementById('ordercount') != null) {
			<cfoutput>parent.AdminMenu.document.getElementById('ordercount').innerHTML = '#innertext#';</cfoutput>
		}	
	</script>
</cfif>



