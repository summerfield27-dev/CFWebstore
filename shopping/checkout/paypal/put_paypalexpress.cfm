<!--- CFWebstore, version 6.50 --->

<!--- Creates the button for starting an express checkout function with PayPal. Will redirect to a page that generates a SOAP express checkout requests and then redirects the user to PayPal. Called from shopping/checkout/customer/dsp_addresses.cfm --->

<!-- start shopping/checkout/paypal/put_paypalexpress.cfm -->
<div id="putpaypalexpress" class="shopping">

<cfmodule template="../../../customtags/format_input_form.cfm"
box_title="Fast, Secure Checkout with PayPal"
width="400"
required_Fields="0"
>
<cfif len(Message)>
<tr>
	<cfoutput><td colspan="3" align="center" class="formerror"><br/>#Message#<br/><br/></td></cfoutput>
</tr>
</cfif>			
<cfoutput><a href="#XHTMLFormat('#self#?fuseaction=shopping.checkout&step=pp_express#request.token2#')#"></cfoutput>
<img src="https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif" align="left" style="margin-right:7px;border-style:none" /></a><span style="font-size:11px; font-family: Arial, Verdana;">Save time.  Checkout securely.  Pay without sharing your financial information.</span>
</cfmodule>
<br/><br/>

</div>
<!-- end shopping/checkout/paypal/put_paypalexpress.cfm -->