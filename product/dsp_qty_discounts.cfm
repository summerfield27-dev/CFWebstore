<!--- CFWebstore, version 6.50 --->

<!--- This template outputs the quantity discount chart for a product. Called by product.qty_discount
	Product_ID
	Wholesale
--->
<!--- Set this parameter to 0 if you would like to show the PRICE PER and not DISCOUNT PER in the table --->
<cfparam name="attributes.discountper" default="1">

<cfoutput>
<!-- start product/dsp_qty_discounts.cfm -->
<div id="dspqtydiscounts" class="product">
	<br/>
	<table width="240" border="0" cellspacing="3" cellpadding="0" class="prodSKU">
	<tr>
		<td colspan="3"><img src="#Request.ImagePath#spacer.gif" width="1" height="5" alt="" /></td>
	</tr>
	<tr>
	<td colspan="3" align="center">Quantity Discounts</td>
	</tr>
	
	<tr>
		<td colspan="3" style="background-color: ###Request.GetColors.boxhbgcolor#;">
		<img src="#Request.ImagePath#spacer.gif" width="1" height="1" alt="" /></td>
	</tr>
	
	<tr>
	<th>From</th>
	<th>To</th>
	<th align="right"><cfif attributes.discountper is 1>Discount<cfelse>Price</cfif> Per</th>
	</tr>

	<cfloop query="qry_Qty_Discounts">
	<tr>
		<td align="center">#QuantFrom#</td>
		<td align="center"><cfif quantto>#QuantTo#<cfelse>And Above</cfif></td>
	<cfif attributes.discountper is 1>
		<td align="right">-#LSCurrencyFormat(DiscountPer)#&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<cfelse>
		<td align="right">#LSCurrencyFormat(qry_get_products.Base_Price - DiscountPer)#&nbsp;&nbsp;&nbsp;&nbsp;</td> 
	</cfif>
	</tr>
	</cfloop>
	
	</table><br/>
</div>
<!-- end product/dsp_qty_discounts.cfm -->
</cfoutput>