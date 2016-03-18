
<!--- CFWebstore, version 6.50 --->

<cfset Available = "Yes">
<cfset OptQuantAvail = "Yes">
<cfset OptChoiceAvail = "Yes">

<!--- Check if the product is still available --->
<cfif qry_Get_Basket.Display[Num] IS 0 OR qry_Get_Basket.NotSold[Num] IS NOT 0 OR 
	(isDate(qry_Get_Basket.Sale_Start[Num]) AND DateCompare(qry_Get_Basket.Sale_Start[Num], Now()) GT 0) 
	OR (isDate(qry_Get_Basket.Sale_End[Num]) AND DateCompare(qry_Get_Basket.Sale_End[Num], Now()) LT 0)>
	<cfset Available = "No">
</cfif>

<!--- Check if the product's current option for inventory matches the basket item --->
<cfif qry_Get_Basket.OptQuant[Num] IS NOT qry_Get_Basket.ProdOptQuant[Num]>
	<cfset OptQuantAvail = "No">
</cfif>

<!--- If this product is using option quantities, check that they exist in the database still. Called by dsp_basket.cfm --->
<cfif qry_Get_Basket.OptQuant[Num] AND OptQuantAvail>
	<cfquery name="CheckOptChoice" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT Choice_ID FROM #Request.DB_Prefix#ProdOpt_Choices PC
		WHERE Option_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qry_Get_Basket.OptQuant[Num]#">
		AND Choice_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qry_Get_Basket.OptChoice[Num]#">
	</cfquery>
	
	<cfif NOT CheckOptChoice.Recordcount>
		<cfset OptChoiceAvail = "No">
	</cfif>
</cfif>