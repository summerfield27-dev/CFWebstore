<!--- CFWebstore, version 6.50 --->

<!--- Prompts the user to confirm that they wish to delete a product option. Called by product.admin&option=change --->

<cfset formkey = CreateUUID()>
<cfset session.formKeys.editOption = formkey>

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">

if (window.confirm("Are you sure you want to delete this option?")) 
	{ var address="<cfoutput>#self#?fuseaction=product.admin&option=delete&option_id=#attributes.option_id#&product_id=#attributes.product_id#&cid=#attributes.cid#&redirect=1&formkey=#Hash(formkey,"SHA-256")##Request.Token2#</cfoutput>";      
	}
	else { 
		var address="<cfoutput>#self#?fuseaction=product.admin&do=options&product_id=#attributes.product_id#&cid=#attributes.cid#&redirect=1&formkey=#Hash(formkey,"SHA-256")##Request.Token2#</cfoutput>";
		}
   window.location = address;

</script>
</cfprocessingdirective>

