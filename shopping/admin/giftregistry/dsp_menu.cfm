
<!--- CFWebstore, version 6.50 --->

<!--- Displays the admin menu for gift registries. Called by admin/dsp_menu.cfm --->
<cfoutput>
	<table width="90%" class="mainpage"><tr><td><strong>Gift Registries</strong></td>
		<form name="giftregistryjump" action="#request.self#?fuseaction=shopping.admin&giftregistry=listitems#request.token2#" method="post">
		<td align="right"><input type="text" name="string" value="enter ID or Name..." size="20" maxlength="100" class="formfield" onfocus="giftregistryjump.string.value = '';" onchange="submit();" />
		</td></form>
	</tr></table>

<ul>
	<li><a href="#request.self#?fuseaction=shopping.admin&giftregistry=list">Gift Registries</a>: Create or Edit Gift Registry information.</li>
	<li><a href="#request.self#?fuseaction=shopping.admin&giftregistry=clear#Request.Token2#">Remove Expired Registries</a>: Remove expired Gift Registries.</li>
</ul>
</cfoutput>



