<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Used to call the CFCs for creating a list of best sellers. Call from your layout pages --->

<!--- See the written documentation for information on parameters you can use for creating your menus. --->
	
<cfif NOT isDefined("Application.BestSellers") OR isDefined("URL.Refresh") OR isDefined("URL.redirect")>
		
	<cfscript>
		BestSellers = Application.objMenus.dspBestSellers(maxnum=10,menu_class='menu_page');
		
		Application.BestSellers = HTMLCompressFormat(BestSellers);
	</cfscript>
	
</cfif>


</cfsilent>
<cfoutput>
<!-- start layouts/put_bestsellers.cfm -->
<div id="putbestsellers" class="layouts">
<cfoutput>#Application.BestSellers#</cfoutput>		
</div>
<!-- end layouts/put_bestsellers.cfm -->
</cfoutput>		
		
		
<!--- Alternative version if your best sellers change and need to be reloaded on different pages of the site 
<cfscript>
	BestSellers = Application.objMenus.dspBestSellers();
	Writeoutput(HTMLCompressFormat(BestSellers));
</cfscript>
--->