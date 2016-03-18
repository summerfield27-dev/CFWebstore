<!--- CFWebstore, version 6.50 --->

<!--- Prompts the user to confirm that they wish to delete a product review. Called by product.admin&review=delete --->

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
if (window.confirm("Are you sure you want to delete this product review?")) 
	{ var address="<cfoutput>#self#?fuseaction=product.admin&review=act&delete=#attributes.review_id#&XFA_success=#URLEncodedFormat(attributes.XFA_success)#</cfoutput>";      
	}
	else { 
		var address="<cfoutput>#Session.Page#</cfoutput>";
		}
   top.location = address;
</script>
</cfprocessingdirective>
