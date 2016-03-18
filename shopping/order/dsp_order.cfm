<!--- CFWebstore, version 6.50 --->

<!--- Used to display the order invoice in a separate window. Called from shopping.history and requires the Order Number to display.   --->

<cfset Order_No = attributes.Order - Get_Order_Settings.BaseOrderNum>

<cfmodule template="../../access/secure.cfm"
  keyname="shopping"
  requiredPermission="2"
  > 
  <cfif ispermitted>   
	<cfset displaytype = "admin">
  <cfelse>
  	<cfset displaytype = "customer">
  </cfif>
  
<!-- start shopping/order/dsp_order.cfm -->

<cfmodule template="put_order.cfm" Order_No="#Order_No#" Type="#displaytype#">

<br/><br/>

<!--- Bring window to the front --->
<script type="text/javascript">
window.focus();
</script>

<!-- end shopping/order/dsp_order.cfm -->