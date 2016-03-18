<!--- CFWebstore, version 6.50 --->

<!--- Allows you to login as the customer. For use by the telephone order person. Called by users.loginAsAnother --->

<!--- Retrieve list of users --->
<cfinclude template="../admin/user/qry_get_users.cfm">
<cfinclude template="../admin/group/qry_get_all_groups.cfm">
<cfset group_picklist = "">
	<cfloop query="qry_get_all_groups">
		<cfset group_picklist = ListAppend(group_picklist, 
		"#name#|#group_id#")>
	</cfloop>
		
<!--- If admin user has already selected user to login as, then do it. --->
<cfparam name="attributes.action" default="">

<cfif attributes.action is "login">
	<cfinclude template="act_loginAsAnother.cfm">
</cfif>

<!--- Create the string with the filter parameters --->	
<cfset fieldlist="uid,un,custname,email,affiliate,gid,cid,account_id,order,show">
<cfinclude template="../../includes/act_setpathvars.cfm">

<cfparam name="currentpage" default="1">

<!--- see if user has permission to edit user information --->
<cfmodule template="../../access/secure.cfm"
keyname="users"
requiredPermission="4"
>
<cfif ispermitted>
	<cfset edituser = 1>
<cfelse>
	<cfset edituser = 0>
</cfif>	

<!--- Create the page through links, max records set to 20 --->
<cfmodule template="../../customtags/pagethru.cfm" 
	totalrecords="#qry_get_users.recordcount#" 
	currentpage="#currentpage#"
	templateurl="#thisSelf#"
	addedpath="#addedpath##request.token2#"
	displaycount="20" 
	imagepath="#Request.ImagePath#icons/" 
	imageheight="12" 
	imagewidth="12"
	hilightcolor="###request.getcolors.mainlink#" 
	>
	
<!-- start users/login/dsp_loginAsAnother.cfm -->
<div id="dsploginasanother" class="users">

<cfmodule template="../../customtags/format_output_box.cfm"
	box_title="Users"
	width="800"
	align="left">
		
<cfoutput>	
<table width="100%" cellspacing="4" border="0" cellpadding="0" class="formtext" style="color: ###Request.GetColors.OutputTText#;">						
				
	<!--- Navigation Row --->
		<tr>
			<td></td>
			<td colspan="4"	align="right">#pt_pagethru#</td>
		</tr>
		
	<!--- List Filters/search form --->	
	<form action="#self#?fuseaction=users.loginAsAnother#request.token2#" method="post">
		<tr>
			<input type="hidden" name="show" value="all" />
			
			<td><span class="formtextsmall">&nbsp;<br/></span>
			<input type="submit" value="Search" class="formbutton" /></td>
			
			<td>
			<span class="formtextsmall">user</span><br/>
			<input type="text" name="un" size="8" maxlength="25" value="#attributes.un#" class="formfield" /></td>

			<td>
			<span class="formtextsmall">name (first or last)</span><br/>
			<input type="text" name="Custname" size="20" maxlength="25" value="#attributes.Custname#" class="formfield" /></td>

			<td>
			<span class="formtextsmall">email</span><br/>
			<input type="text" name="email" size="12" maxlength="25" value="#attributes.email#" class="formfield" /></td>	
	
			<td><span class="formtextsmall">affiliate<br/></span>
			<select name="affiliate" class="formfield">
				<option value="">all</option>
				<option value="0" #doSelected(attributes.affiliate,0)#>no</option>
				<option value="1" #doSelected(attributes.affiliate,1)#>yes</option>
			</select>	
			</td>	
			
			<td><span class="formtextsmall">group<br/></span>
			<select name="gid" size="1" class="formfield">
				<option value="">all</option>
				<option value="0">unassigned</option>
				<cfmodule template="../../../customtags/form/dropdown.cfm"
				mode="combolist"
				valuelist="#group_picklist#"
				selected="#attributes.gid#"
				/></select>
			</td>			
				
		<td><span class="formtextsmall">bill | ship<br/></span>
			<input type="text" name="cid" size="4" maxlength="25" class="formfield" value="#attributes.cid#"/>
			</td>	
		
		<td>
			<span class="formtextsmall">acct<br/></span>
			<input type="text" name="account_id" size="2" maxlength="25" class="formfield" value="#attributes.account_id#"/>
			</td>		
			
		</form>
	
			<td align="center"><span class="formtextsmall">&nbsp;<br/></span>
				<a href="#self#?fuseaction=users.loginAsAnother&show=All#Request.Token2#">ALL</a><br/> 
				<a href="#self#?fuseaction=users.loginAsAnother&show=recent#Request.Token2#">Recent</a></td>	
		</tr>

		<tr>
			<td colspan="9"><cfif attributes.show IS "recent">Recent Activity<cfelseif attributes.show IS "All">
				All Users</cfif></td>
		</tr>

		<tr>
			<td colspan="9" style="background-color: ###Request.GetColors.outputHBgcolor#;">
				<img src="#Request.ImagePath#spacer.gif" height="1" width="1" alt=""></td>
		</tr>
		
		<!--- Output List --->		
		<cfif qry_get_Users.recordcount gt 0>
		
			<cfset formkey = CreateUUID()>
			<cfset session.formKeys.loginAsAnother = formkey>
			
			<cfloop query="qry_get_Users" startrow="#PT_StartRow#" endrow="#PT_EndRow#">
				<tr>
					<td>
					<a href="#self#?fuseaction=users.loginAsAnother&action=login&UserName=#username#&formkey=#Hash(formkey,"SHA-256")##Request.Token2#">Login As</a>
					</td>
			
					<td class="formtextsmall"><cfif edituser><a href="#self#?fuseaction=users.admin&user=summary&UID=#user_id##Request.Token2#">
						#username#</a><cfelse>#username#</cfif> </td>
	
					<td class="formtextsmall">#firstname# #lastname#</td>
	
					<td class="formtextsmall"><a href="#self#?fuseaction=users.admin&email=write&UID=#user_id##Request.Token2#">#email#</a> </td>
	
					<td><cfif affiliate_ID is NOT 0>Yes<cfelse>No</cfif></td>
	
					
					<td>
						<cfif group_id>
							<a href="#self#?fuseaction=users.admin&group=list&gid=#group_id##Request.Token2#">#groupname#</a>
						<cfelse>
							Retail Customer
						</cfif>
					</td>
					
					<td align="center"><a href="#self#?fuseaction=users.admin&customer=list&uid=#User_id#&show=#Request.Token2#">#customer_id# | #shipto# </a></td>
	
					<td align="center"><a href="#self#?fuseaction=users.admin&account=list&uid=#User_ID##Request.Token2#">#accounts#</a></td>

					<td colspan="2"></td>
				</tr>
			</cfloop>
	</table>
	<div align="center" class="formtext">#pt_pagethru#</div>

		<cfelse>	
			<td colspan="7"><br/>No records selected</td>
	</table>	
		</cfif>
</cfoutput>
</cfmodule>

</div>
<!-- end users/login/dsp_loginAsAnother.cfm -->
