
<!--- CFWebstore, version 6.50 --->

<!--- Displays confirmation messages for adding/editing/deleting a standard addon. Called by act_stdaddon.cfm --->
		
<cfmodule template="../../../customtags/format_admin_form.cfm"
	box_title="Standard Addon"
	width="400"
	required_fields="0"
	>
	
	<tr><td align="center" class="formtitle">
	<br/>
	
	<cfif submit is "Delete">
	 
	 	Are you sure you want to delete this addon? 
		This will delete it from all products as well as from the Addon Manager.
		<p>	
		
		<table>
			<tr>
				<cfoutput>
				<td>
				<form action="#self#?fuseaction=product.admin&Stdaddon=delete#request.token2#" method="post">
				<input type="hidden" name="std_id" value="#attributes.std_id#"/>
				<cfset keyname = "stdaddonDelete">
				<cfinclude template="../../../includes/act_add_csrf_key.cfm">
				<input class="formbutton" type="submit" value="Delete addon">
				</form>		
				</td>
						
				<td>
				<form action="#self#?fuseaction=product.admin&Stdaddons=list#request.token2#" method="post">		
				<input class="formbutton" type="submit" value="Cancel"/>
				</form>
				</td>
				</cfoutput>
			</tr>
		</table>	

	<cfelse>
	
		Addon <cfif mode is "i">Added<cfelse>Updated</cfif>
		<p>	
		
		<table><cfoutput>
			<tr>						
				<td>
				<form action="#self#?fuseaction=product.admin&Stdaddon=list#request.token2#" method="post">
				<input class="formbutton" type="submit" value="Back to List"/>
				</form>		
				</td>
				
			<cfif isdefined("attributes.product_id")>									
				<td>
				<form action="#self#?fuseaction=product.admin&do=addons&product_id=#attributes.product_id#<cfif isdefined("attributes.cid") and attributes.cid is not "">&cid=#attributes.cid#</cfif>#request.token2#" method="post">	
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
	
	