<!--- CFWebstore, version 6.50 --->

<!--- Displays the form for editing the product custom fields. Called by product.admin&fields=edit --->

<cfset act_title="Product Custom Fields">
<cfset action="#self#?fuseaction=product.admin&fields=act">
  
<cfhtmlhead text='<!--[if lt IE 7]>
	<script type="text/javascript" src="#Request.StorePath#includes/IEDOM.js"></script>
	<![endif]-->'>
<cfhtmlhead text='<script type="text/javascript" src="#Request.StorePath#includes/addcustomfields.js"></script>'>

<cfmodule template="../../../customtags/format_admin_form.cfm"
	box_title="#act_title#"
	width="650"
	required_fields="0"
	>
	
	<cfoutput>	
	<tr><td colspan="3">
Custom Fields allow you to add unique information fields to your store products. For instance, if you have a video store, you may want to display the video's director, running time and the year it was released. You can also use these fields to export information to Google Base. You can define these custom fields here and they will be available in the Product Manager under the Info tab. If you have set the field to "Display" here it will be visible on the product detail page in the store. However, if a field is left empty for a particular product, it will not display in the store.	<br/><br/>
<strong>NOTE:</strong> Checking 'Remove' will delete the custom field, as well as any product data entered for it.
	</td></tr>
	
	<tr><td colspan="3">
	<form action="#action##request.token2#" method="post" id="fieldform">		
	<input type="hidden" name="TotalFields" value="">
	<cfset keyname = "prodCustomFields">
	<cfinclude template="../../../includes/act_add_csrf_key.cfm">
	
	<script type="text/javascript">
	addtable();
	
	var tbl = document.getElementById('customfields');
	var frm = document.getElementById('fieldform');
	
	<!--- if no custom fields yet, start with one --->
	<cfif NOT qry_get_customfields.RecordCount>		
		createRow(tbl, frm, 1, 1, '', '', 0, 0, 0);
	
	<cfelse>
		<cfloop query="qry_get_customfields">
			createRow(tbl, frm, #currentrow#, #Custom_ID#, '#Custom_Name#', '#Google_Code#', #Custom_Display#, #Google_Use#);
		</cfloop>
	</cfif>
	
	</script>

	</form>	
	</td>
</tr>
<tr><td colspan="3"></td></tr>
</cfoutput>
</cfmodule>
	
