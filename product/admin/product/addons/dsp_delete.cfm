<!--- CFWebstore, version 6.50 --->

<!--- Prompts the user to confirm that they wish to delete a product addon. Called by product.admin&addon=change --->

<cfset formkey = CreateUUID()>
<cfset session.formKeys.editAddon = formkey>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
if (window.confirm("Are you sure you want to delete this addon?")) 
	{ var address="<cfoutput>#self#?fuseaction=product.admin&addon=delete&addon_id=#attributes.addon_id#&product_id=#attributes.product_id#&cid=#attributes.cid#&redirect=1&formkey=#Hash(formkey,"SHA-256")#</cfoutput>";      
	}
	else { 
		var address="<cfoutput>#self#?fuseaction=product.admin&do=addons&product_id=#attributes.product_id#&cid=#attributes.cid#&redirect=1&formkey=#Hash(formkey,"SHA-256")#</cfoutput>";
		}
   window.location = address;
</script>
</cfprocessingdirective>

