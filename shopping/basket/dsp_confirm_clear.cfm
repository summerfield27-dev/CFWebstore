<!--- CFWebstore, version 6.50 --->

<!--- Confirm emptying of cart on clear. Called by shopping.basket --->
	
<!-- start shopping/basket/dsp_confirm_clear.cfm -->
<div id="dspconfirmclear" class="shopping">

<p>&nbsp;</p>

<cfmodule template="../../customtags/format_input_form.cfm"
	box_title="Clear Shopping Cart"
	width="400"
	required_fields="0">
	
	<tr><td align="center">
		<p class="formtitle"><br/>This will completely empty your cart!<br/>Are you sure you want to continue?</p>
	</td></tr>
	

	<tr><td align="center">
	<cfoutput>
	<form action="#XHTMLFormat('#self#?fuseaction=shopping.clear#request.token2#')#" method="post" class="margins">
	</cfoutput>
	<input type="submit" name="Clear" value="  Yes  " class="formbutton"/> 
	<input type="submit" name="Clear" value="  No  " class="formbutton"/> 
	</form>
	</td></tr>	
	

</cfmodule>

</div>
<!-- end shopping/basket/dsp_confirm_clear.cfm -->	