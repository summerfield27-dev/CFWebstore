<!--- CFWebstore, version 6.50 --->

<!--- This page displays the subcategory links for a selected category. Used to browse categories on various admin list views.   --->

<!---- requires qry_get_subcats.cfm (request scope --->
<cfset replacetext = "&#id_type#=#id#">
<cfset linkstring="#Replace(addedpath,replacetext,'')#">
<cfset linkstring="#RemoveChars(linkstring,1,1)#">


<!--- Create the four column box. --->
<cfif request.qry_get_subcats.recordcount>
<cfoutput>
<table width="100%" cellspacing="2" cellpadding="2" class="formtext"  style="color: ###Request.GetColors.OutputTText#;">
<tr>
	<td width="10%"><img src="#Request.ImagePath#spacer.gif" alt="" width="25" height="1" /></td>
	<td valign="top" width="40%">
</cfoutput>

<cfset colchange = round(request.qry_get_subcats.recordcount / 2)>
<cfif colchange lt 1>
	<cfset colchange = 1>
</cfif>

<cfloop query="request.qry_get_subcats" startrow="1" endrow="#colchange#">

<cfoutput><li><a href="#self#?#linkstring#&#id_type#=#category_id##Request.Token2#">#name#</a></li> </cfoutput> 

</cfloop>

<!--- close first half of table and open the second --->
<cfoutput>
	</td>
	<td width="10%"><img src="#Request.ImagePath#spacer.gif" alt="" width="25" height="1" /></td>
	<td valign="top" width="40%">
</cfoutput>

<cfset colchange = colchange + 1>

<cfloop query="request.qry_get_subcats" startrow="#colchange#" endrow = "#request.qry_get_subcats.recordcount#">

<cfoutput><li><a href="#self#?#linkstring#&#id_type#=#category_id##Request.Token2#">#name#</a></li> </cfoutput> 

</cfloop>

<!--- close table --->
<cfoutput>
</td></tr></table>
</cfoutput>

</cfif>