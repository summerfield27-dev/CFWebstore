<!--- CFWebstore, version 6.50 --->

<!--- This page outputs the profile query in the designated number of columns. --->

<!--- Set the number of columns by attribute, category, application --->
<cfparam name="attributes.accountCols" default="#request.appsettings.PColumns#">

<cfif isDefined("request.qry_get_cat.pcolumns") and len(request.qry_get_cat.pcolumns)>
	<cfset attributes.accountCols = request.qry_get_cat.pcolumns>
</cfif>

<!-- start users/account/dsp_accounts.cfm -->
<div id="dspaccounts" class="users">

<!--- List Grouped by Metro --->
<cfif attributes.sortby is "city" or attributes.sortby is "type1">

	<cfoutput query="qry_get_accounts" group="#attributes.sortby#" startrow="#pt_startrow#" maxrows="#attributes.displaycount#"> <!---#Request.AppSettings.maxprofiles#>---->

	<cfif qry_get_accounts.currentrow lte pt_endrow>
		
		<cfoutput group="#attributes.sortby#">
		<div class="listinghead" align="left"><br/>&nbsp;<b><cfif attributes.sortby is "city">#HTMLEditFormat(state)# - #HTMLEditFormat(city)#<cfelse>#sanitize(attributes.sort)#</cfif></b></div>
		<cfmodule template="../../customtags/putline.cfm" linetype="Thin" width="98%">			
				
	<cfoutput>
<cfif currentrow lte pt_endrow>	
		
		<cfif attributes.accountCols LTE 1 OR qry_get_accounts.CurrentRow MOD attributes.accountCols IS 1>
	<table cellspacing="2" cellpadding="0" border="0" width="98%"><tr>
		</cfif> 
		
		<td valign="top" width="#Round(100/attributes.accountCols)#%" align="center">
			<cfinclude template="put_accounts_listing.cfm">
		</td>
		

		<cfif attributes.accountCols LTE 1 OR qry_get_accounts.CurrentRow MOD attributes.accountCols IS 0>
		</tr></table>
	
			<cfif qry_get_accounts.CurrentRow is not pt_endrow and qry_get_accounts.CurrentRow is not recordcount>
				<cfmodule template="../../customtags/putline.cfm" linetype="Thin" width="98%">
			</cfif>
		<cfelseif qry_get_accounts.CurrentRow IS qry_get_accounts.RecordCount>
			<cfloop index = "num" from="1" to="#(attributes.accountCols - qry_get_accounts.CurrentRow MOD attributes.accountCols)#">
			<td>&nbsp;</td>
			</cfloop>
			</tr></table> 
			<cfif qry_get_accounts.CurrentRow is not pt_endrow and qry_get_accounts.CurrentRow is not recordcount>
				<cfmodule template="../../customtags/putline.cfm" linetype="Thin" width="98%">
			</cfif>
		</cfif>	
		
		</cfif>
		</cfoutput>
		
	</cfoutput>
	</cfif>
</cfoutput>

<cfelse>

<!--- List with NO Grouping ----------->
<cfloop query="qry_get_accounts" startrow="#PT_StartRow#" endrow="#PT_EndRow#">

	<!--- Name and description --->
	<cfoutput>

	<cfif attributes.accountCols LTE 1 OR qry_get_accounts.CurrentRow MOD attributes.accountCols IS 1>
	<table cellspacing="2" cellpadding="0" border="0" width="98%"><tr>
	</cfif> 
	
		<td valign="top" width="#Round(100/attributes.accountCols)#%" align="center">
	
	</cfoutput>

			<cfinclude template="put_accounts_listing.cfm">
				
<cfoutput></td></cfoutput>



<cfif attributes.accountCols LTE 1 OR qry_get_accounts.CurrentRow MOD attributes.accountCols IS 0>
	<cfoutput></tr></table></cfoutput>

	
	<cfif qry_get_accounts.CurrentRow is not pt_endrow and qry_get_accounts.CurrentRow is not recordcount>

		<cfmodule template="../../customtags/putline.cfm" linetype="thin" width="98%">
	</cfif>

<cfelseif qry_get_accounts.CurrentRow IS qry_get_accounts.RecordCount>
	<cfloop index = "num" from="1" to="#(attributes.accountCols - qry_get_accounts.CurrentRow MOD attributes.accountCols)#">
		<cfoutput><td>&nbsp;</td></cfoutput>
	</cfloop>
	<cfoutput></tr></table> </cfoutput>

	<cfif currentrow is not pt_endrow>
		<cfmodule template="../../customtags/putline.cfm" linetype="thin" width="98%">
	</cfif>

</cfif>	

</cfloop>

</cfif>

</div>
<!-- end users/account/dsp_accounts.cfm -->
