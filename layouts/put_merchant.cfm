<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- This page can be used to output the merchant address and email on your layout files. --->
<!--- Make replacements for @ and . in address string to HIDE email address from spambots. --->
<cfset email = Replace(Request.AppSettings.MerchantEmail, "@", "&##64;", "All")>
<cfset email = Replace(email, ".", "&##46;", "All")>

</cfsilent>

<cfoutput>
<!-- start layouts/put_merchant.cfm -->
<div id="putmerchant" class="menu_footer">
<cfif len(Request.AppSettings.Merchant)>#Request.AppSettings.Merchant#<br/></cfif>
<cfif len(Request.AppSettings.MerchantEmail)>
<a href="mailto&##58;#email#">#email#</a>
</cfif></div>
<!-- end layouts/put_merchant.cfm -->
</cfoutput>
