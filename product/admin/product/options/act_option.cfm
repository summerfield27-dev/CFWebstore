
<!--- CFWebstore, version 6.50 --->

<!--- Performs the functions for a product option: add, edit, delete. Called by product.admin&option=act|delete --->

<!--- CSRF Check --->
<cfset keyname = "editOption">
<cfinclude template="../../../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.cid" default="">
<cfparam name="attributes.std_id" default="0">
<cfset attributes.message = "Option ">

<!--- New code to make sure there is at least one selection in the option --->

<cfif mode IS NOT "d" AND NOT attributes.Std_ID AND NOT len(attributes.ChoiceName1)>
	
	<cfinclude template="dsp_option_error.cfm">

<cfelse>

	<cfswitch expression="#mode#">
		<cfcase value="i">
			<cfset attributes.message = attributes.message & "added.">
			
			<cfif NOT isNumeric(attributes.Priority) OR attributes.Priority IS 0>
				<cfset attributes.Priority = 9999>
			</cfif>
	
			<cfif attributes.Std_ID>
	
				<cftransaction isolation="SERIALIZABLE">					
					<cfquery name="InsertOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					INSERT INTO #Request.DB_Prefix#Product_Options
						(Product_ID, Std_ID, Prompt, OptDesc, ShowPrice, Display, Priority, TrackInv, Required)
					VALUES
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">, 
						NULL, NULL, NULL, 
						<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Opt_Display#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">, 
						0, 1 )
					</cfquery>	
					
					<cfquery name="getNewID" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
						SELECT MAX(Option_ID) AS newid 
						FROM #Request.DB_Prefix#Product_Options
					</cfquery>
				
					<cfset attributes.option_id = getNewID.newid>

				</cftransaction>
		
			<cfelse><!---- custom option ---->			
					
				<cftransaction isolation="SERIALIZABLE">
					
					<cfquery name="InsertOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					INSERT INTO #Request.DB_Prefix#Product_Options
						(Product_ID, Std_ID, Prompt, OptDesc, ShowPrice, Display, Priority, TrackInv, Required)
					VALUES
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Prompt)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.OptDesc)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ShowPrice#">, 
						<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Opt_Display#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">,
						<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="0">,
						<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Required#"> )
					</cfquery>	
				
					<cfquery name="getNewID" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
						SELECT MAX(Option_ID) AS newid 
						FROM #Request.DB_Prefix#Product_Options
					</cfquery>
				
					<cfset attributes.option_id = getNewID.newid>
					
				</cftransaction>
				
			</cfif><!---- custom option ---->
			
		</cfcase>		
				
				
		<cfcase value="u">
			
			<cfset attributes.message = attributes.message & "updated.">
			
			<cfif NOT isNumeric(attributes.Priority) OR attributes.Priority IS 0>
				<cfset attributes.Priority = 9999>
			</cfif>
			
			<cfif attributes.Std_ID>
				
				<cfquery name="UpdateOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Product_Options
				SET Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Opt_Display#">,
				Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">
				WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Option_ID#">
				</cfquery>	
									
			<cfelse><!---- custom option ---->
			
				<cfquery name="UpdateOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Product_Options
				SET Prompt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Prompt)#">,
				OptDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.OptDesc)#">,
				ShowPrice = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ShowPrice#">,
				Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Opt_Display#">, 
				Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Priority#">,
				Required = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Required#">
				WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Option_ID#">
				</cfquery>
				
			</cfif><!---- custom option check---->
			
		</cfcase>		
		
		<cfcase value="d">
	
			<cfset attributes.message = attributes.message & "deleted.">
			
			<!--- Delete option and option choices --->
			<cftransaction isolation="SERIALIZABLE">
				<cfquery name="DeleteOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					DELETE FROM #Request.DB_Prefix#ProdOpt_Choices
					WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Option_ID#">
				</cfquery>
			
				<cfquery name="DeleteOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					DELETE FROM #Request.DB_Prefix#Product_Options
					WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Option_ID#">
				</cfquery>
				
				<!--- Check if this option was using quantities previously --->
				<cfquery name="UpdateProduct" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#Products
				SET OptQuant = 0
				WHERE Product_ID =	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Product_ID#">
				AND OptQuant = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Option_ID#">
			
				</cfquery>
			
			</cftransaction>
				
		</cfcase>	
	
	</cfswitch>	
	
	<!--- If not a delete or standard option, run the option choices functions --->
	<cfif mode IS NOT "d" AND NOT attributes.Std_ID>
		
		<!--- Check if this option used for inventory tracking --->
		<cfset TotalStock = 0>
	
		<cfloop index="i" from="1" to="#attributes.num#">
			<cfscript>
				//Process the form fields 
				ChoiceName = attributes['ChoiceName' & i];
				Price = attributes['Price' & i];
				Price = iif(isNumeric(Price), trim(Price), 0);
				
				Weight = attributes['Weight' & i];
				Weight = iif(isNumeric(Weight), trim(Weight), 0);
				
				SortOrder = attributes['SortOrder' & i];
				if (NOT isNumeric(SortOrder) OR SortOrder IS 0)
					SortOrder = 9999;
				
				//Check if SKUs entered and allowed for this option
				if (NOT isDefined("attributes.OtherSKUs"))
					SKU = attributes['SKU' & i];
				else
					SKU = '';
				
				NumInStock = attributes['NumInStock' & i];
				NumInStock = iif(isNumeric(NumInStock), trim(NumInStock), 0);
				
				Display = iif(StructKeyExists(attributes,'Opt_Display' & i),1,0);
				Delete = iif(StructKeyExists(attributes,'Delete' & i),1,0);
				
				Choice_ID = iif(StructKeyExists(attributes,'Choice_ID' & i),"attributes['Choice_ID' & i]",0);

			</cfscript>
			
		<!--- Run delete functions if update and not standard option --->
		<cfif mode IS "u" AND (Delete OR NOT len(Trim(ChoiceName)))>
		<!--- remove this option choice from the product choice lists --->
			<cfquery name="DeleteProdChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				DELETE FROM #Request.DB_Prefix#ProdOpt_Choices
				WHERE Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Choice_ID#">
				AND Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.option_ID#">
			</cfquery>
			
		<!--- If delete not checked, and there is a choice ID, run update --->
		<cfelseif NOT Delete AND Choice_ID IS NOT 0>
			<cfquery name="UpdOptChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				UPDATE #Request.DB_Prefix#ProdOpt_Choices
				SET ChoiceName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(ChoiceName)#">,
				Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Price#">,
				Weight = <cfqueryparam cfsqltype="cf_sql_double" value="#Weight#">,
				SKU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(SKU)#">,
				NumInStock = <cfqueryparam cfsqltype="cf_sql_integer" value="#NumInStock#">,
				SortOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#SortOrder#">,
				Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#">
				WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.option_ID#">
				AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Choice_ID#">
			</cfquery>
			
			<cfset TotalStock = TotalStock + NumInStock>
			
		<!--- Otherwise, run insert --->
		<cfelseif NOT Delete AND len(Trim(ChoiceName))>
			<cftransaction isolation="SERIALIZABLE">
			<!--- If update, get new ID --->
			<cfif mode IS "u">
				<cfquery name="getNewID" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				SELECT MAX(Choice_ID) + 1 AS newid 
				FROM #Request.DB_Prefix#ProdOpt_Choices
				WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Option_ID#">
				</cfquery>
				<cfset newID = iif(len(getNewID.newid),getNewID.newid,1)>
			<cfelse>
				<cfset newID = i>
			</cfif>
			
			<cfquery name="InsOptChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#ProdOpt_Choices
				(Option_ID, Choice_ID, ChoiceName, Price, Weight, SKU, NumInStock, SortOrder, Display)
				VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.option_id#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#newID#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(ChoiceName)#">, 
				<cfqueryparam cfsqltype="cf_sql_double" value="#Price#">, 
				<cfqueryparam cfsqltype="cf_sql_double" value="#Weight#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(SKU)#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#NumInStock#">, 				
				<cfqueryparam cfsqltype="cf_sql_integer" value="#SortOrder#">, 
				<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#"> )
			</cfquery>
	
			<cfset TotalStock = TotalStock + NumInStock>
			
			</cftransaction>
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
			NuminStock = <cfqueryparam cfsqltype="cf_sql_integer" value="#TotalStock#">
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
	
	</cfif>
		
		
	
	<!---- If this is a standard ID, proceed to Options form ---->	
	<cfif attributes.Std_ID>
	
		<cflocation url="#self#?fuseaction=product.admin&option=std2&option_id=#attributes.option_id#&product_id=#attributes.product_id#&cid=#attributes.cid##Request.Token2#" addtoken="No">
	
	</cfif>	
		
	
	<cfset attributes.XFA_success = "fuseaction=product.admin&do=options&product_id=#attributes.product_id#">
	<cfif attributes.cid is not "">
		<cfset attributes.XFA_success=attributes.XFA_success&"&cid=#attributes.cid#">
	</cfif>
	<cfinclude template="../../../../includes/admin_confirmation.cfm">
	
</cfif>