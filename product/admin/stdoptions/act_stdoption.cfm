
<!--- CFWebstore, version 6.50 --->

<!--- Performs actions on standard options: add, edit and delete. Asks for confirmation for deletions. Called by product.admin&stdoption=act --->

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<!--- if not full product admin, and is not adding an option, make sure they have access to this option --->
<cfif NOT ispermitted AND mode IS NOT "i">
	<cfmodule template="../../../access/useraccess.cfm" ID="#attributes.Std_ID#" type="stdoption">
	<cfset editoption = useraccess>
<cfelse>
	<cfset editoption = "yes">
</cfif>

<cfif editoption>

	<!--- CSRF Check --->
	<cfset keyname = "stdOptionEdit">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
	
	<!--- New code to make sure there is at least one selection in the option --->
	
	<cfif mode IS "u" AND attributes.submit is not "Delete" AND NOT len(attributes.ChoiceName1)>
		
		<cfinclude template="dsp_stdopt_error.cfm">
	
	<cfelse>
		
		<cfswitch expression="#mode#">
		
			<cfcase value="i">
				
				<cftransaction isolation="SERIALIZABLE">
				<cfquery name="InsertOption" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
				INSERT INTO #Request.DB_Prefix#StdOptions
				(Std_Name, Std_Prompt, Std_Desc, 
				Std_ShowPrice, Std_Display, Std_Required, User_ID)
				VALUES (	
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Name)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Prompt)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Desc)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Std_ShowPrice#">, 
					 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Std_Display#">,
					 <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Required#">, 
					 <cfif ispermitted>0
					 	<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#Session.User_ID#">
					</cfif> )
				 </cfquery>	
				 
				 <cfquery name="getID" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					SELECT Max(Std_ID) AS newid FROM #Request.DB_Prefix#StdOptions
				</cfquery>
				 </cftransaction>
				 
				 <cfset attributes.Std_ID = getID.newid>
					
			</cfcase>
				
			<cfcase value="u">
				<cfif attributes.submit is not "Delete">
					
					<cfquery name="UpdateOption" datasource="#Request.DS#" 
					username="#Request.DSuser#" password="#Request.DSpass#">
					UPDATE #Request.DB_Prefix#StdOptions
					SET 
					Std_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Name)#">, 
					Std_Prompt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Prompt)#">, 
					Std_Desc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.Std_Desc)#">,
					Std_ShowPrice = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.Std_ShowPrice#">, 
					Std_Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Std_Display#">,
					Std_Required = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Required#">
					WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
					</cfquery>
					
					</cfif><!--- not delete --->
				
				</cfcase>
		
			</cfswitch>
			
			<cfif attributes.submit is not "Delete">
			<!--- Update the option choices --->
				<cfloop index="i" from="1" to="#attributes.num#">
					<cfscript>
						//Process the form fields 
						ChoiceName = attributes['ChoiceName' & i];
						Price = attributes['Price' & i];
						Price = iif(isNumeric(Price), trim(Price), 0);
						
						Weight = attributes['Weight' & i];
						Weight = iif(isNumeric(Weight), trim(Weight), 0);
						
						SortOrder = attributes['SortOrder' & i];
						SortOrder = iif(isNumeric(SortOrder), trim(SortOrder), 0);
						
						Display = iif(StructKeyExists(attributes,'Std_Display' & i),1,0);
						Delete = iif(StructKeyExists(attributes,'Delete' & i),1,0);
					
						Choice_ID = iif(StructKeyExists(attributes,'Choice_ID' & i),"attributes['Choice_ID' & i]",0);

					</cfscript>
					
				<!--- Run delete functions if update --->
				<cfif mode IS "u" AND Delete>
				<!--- remove this standard option choice from the product choice lists --->
					<cfquery name="DeleteProdChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
						DELETE FROM #Request.DB_Prefix#ProdOpt_Choices						
						WHERE Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Choice_ID#">
						AND Option_ID IN (SELECT Option_ID FROM #Request.DB_Prefix#Product_Options PO
										WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">)
					</cfquery>
					
				<!--- remove this standard option choice --->
					<cfquery name="DeleteOptChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
						DELETE FROM #Request.DB_Prefix#StdOpt_Choices
						WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
						AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Choice_ID#">
					</cfquery>
					
				<!--- If delete not checked, and there is a choice ID, run update --->
				<cfelseif NOT Delete AND Choice_ID IS NOT 0>
					<cfquery name="UpdOptChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
						UPDATE #Request.DB_Prefix#StdOpt_Choices
						SET ChoiceName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(ChoiceName)#">,
						Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Price#">,
						Weight = <cfqueryparam cfsqltype="cf_sql_double" value="#Weight#">,
						SortOrder = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(SortOrder IS NOT 0, SortOrder, 9999)#">,
						Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#">
						WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
						AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Choice_ID#">
					</cfquery>
					
				<!--- Otherwise, run insert --->
				<cfelseif NOT Delete AND len(Trim(ChoiceName))>
					<cftransaction isolation="SERIALIZABLE">
					<!--- If update, get new ID --->
					<cfif mode IS "u">
						<cfquery name="getNewID" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
						SELECT MAX(Choice_ID) + 1 AS newid FROM #Request.DB_Prefix#StdOpt_Choices
						WHERE Std_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">
						</cfquery>
						<cfset newID = iif(len(getNewID.newid),getNewID.newid,1)>
					<cfelse>
						<cfset newID = i>
					</cfif>
					
					<cfquery name="UpdOptChoice" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
						INSERT INTO #Request.DB_Prefix#StdOpt_Choices
						(Std_ID, Choice_ID, ChoiceName, Price, Weight, SortOrder, Display)
						VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Std_ID#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#newID#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(ChoiceName)#">,
						<cfqueryparam cfsqltype="cf_sql_double" value="#Price#">,
						<cfqueryparam cfsqltype="cf_sql_double" value="#Weight#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#iif(SortOrder IS NOT 0, SortOrder, 9999)#">,
						<cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#"> )
					</cfquery>
				</cftransaction>
				</cfif>
				
				</cfloop>
				
			</cfif>
			
		
			
			<cfinclude template="dsp_stdoption_confirm.cfm">							
					
	</cfif>
	
<!--- user did not have access --->
<cfelse>
	<cfset attributes.message = "You do not have access to edit this standard option.">
	<cfset attributes.XFA_success = "fuseaction=product.admin&stdoption=list">
	<cfinclude template="../../../includes/admin_confirmation.cfm">

</cfif>
