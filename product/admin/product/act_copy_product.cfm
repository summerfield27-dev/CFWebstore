
<!--- CFWebstore, version 6.50 --->

<!--- Copies a product: Includes records in Products, Product_category, ProdCustom, Product_item, Prod_CustInfo, Product_Options, prodAddons --->

<!--- Product Gallery images are NOT copied --->

<!--- Called by product.admin&do=copy --->

<!--- CSRF Check --->
<cfset keyname = "productList">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">


<!--- Get the product to copy --->
<cfquery name="GetProduct" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT * FROM #Request.DB_Prefix#Products
	WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
	<!--- If not full product admin, filter by user to check for access --->
	<cfif not ispermitted>	
	AND User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#"> </cfif>
</cfquery>

<cfif GetProduct.RecordCount>

	<cftransaction isolation="SERIALIZABLE">
		<cfquery name="Add_Record" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Products
		(Name, Short_Desc, Long_Desc, Base_Price, Retail_Price, Wholesale, SKU, 
		Vendor_SKU, Weight, Discounts, Promotions, AccessKey, Shipping, TaxCodes, 
		Sm_Image, Lg_Image, Enlrg_Image, Sm_Title, Lg_Title, PassParam, Color_ID, 
		Priority, Display, NuminStock, ShowPrice, ShowDiscounts, ShowPromotions, 
		ShowOrderBox, Highlight, Sale, Hot, Reviewable, UseforPOTD, NotSold, 
		DateAdded, OptQuant, Reorder_Level, Sale_Start, Sale_End, 
		Account_ID, Dropship_Cost, Prod_Type, Mfg_Account_ID, 
		Content_URL, MimeType, Access_Count, Num_Days, Access_Keys, VertOptions, 
		Freight_Dom, Freight_Intl, Pack_Length, Pack_Width, Pack_Height,
		Metadescription, Keywords, TitleTag, Availability, 
		Recur, Recur_Product_ID, GiftWrap, User_ID)
		VALUES( <cfqueryparam cfsqltype="cf_sql_varchar" value="Copy of #Trim(GetProduct.Name)#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#GetProduct.Short_desc#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#GetProduct.Long_desc#">,
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.Base_price#">,
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.Retail_price#">,
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.Wholesale#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.SKU#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Vendor_SKU#">, 
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.Weight#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Discounts#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Promotions#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.Accesskey#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.Shipping#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.TaxCodes#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Sm_Image#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Lg_Image#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Enlrg_Image#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Sm_Title#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Lg_Title#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Passparam#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.Color_ID#" null="#YesNoFormat(NOT isNumeric(GetProduct.Color_ID))#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value=" #GetProduct.Priority#">,
		 0,
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.NuminStock#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.ShowPrice#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.ShowDiscounts#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.ShowPromotions#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.ShowOrderBox#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.Highlight#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.Sale#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.Hot#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.Reviewable#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.UseforPOTD#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.NotSold#">,
		 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		 0,
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.reorder_level#" null="#YesNoFormat(NOT len(GetProduct.reorder_level))#">,
		 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetProduct.Sale_start#" null="#YesNoFormat(NOT isDate(GetProduct.Sale_start))#">,
		 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetProduct.Sale_end#" null="#YesNoFormat(NOT isDate(GetProduct.Sale_end))#">,
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.Account_ID#" null="#YesNoFormat(NOT len(GetProduct.Account_ID))#">,
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.dropship_cost#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.prod_type#">, 
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.mfg_account_ID#" null="#YesNoFormat(NOT len(GetProduct.mfg_account_ID))#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Content_URL#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.MimeType#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.access_count#" null="#YesNoFormat(NOT len(GetProduct.access_count))#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.num_days#" null="#YesNoFormat(NOT len(GetProduct.num_days))#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Access_keys#">,
		<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.VertOptions#">,
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.Freight_Dom#">, 
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.Freight_Intl#">, 
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.Pack_Length#">, 
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.Pack_Width#">, 
		 <cfqueryparam cfsqltype="cf_sql_double" value="#GetProduct.Pack_Height#">,
	 	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Metadescription#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Keywords#">,
	 	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.TitleTag#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetProduct.Availability#">,
		 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.Recur#">,
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.Recur_Product_ID#" null="#YesNoFormat(NOT len(GetProduct.Recur_Product_ID))#">,
	  	<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetProduct.Giftwrap#">, 
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#GetProduct.User_ID#">
		 )
	 </cfquery>	
	 
	<cfquery name="Get_id" datasource="#Request.ds#" username="#Request.DSuser#"  password="#Request.DSpass#">
		SELECT MAX(Product_ID) AS maxid 
		FROM #Request.DB_Prefix#Products
	</cfquery>
	
	<cfset attributes.Product_id = get_id.maxid>
				
	</cftransaction>		
	
	
	<!--- Copy product categories --->
	<cfquery name="GetProductCats" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Category_ID 
		FROM #Request.DB_Prefix#Product_Category
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
	</cfquery>
	
	<cfloop query="GetProductCats">
		<cfquery name="AddProdCat" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Product_Category
		(Product_ID, Category_ID)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#category_ID#"> )
		</cfquery>
	</cfloop>
	
	<!--- Copy product discounts --->
	<cfquery name="GetProdDiscounts" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Discount_ID 
		FROM #Request.DB_Prefix#Discount_Products
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
	</cfquery>
	
	<cfloop query="GetProdDiscounts">
		<cfquery name="AddProdDiscount" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Discount_Products
		(Product_ID, Discount_ID)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GetProdDiscounts.Discount_ID#"> )
		</cfquery>
	</cfloop>
	
	<!--- Copy product promotions --->
	<cfquery name="GetProdPromotions" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Promotion_ID 
		FROM #Request.DB_Prefix#Promotion_Qual_Products
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
	</cfquery>
	
	<cfloop query="GetProdPromotions">
		<cfquery name="AddProdPromotion" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Promotion_Qual_Products
		(Product_ID, Promotion_ID)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GetProdPromotions.Promotion_ID#"> )
		</cfquery>
	</cfloop>
	
	<!--- Copy quantity discounts --->
	<cfquery name="GetProdDiscs" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#ProdDisc
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
	</cfquery>
	
	<cfloop query="GetProdDiscs">
		<cfquery name="AddProdDisc" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#ProdDisc
		(ProdDisc_ID, Product_ID, Wholesale, QuantFrom, QuantTo, DiscountPer)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#ProdDisc_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Wholesale#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#QuantFrom#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#QuantTo#">, 
			<cfqueryparam cfsqltype="cf_sql_double" value="#DiscountPer#"> )
		</cfquery>
	</cfloop>
		
	<!--- Copy product group pricing --->
	<cfquery name="GetGrpPrices" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#ProdGrpPrice
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
	</cfquery>
	
	<cfloop query="GetGrpPrices">
		<cfquery name="AddPrice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#ProdGrpPrice
		(GrpPrice_ID, Product_ID, Group_ID, Price)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GrpPrice_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Group_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_double" value="#Price#"> )
		</cfquery>
	</cfloop>
	
	<!--- Get the product's custom fields --->
	<cfquery name="GetCustom" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#Prod_CustInfo
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
	</cfquery>
	
	<cfloop query="GetCustom">
		<cfquery name="AddCustom" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Prod_CustInfo
		(Custom_ID, Product_ID, CustomInfo)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Custom_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CustomInfo#"> )
		</cfquery>
	</cfloop>
	
	<!--- Get the product's options --->
	<cfquery name="GetOptions" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#Product_Options
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
	</cfquery>
	
	<!--- Initialize OptQuant Number --->
	<cfset NewOptQ = 0>
	
	<cfloop query="GetOptions">
	
	<cftransaction isolation="SERIALIZABLE">
		<cfquery name="AddOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#Product_Options
		(Product_ID, Std_ID, Prompt, OptDesc, ShowPrice, 
		Display, Priority, TrackInv, Required)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GetOptions.Std_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetOptions.Prompt#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetOptions.OptDesc#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetOptions.ShowPrice#">, 
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetOptions.Display#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GetOptions.Priority#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetOptions.TrackInv#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetOptions.Required#"> 
		)
		</cfquery>
		
		<cfquery name="getNewID" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			SELECT MAX(Option_ID) AS newid 
			FROM #Request.DB_Prefix#Product_Options
		</cfquery>
				
		<cfset NewID = getNewID.newid>
			
		<!--- Check if this option is the one used for quantity --->
		<cfif GetOptions.Option_ID IS GetProduct.OptQuant>
			<cfquery name="AddOptQ" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
			UPDATE #Request.DB_Prefix#Products
			SET OptQuant = <cfqueryparam cfsqltype="cf_sql_integer" value="#NewID#"> 
			WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_ID#">
			</cfquery>
		</cfif>
		
		<!--- Get the product option choices and add them for the new product --->
		<cfquery name="GetChoices" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#ProdOpt_Choices
		WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetOptions.Option_ID#">
		</cfquery>
		
		<cfloop query="GetChoices">
			<cfquery name="InsOptChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#ProdOpt_Choices
				(Option_ID, Choice_ID, ChoiceName, Price, Weight, SKU, NumInStock, SortOrder, Display)
				VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#NewID#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GetChoices.Choice_ID#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetChoices.ChoiceName#">,
					<cfqueryparam cfsqltype="cf_sql_double" value="#GetChoices.Price#" null="#YesNoFormat(NOT len(GetChoices.Price))#">,
					<cfqueryparam cfsqltype="cf_sql_double" value="#GetChoices.Weight#" null="#YesNoFormat(NOT len(GetChoices.Weight))#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetChoices.SKU#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#NumInStock#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GetChoices.SortOrder#">, 
					<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#"> 
				)
			</cfquery>
		</cfloop>
	
	</cftransaction>
	
	</cfloop>
	<!--- end product options copy --->
	
	
	<!--- Get the product's addons --->
	<cfquery name="GetAddons" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT * FROM #Request.DB_Prefix#ProdAddons
		WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dup#">
	</cfquery>
	
	<cfloop query="GetAddons">
		<cfquery name="AddAddon" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		INSERT INTO #Request.DB_Prefix#ProdAddons
		(Product_ID, Standard_ID, Prompt, AddonDesc, AddonType, Display, Priority, Price, Weight, ProdMult, Required)
		VALUES (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GetAddons.Standard_ID#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAddons.Prompt#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAddons.AddonDesc#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetAddons.AddonType#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetAddons.Display#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GetAddons.Priority#">,
			<cfqueryparam cfsqltype="cf_sql_double" value="#GetAddons.Price#" null="#YesNoFormat(NOT len(GetAddons.Price))#">,
			<cfqueryparam cfsqltype="cf_sql_double" value="#GetAddons.Weight#" null="#YesNoFormat(NOT len(GetAddons.Weight))#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetAddons.ProdMult#" null="#YesNoFormat(NOT len(GetAddons.ProdMult))#">,
			<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#GetAddons.Required#" null="#YesNoFormat(NOT len(GetAddons.Required))#">
		)
		</cfquery>
	
	</cfloop>
	

</cfif>

