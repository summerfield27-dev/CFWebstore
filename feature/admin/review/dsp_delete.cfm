<!--- CFWebstore, version 6.50 --->

<!--- Prompts the user to confirm that they wish to delete a feature review. Called by feature.admin&review=delete --->

<cfprocessingdirective suppresswhitespace="no">
<script type="text/javascript">
if (window.confirm("Are you sure you want to delete this feature review?")) 
	{ var address="<cfoutput>#self#?fuseaction=feature.admin&review=act&delete=#attributes.review_id#&XFA_success=#URLEncodedFormat(attributes.XFA_success)#</cfoutput>";      
	}
	else { 
		var address="<cfoutput>#Session.Page#</cfoutput>";
		}
   top.location = address;
</script>
</cfprocessingdirective>
