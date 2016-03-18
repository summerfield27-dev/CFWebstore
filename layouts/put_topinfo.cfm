
<!--- CFWebstore, version 6.50 --->

<!--- Used to create the info for the top of the page. Call from your layout pages --->

 <!--- Change type to "Order" to show order-level discount instead --->
 
 <cfscript>
 	DiscountMess = Application.objDiscounts.dspDiscountMess(DiscType:'Store', class:'cat_text_list');
 	BasketSummary = Application.objCart.dspBasketStats();
	
	TopInfo = DiscountMess & BasketSummary;
 </cfscript>

<cfoutput>
	<!-- start layouts/put_topinfo.cfm -->
	<div id="puttopinfo" class="layouts">
	#HTMLCompressFormat(TopInfo)#
	</div>
	<!-- end layouts/put_topinfo.cfm -->
</cfoutput>			
			