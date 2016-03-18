
<!--- CFWebstore, version 6.50 --->

<!--- Processes the second form page for standard options. Called by product.admin&option=act2 --->

<!--- CSRF Check --->
<cfset keyname = "editOption2">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.cid" default="">

<!--- Get option info --->
<cfquery name="qry_get_Option"   datasource="#Request.ds#"	 username="#Request.DSuser#"  password="#Request.DSpass#" >
SELECT PO.Display, SO.Std_Display
FROM #Request.DB_Prefix#Product_Options PO 
INNER JOIN #Request.DB_Prefix#StdOptions SO ON PO.Std_ID = SO.Std_ID
WHERE PO.Option_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Option_ID#">
</cfquery>

<!--- Check if this option used for inventory tracking --->
<cfset TotalStock = 0>

<cfloop index="i" from="1" to="#attributes.num#">
	<cfscript>
		//Check if SKUs entered and allowed for this option
		if (NOT isDefined("attributes.OtherSKUs"))
			SKU = attributes['SKU' & i];
		else 
			SKU = '';
		
		//process number in stock, add to running total
		InStock = attributes['NumInStock' & i];
		NumInStock = iif(isNumeric(InStock), trim(InStock), 0);
		TotalStock = TotalStock + NumInStock;
		
		Display = iif(StructKeyExists(attributes,'Display' & i),1,0);
				
		Choice_ID = iif(StructKeyExists(attributes,'Choice_ID' & i),"attributes['Choice_ID' & i]",0);

	</cfscript>
	
	<!--- Check if there is any information entered for this option choice --->
	<cfif len(SKU) OR isNumeric(InStock) OR Display IS 0>
	
		<!--- Check if there is a record for this option choice --->
		<cfquery name="CheckChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Choice_ID FROM #Request.DB_Prefix#ProdOpt_Choices
		WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.option_ID#">
		AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Choice_ID#">
		</cfquery>
		
		<cfif CheckChoice.RecordCount>
			<cfquery name="UpdOptChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#ProdOpt_Choices
				SET SKU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(SKU)#">,
				NumInStock = <cfqueryparam cfsqltype="cf_sql_integer" value="#NumInStock#">,
				Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#">
				WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.option_ID#">
				AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Choice_ID#">
			</cfquery>
		
		<cfelse>
			<cfquery name="UpdOptChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#ProdOpt_Choices
				(Option_ID, Choice_ID, SKU, NumInStock, Display)
				VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.option_id#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Choice_ID#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(SKU)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#NumInStock#">,
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#"> )
			</cfquery>
		
		</cfif>
		
	<cfelse>
		<cfquery name="UpdOptChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		DELETE FROM #Request.DB_Prefix#ProdOpt_Choices
		WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.option_id#">
		AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Choice_ID#">
		</cfquery>
	
	</cfif>
	
</cfloop>
	
<!--- Check if inventory was entered or required. If yes, update the product option and product --->
<cfif (TotalStock IS NOT 0 AND NOT isDefined("attributes.OtherInv")) OR isDefined("attributes.TrackInv")>
	<cfquery name="UpdateOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Product_Options
		SET TrackInv = 1,
		Required = 1
		WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Option_ID#">
	</cfquery>
	
	<cfquery name="UpdateProduct" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Products
	SET OptQuant = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.option_ID#">, 
	NuminStock =<cfqueryparam cfsqltype="cf_sql_integer" value=" #TotalStock#">
	WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
	</cfquery>
	
<cfelse>
	<!--- Check if this option was using quantities previously --->
	<cfquery name="UpdateProduct" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#Products
	SET OptQuant = 0
	WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
	AND OptQuant = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.option_ID#">
	</cfquery>	
	
	<cfquery name="UpdateOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Product_Options
		SET TrackInv = 0
		WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Option_ID#">
	</cfquery>	

</cfif>
	
<cfset attributes.message = "Option Updated">
<cfset attributes.XFA_success = "fuseaction=product.admin&do=options&product_id=#attributes.product_id#">
<cfif attributes.cid is not "">
	<cfset attributes.XFA_success=attributes.XFA_success&"&cid=#attributes.cid#">
</cfif>
<cfinclude template="../../../../includes/admin_confirmation.cfm">



