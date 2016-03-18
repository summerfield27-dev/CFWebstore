<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Called from the various product listings to create the product link strings.  --->

<cfparam name="morelink" default="yes">

<cfparam name="Product_ID" default="#qry_get_products.Product_ID#">

<cfscript>

	// Set Parent ID text strings
	if (isDefined("attributes.ParentCat") and isNumeric(attributes.ParentCat) AND attributes.ParentCat IS NOT 0) {
		PCatSES = "_#attributes.ParentCat#";
		PCatNoSES = "&ParentCat=#attributes.ParentCat#";
	}
	else {
		PCatSES = "";
		PCatNoSES = "";
	}

	if (Request.AppSettings.UseSES AND morelink)
		prodlink = "#Request.SESindex#product/#product_ID##PCatSES#/#SESFile(qry_get_products.Name)##Request.Token1#";
	else if (morelink) 
		prodlink = "#self#?fuseaction=product.display&product_ID=#product_ID##PCatNoSES##Request.Token2#";
	else
		prodlink = "";
</cfscript>		

</cfsilent>

