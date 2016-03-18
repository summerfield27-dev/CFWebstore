
<!--- CFWebstore, version 6.50 --->

<!--- Updates the product pricing information. Called by product.admin&do=act_price --->

<!---====== Prepare form variables =====--->
<cfparam name="attributes.cid" default="">

<!--- These fields may not be passed (they depend on product type) --->
<cfloop list="content_url,Access_Keys,Access_Count,Num_Days,Recur,Recur_Product_ID,TaxCodes,Shipping,Giftwrap,weight,freight_dom,freight_intl,pack_length,pack_width,pack_height" index="counter">
	<cfparam name="attributes.#counter#" default="">
</cfloop>

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<!--- if not full product admin, make sure they have access to this product --->
<cfif NOT ispermitted>
	<cfmodule template="../../../access/useraccess.cfm" ID="#attributes.Product_ID#">
	<cfset editproduct = useraccess>
<cfelse>
	<cfset editproduct = "yes">
</cfif>

<cfif editproduct>

	<!--- CSRF Check --->
	<cfset keyname = "prodPriceForm">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
	
	
	<!--- Prep Numbers --->
	<cfset Min_Order = iif(isNumeric(attributes.Min_Order), trim(attributes.Min_Order), 0)>
	<cfset Base_Price = iif(isNumeric(attributes.Base_Price), trim(attributes.Base_Price), 0)>
	<cfset Retail_Price = iif(isNumeric(attributes.Retail_Price), trim(attributes.Retail_Price), 0)>
	<cfset Wholesale = iif(isNumeric(attributes.Wholesale), trim(attributes.Wholesale), 0)>
	<cfset dropship_cost = iif(isNumeric(attributes.dropship_cost), trim(attributes.dropship_cost), 0)>
	<cfset Weight = iif(isNumeric(attributes.Weight), trim(attributes.Weight), 0)>
	<cfset Shipping = iif(isNumeric(attributes.Shipping), trim(attributes.Shipping), 0)>
	<cfset Giftwrap = iif(isNumeric(attributes.Giftwrap), trim(attributes.Giftwrap), 0)>
	<cfset NuminStock = iif(isNumeric(attributes.NuminStock), trim(attributes.NuminStock), 0)>
	<cfset reorder_level = iif(isNumeric(attributes.reorder_level), trim(attributes.reorder_level), 0)>
	<cfset access_count = iif(isNumeric(attributes.access_count), trim(attributes.access_count), 0)>
	<cfset num_days = iif(isNumeric(attributes.num_days), trim(attributes.num_days), 0)>
	<cfset Freight_Dom = iif(isNumeric(attributes.Freight_Dom), trim(attributes.Freight_Dom), 0)>
	<cfset Freight_Intl = iif(isNumeric(attributes.Freight_Intl), trim(attributes.Freight_Intl), 0)>
	<cfset Pack_Length = iif(isNumeric(attributes.Pack_Length), trim(attributes.Pack_Length), 0)>
	<cfset Pack_Width = iif(isNumeric(attributes.Pack_Width), trim(attributes.Pack_Width), 0)>
	<cfset Pack_Height = iif(isNumeric(attributes.Pack_Height), trim(attributes.Pack_Height), 0)>
	
	<!--- Make changes to discounts --->
	<cfinclude template="discounts/act_update_discounts.cfm">
	
	<cfquery name="UpdateProduct" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Products
		SET
		NotSold = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.NotSold#">,
		Sale_Start = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.sale_start#" null="#YesNoFormat(NOT isDate(attributes.sale_start))#">,
		Sale_End = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.sale_end#" null="#YesNoFormat(NOT isDate(attributes.sale_end))#">,
		SKU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.SKU)#">,
		Vendor_SKU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Vendor_SKU)#">,
		Availability = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.availability)#">,
		NumInStock = <cfqueryparam cfsqltype="cf_sql_integer" value="#NuminStock#">,
		Reorder_Level = <cfqueryparam cfsqltype="cf_sql_integer" value="#reorder_level#">,
		Min_Order = <cfqueryparam cfsqltype="cf_sql_integer" value="#Min_Order#">,
		Mult_Min = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Mult_Min#">,
		ShowOrderBox = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowOrderBox#">,
		VertOptions = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.VertOptions#">,
		ShowPrice = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowPrice#">,
		TaxCodes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TaxCodes#">,
		Base_Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Base_Price#">,
		Retail_Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Retail_Price#">,
		Wholesale = <cfqueryparam cfsqltype="cf_sql_double" value="#Wholesale#">,	
		Shipping = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Shipping#">,
		Freight_Dom = <cfqueryparam cfsqltype="cf_sql_double" value="#Freight_Dom#">,
        Freight_Intl = <cfqueryparam cfsqltype="cf_sql_double" value="#Freight_Intl#">,
		Pack_Length = <cfqueryparam cfsqltype="cf_sql_double" value="#Pack_Length#">,
		Pack_Width = <cfqueryparam cfsqltype="cf_sql_double" value="#Pack_Width#">,
		Pack_Height = <cfqueryparam cfsqltype="cf_sql_double" value="#Pack_Height#">,
		Weight = <cfqueryparam cfsqltype="cf_sql_double" value="#Weight#">,
		Giftwrap =  <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Giftwrap#">,
		ShowDiscounts = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowDiscounts#">,
		ShowPromotions = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.ShowPromotions#">,
		Discounts = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DiscountList#">,
		Account_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(attributes.Account_id), attributes.Account_id, 0)#">,
		Dropship_Cost = <cfqueryparam cfsqltype="cf_sql_double" value="#dropship_cost#">,
		Access_Keys = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Access_keys#">,
		Access_Count = <cfqueryparam cfsqltype="cf_sql_integer" value="#access_count#">,
		Recur = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#iif(len(attributes.Recur), attributes.Recur, 0)#">,
		Recur_Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(isNumeric(attributes.Recur_Product_ID), attributes.Recur_Product_ID, 0)#">,
		Num_Days = <cfqueryparam cfsqltype="cf_sql_integer" value="#num_days#">,
		Content_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.content_url#">
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
	</cfquery>

	
	<cfif NOT Compare(frm_submit, "Edit/Add Options")>
		
		<cflocation url="#self#?fuseaction=Product.admin&do=options&product_id=#attributes.product_id##Request.Token2#" addtoken="No">
	
	<cfelse>
		<cfset mode="u">	
		<cfinclude template="dsp_act_confirmation.cfm">
			
	</cfif>			
				
<!--- user did not have access --->
<cfelse>
	<cfset attributes.message = "You do not have access to edit this product.">
	<cfset attributes.XFA_success = "fuseaction=product.admin&do=list&cid=0">
	<cfinclude template="../../../includes/admin_confirmation.cfm">

</cfif>
