
<!--- CFWebstore, version 6.50 --->

<!--- Performs the updates from the List Edit Form for products. Called by product.admin&do=actform --->

<!--- CSRF Check --->
<cfset keyname = "prodListEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Create the string with the filter parameters --->	
<cfset addedpath="fuseaction=product.admin&do=list">
<cfset fieldlist="name,sku,display,highlight,notsold,sale,hot,type,account_id,cid,nocat">
<cfinclude template="../../../includes/act_setpathvars.cfm">
	
<!--- Initialize setting to see if Option Quantities correct --->
<cfset CheckOpts = 0>

<!--- Check user's access level --->
<cfmodule template="../../../access/secure.cfm"	keyname="product" requiredPermission="1">

<cfloop index="Product_ID" list="#attributes.ProductList#">
	
	<!--- For each product, verify that the user has permissions for this product --->
	<cfif NOT ispermitted>
		<cfmodule template="../../../access/useraccess.cfm" ID="#Product_ID#">
		<cfset editproduct = useraccess>
	<cfelse>
		<cfset editproduct = "yes">
	</cfif>
	
	<cfif NOT editproduct>
		<cfset attributes.message = "Some products were skipped due to invalid permissions.">
	</cfif>
	
	
	<cfif editproduct>
		<cfset Base_price = attributes['Base_Price' & Product_ID]>
		<cfset Retail_price = attributes['Retail_price' & Product_ID]>
		<cfset Wholesale = attributes['Wholesale' & Product_ID]>
		<cfset NumInStock = attributes['NumInStock' & Product_ID]>
		<cfset OptQuant = attributes['OptQuant' & Product_ID]>
		<cfset Priority = attributes['Priority' & Product_ID]>
		<cfset POTD = iif(StructKeyExists(attributes,'POTD' & Product_ID),1,0)>
		<cfset Display = iif(StructKeyExists(attributes,'Display' & Product_ID),1,0)>
		<cfset Highlight = iif(StructKeyExists(attributes,'Highlight' & Product_ID),1,0)>
		<cfset Sale = iif(StructKeyExists(attributes,'Sale' & Product_ID),1,0)>
		<cfset Hot = iif(StructKeyExists(attributes,'Hot' & Product_ID),1,0)>
		
		
		<cfset Base_Price = iif(isNumeric(Base_Price), trim(Base_Price), 0)>
		<cfset Retail_price = iif(isNumeric(Retail_price), trim(Retail_price), 0)>
		<cfset Wholesale = iif(isNumeric(Wholesale), trim(Wholesale), 0)>
		<cfset NuminStock = iif(isNumeric(NuminStock), trim(NuminStock), 0)>
		
		
		<cfif NOT isNumeric(Priority) OR Priority IS 0>
			<cfset Priority = 9999>
		</cfif>
		
		
		<cfquery name="UpdateProduct" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		UPDATE #Request.DB_Prefix#Products
			SET Base_Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Base_price#">,
			Retail_Price = <cfqueryparam cfsqltype="cf_sql_double" value="#Retail_price#">,
			Wholesale = <cfqueryparam cfsqltype="cf_sql_double" value="#Wholesale#">,
			NumInStock = <cfqueryparam cfsqltype="cf_sql_integer" value="#NumInStock#">,
			Priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#Priority#">,
			UseforPOTD =  <cfqueryparam cfsqltype="cf_sql_integer" value="#POTD#">,
			Display = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Display#">,
			Highlight = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Highlight#">,
			Sale = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Sale#">,
			Hot = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#Hot#">
			WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Product_ID#">
		</cfquery>
		
		<cfif OptQuant IS NOT 0>
			
			<cfset OptQuants = attributes['OptQuants' & Product_ID]>
			<cfset ChoiceIDs = attributes['ChoiceIDs' & Product_ID]>
		
			<!--- Make sure the quantity list is the same as the choice ID list --->
			<cfif ListLen(OptQuants) IS NOT ListLen(ChoiceIDs)>
				<cfset CheckOpts = 1>
				
			<cfelse>
				<cfset TotalNum = 0>
				
				<!--- Update each option choice with the new stock amount --->
				<cfloop index="i" from="1" to="#ListLen(ChoiceIDs)#">
					<cfquery name="UpdateStock" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
						UPDATE #Request.DB_Prefix#ProdOpt_Choices
						SET NumInStock = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(OptQuants, i)#">
						WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#OptQuant#">
						AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(ChoiceIDs, i)#">
					</cfquery>
					
					<cfset TotalNum = TotalNum + ListGetAt(OptQuants, i)>
				</cfloop>
				
				<!--- Update the product total --->
				<cfquery name="UpdateProduct" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					UPDATE #Request.DB_Prefix#Products
						SET NumInStock = <cfqueryparam cfsqltype="cf_sql_integer" value="#TotalNum#">
						WHERE Product_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Product_ID#">
					</cfquery>
			
			</cfif>

		</cfif>
	
	</cfif>

</cfloop>



<!--- Update Confirmation ---->

<cfif CheckOpts>
<cfmodule template="../../../customtags/format_admin_form.cfm"
	box_title="Products"
	width="450"
	required_fields="0"
	>
		<tr><td align="center" class="formtitle">
		<br/>
	Some Option quantities were not entered correctly, and have not been updated. <br/>
	All other changes have been saved.<p>
	<cfoutput>
		<form action="#self#?#addedpath##request.token2#" method="post">	
	</cfoutput>
	<input class="formbutton" type="submit" value="Back to Product List"/>
	</form>	
	</td></tr>		
</cfmodule>
 
<cfelse>
	<cfset attributes.XFA_success= addedpath>
	<cfset attributes.box_title="Products">
	<cfinclude template="../../../includes/admin_confirmation.cfm">	

</cfif>