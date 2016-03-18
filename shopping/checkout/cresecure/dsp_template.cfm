<!--- CFWebstore, version 6.50 --->

<!--- Used to output the text for the CRE Secure template on the checkout page. Called by shopping.checkout (step=payment&show=template) --->

<!--- Optional code to modify user menus to remove javascript --->
<!--- Be sure to reset the menus after running the checkout --->

<cfhtmlhead text='<link rel="stylesheet" href="#Request.StorePath#css/cresecure.css" type="text/css"/>'>

<!-- start shopping/checkout/cresecure/dsp_template.cfm -->
<div id="dspcresecure" class="shopping">

<table width="520" border="0" cellspacing="0" cellpadding="6" align="center" class="formtext">
<tr><td>
<cfoutput>	
<strong>ORDER TOTAL:</strong> #LSCurrencyFormat(GetTempOrder.OrderTotal)#<br/><br/>
</cfoutput>

[[FORM INSERT]]

</td></tr></table>
</div>
<!-- end shopping/checkout/cresecure/dsp_template.cfm -->
