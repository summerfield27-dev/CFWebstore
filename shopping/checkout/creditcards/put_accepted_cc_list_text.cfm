
<!--- CFWebstore, version 6.50 --->

<!--- Displays a list of the credit cards allowed. Not currently in use --->

<!--- Get list of credit cards --->
<cfquery name="GetCards" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
SELECT CardName FROM #Request.DB_Prefix#CreditCards
WHERE Used = 1
</cfquery>

<!--- Make comma-separated list of card names --->
<cfset CardList = ValueList(GetCards.CardName)>
<!--- Determine number of cards --->
<cfset Num = GetCards.RecordCount>
<!--- Get Last card name --->
<cfset LastCard = ListGetAt(CardList, Num)>
<!--- Get second to last card name --->
<cfset SecLastCard = ListGetAt(CardList, Num-1)>
<!--- Remove last card name from list --->
<cfset CardList = ListDeleteAt(CardList, Num)>
<!--- Set last item in list to last two card names separated by "and" --->
<cfset CardList = ListSetAt(CardList, Num-1, SecLastCard & " and " & LastCard)>
<!--- Replace commas with commas and spaces --->
<cfset CardList = Replace(CardList, ",", ", ", "ALL")>

<!--- Output result --->
<cfoutput>#CardList#</cfoutput>


