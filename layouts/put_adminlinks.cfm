<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Used to create the admin links for the site. Call from your layout pages --->

<cfsavecontent variable="adminmenu">	
	<div class="menu_page">	
	<!--- Users Permission 2 = show admin menu --->	
	<cfmodule template="../access/secure.cfm"
	keyname="users"
	requiredPermission="2">
	<cfoutput><a href="#XHTMLFormat('#Request.SecureSelf#?fuseaction=home.admin#Request.AddToken#')#" #doAdmin(class='menu_page')#>Admin</a></cfoutput>
	<br/>
	</cfmodule>	
	
	<!--- Shopping Permission 8, 16 or 32 --->	
	<!--- Use shopping admin page to determine the link for order editing --->
	<cfmodule template="../access/secure.cfm" keyname="shopping" requiredPermission="56">
		<cfinclude template="admin/act_orderlink.cfm">
		<cfif len(linkURL)>
		<cfoutput><a href="#XHTMLFormat(linkURL)#" #doAdmin(class='menu_page')#>Order Fullfillment</a></cfoutput>
		</cfif>
	<br/><br/>	
	</cfmodule>	
	<!---The "Login as Another User" menu--->
	<cfif isdefined("Session.AnotherUserLogin")>
		<cfoutput><a href="#Request.SecureSelf#?fuseaction=users.loginAsAnother#Request.AddToken#">Login as Another User</a></cfoutput><br/><br/>
	<cfelse>
		<!--- Users Permission 2 = User Admin Functions --->   
		<cfmodule template="../access/secure.cfm"
		keyname="shopping"
		requiredPermission="1024">
			<cfoutput><a href="#Request.SecureSelf#?fuseaction=users.loginAsAnother#Request.AddToken#">Login as<br/> Another User</a></cfoutput><br/><br/>
		</cfmodule>
	</cfif>
	</div>

</cfsavecontent>	
</cfsilent>		

<cfoutput>
	<!-- start layouts/put_adminlinks.cfm -->
	<div id="putadminlinks" class="layouts">
	#HTMLCompressFormat(variables.adminmenu)#
	</div>
	<!-- end layouts/put_adminlinks.cfm -->
</cfoutput>