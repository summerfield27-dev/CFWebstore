<!--- CFWebstore, version 6.50 --->

<!--- Displays the order shipping charges and other information (comments, gift cert, coupon, etc.) --->

<!--- Called by shopping.checkout (step=payment) --->

<!-- start shopping/checkout/dsp_invoice_shipping.cfm -->
<div id="dspinvoiceshipping" class="shopping">

<cfoutput>
<table border="0" cellspacing="0" cellpadding="6" width="520" align="center" class="formtext">
	<tr>
	<td valign="top" width="50%">
<!--- If shipping calculated by weight or UPS, display total weight --->
<cfif NOT ListFind("Price,Price2,Items",ShipSettings.ShipType) AND Session.CheckoutVars.TotalWeight GT 0>
	<b>Total Weight:</b> #Session.CheckoutVars.TotalWeight# #Request.AppSettings.WeightUnit#<br/>
</cfif>

<cfif ShipSettings.ShowFreight AND TotalFreight>
	<b>Freight Charges:</b> #LSCurrencyFormat(TotalFreight)#<br/>
	<cfset ShipAmount = ShipCost>
<cfelse>
	<cfset ShipAmount = ShipCost + TotalFreight>
</cfif>

<b>Shipping Charges:</b> 
<!--- If shipping not calculated, display message --->
<cfif Session.CheckoutVars.NoShipInfo IS 1>
	#ShipSettings.NoShipMess#
<!--- If shipping was calculated, and is 0, no shipping charges --->
<cfelseif ShipAmount IS 0>
	No Shipping Charges
<!--- Else Display Shipping Cost --->
<cfelse>
	#LSCurrencyFormat(ShipAmount)#
</cfif>

<cfif len(GetTempOrder.Delivery)>
<br/><br/><b>Ship to arrive on/by:</b> #GetTempOrder.Delivery#
</cfif>

<cfif Session.CheckoutVars.Download>
	<br/><br/>Downloadable products will be available on the My Account page of this web site after the order is processed.
</cfif>


</td><td valign="top" width="50%">


<cfif len(GetTempOrder.giftcard)>
<b>Gift Card Message:</b> #HTMLEditFormat(GetTempOrder.GiftCard)#
<br/></cfif>

<cfif len(Session.Coup_Code)>
<b>Coupon:</b> #Session.Coup_Code#
<br/></cfif>

<cfif len(Session.Gift_Cert)>
<b>Gift Certificate:</b> #Session.Gift_Cert#
<br/></cfif>

<!--- Output custom text fields --->
<cfloop index="x" from="1" to="3">
	<cfif len(GetTempOrder['CustomText' & x][1])>
	<strong>#get_Order_Settings['CustomText' & x][1]#: </strong> 
	#HTMLEditFormat(GetTempOrder['CustomText' & x][1])#<br/>
	</cfif>
</cfloop>
<!--- Output custom selectbox fields --->
<cfloop index="x" from="1" to="2">
	<cfif len(GetTempOrder['CustomSelect' & x][1])>
	<strong>#get_Order_Settings['CustomSelect' & x][1]#: </strong> 
	#HTMLEditFormat(GetTempOrder['CustomSelect' & x][1])#<br/><br/>
	</cfif>
</cfloop>

<cfif len(GetTempOrder.comments)>
<b>Comments:</b> #GetTempOrder.comments#
<br/>
</cfif>

</td>
</tr></table><br/>
</cfoutput>

</div>
<!-- end shopping/checkout/dsp_invoice_shipping.cfm -->
