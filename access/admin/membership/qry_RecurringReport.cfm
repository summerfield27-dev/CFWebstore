<!--- CFWebstore, version 6.50 --->

<!---  This page is called by access.admin&membership=RecurringReport and retrieves list of memberships that will recur sorted by date.--->

<cfquery name="Get_Memberships"  datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
		SELECT M.*, U.UserName, U.Email, U.CardisValid, U.CardExpire, U.Disable, P.Name AS ProductName, P.Base_Price AS Price, RP.Name AS RecurProductName, RP.Base_Price AS RecurPrice
		FROM ((#Request.DB_Prefix#Memberships M 
				INNER JOIN #Request.DB_Prefix#Users U ON M.User_ID = U.User_ID) 
				LEFT JOIN #Request.DB_Prefix#Products P ON M.Product_ID = P.Product_ID)
				LEFT JOIN #Request.DB_Prefix#Products RP ON M.Recur_Product_ID = RP.Product_ID
		WHERE  M.Recur = 1
		ORDER BY M.Expire ASC, P.Name
</cfquery>


