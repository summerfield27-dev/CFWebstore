
<!--- CFWebstore, version 6.50 --->

<!--- Displays confirmation messages for adding/editing/deleting a standard option. Called by act_stdoption.cfm --->


<cfmodule template="../../../customtags/format_admin_form.cfm"
	box_title="Standard Option"
	width="400"
	required_fields="0"
	>
				
	<tr><td align="center" class="formtitle">
	<br/>
		
	<cfif attributes.submit is "Delete">
	 
	 	Are you sure you want to delete this option? 
		This will delete it from all products as well as from the Option Manager.
		Any orders with inventory related to this option will no longer update stock amounts.
		<p>	
		
		<table>
			<tr>
				<cfoutput>
				<td>
				<form action="#self#?fuseaction=product.admin&StdOption=delete#request.token2#" method="post">
				<input type="hidden" name="std_id" value="#attributes.std_id#"/>
				<cfset keyname = "stdoptionDelete">
				<cfinclude template="../../../includes/act_add_csrf_key.cfm">
				<input class="formbutton" type="submit" value="Delete Option"/>
				</form>		
				</td>			
				<td>
				<form action="#self#?fuseaction=product.admin&StdOptions=list#request.token2#" method="post">	
				<input class="formbutton" type="submit" value="Cancel"/>
				</form>
				</td>
				</cfoutput>
			</tr>
		</table>	

	<cfelse>
	
		Option <cfif mode is "i">Added<cfelse>Updated</cfif>
		<p>	
		
		<table><cfoutput>
			<tr>
				<td>
				<form action="#self#?fuseaction=product.admin&StdOption=list#request.token2#" method="post">
				<input class="formbutton" type="submit" value="Back to List"/>
				</form>		
				</td>
				
			<cfif isdefined("attributes.product_id")>	
				<td>
				<form action="#self#?fuseaction=product.admin&do=options&product_id=#attributes.product_id#<cfif isdefined("attributes.cid") and attributes.cid is not "">&cid=#attributes.cid#</cfif>#request.token2#" method="post">			
				<input class="formbutton" type="submit" value="Back to Product"/>
				</form>
				</td>
			</cfif>	
			</tr>
			</cfoutput>
		</table>	
				
	</cfif>
	
	</td></tr>
	
</cfmodule> 
		
		