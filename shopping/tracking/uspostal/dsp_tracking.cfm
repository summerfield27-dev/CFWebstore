<!--- CFWebstore, version 6.50 --->

<!--- This page is called by the shopping.tracking fuseaction and used to display the order tracking form for USPS Tracking. --->

<cfparam name="attributes.message" default="">

<!-- start shopping/tracking/uspostal/dsp_tracking.cfm -->
<div id="dsptracking" class="shopping">
	
<!--- Hide the form if tracking information is being displayed --->
<cfif NOT isDefined("ShowTracking")>

<cfoutput>
<form name="tracking" action="#XHTMLFormat('#request.self#?fuseaction=shopping.tracking#request.token2#')#" method="post">

<cfmodule template="../../../customtags/format_input_form.cfm"
box_title="U.S. Postal Service Tracking"
width="475"
required_fields="0"
>	

	<tr>
		<td align="center" valign="top" width="125">
		<img src="#Request.ImagePath#icons/hdr_uspsLogo.gif" alt="" width="160" height="60" border="0" />
		</td>
		<td colspan="2"><br/>To track an order, please enter the order number along with the zip code for the 
		billing address used when placing your order.</td>
	</tr>
<tr><td colspan="3"><img src="#Request.ImagePath#spacer.gif" alt="" height="3" width="1" /></td></tr>

	<cfif len(attributes.Message)>
	<tr>
		<td colspan="3" align="center" class="formerror">#attributes.Message#<br/><br/></td></tr>
	</cfif>
		
	<tr align="left">
		<td align="right" nowrap="nowrap">Order Number:</td>
		<td style="background-color: ###Request.GetColors.formreq#;" width="3">&nbsp;</td>
		<td align="left" width="95%"><input type="text" size="20" name="ordernum" class="formfield"/></td></tr>
		
	<tr align="left">
		<td align="right" nowrap="nowrap">Zip Code:</td>
		<td style="background-color: ###Request.GetColors.formreq#;">&nbsp;</td>
		<td align="left"><input type="text" size="20" name="zipcode" class="formfield"/></td></tr>

	
	<tr><td colspan="3" align="center"><br/> 
	<input type="submit" name="submit_tracking" value="Track" class="formbutton"/>
	 <input type="button" value="Cancel" onclick="javascript:window.history.go(-1);" class="formbutton"/>
	 </td></tr>
		
 <tr><td colspan="3" align="center"><br/>
<i>Information provided by <a href="http://www.usps.com">http://www.usps.com</a>.</i></td></tr> 


</cfmodule>
</form>
</cfoutput>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
<!--
objForm = new qForm("tracking");

objForm.required("ordernum,zipcode");

objForm.ordernum.description = "Order Number";

qFormAPI.errorColor = "<cfoutput>###Request.GetColors.formreq#</cfoutput>";
//-->
</script>
</cfprocessingdirective>	

<cfelse>

	<table class="formtext" cellpadding="3" cellspacing="3">
	 <tr><td colspan="3" align="center"><br/>
<i>Information provided by <a href="http://www.usps.com">http://www.usps.com</a>.</i></td></tr> </table>

</cfif>

</div>
<!-- end shopping/tracking/uspostal/dsp_tracking.cfm -->
