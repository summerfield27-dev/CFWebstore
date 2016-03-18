
<!--- CFWebstore, version 6.50 --->

<!--- 
Parameters:
Datasource = database to query
Password = password for database
username = username for database
 ---> 
 
<!--- Check if using a line --->
<cfif len(Request.GetColors.MainLineImage)>

	<!--- Check if creating a HTML line --->
	<cfif Request.GetColors.MainLineImage IS "HR">
			<cfset Request.MainLine = "HR">

	<!--- Otherwise, create link for image --->
	<cfelse>
		<cfset Request.MainLine = "#Request.GetColors.MainLineImage#"" border=""0">
	</cfif>

<cfelse>

	<cfset Request.MainLine = "">

</cfif>

<!---- MINOR LINE -------------------->
<cfif len(Request.GetColors.MinorLineImage)>

	<!--- Check if creating a HTML line --->
	<cfif Request.GetColors.MinorLineImage IS "HR">
		<cfset Request.MinorLine = "HR">

	<!--- Otherwise, create link for image --->
	<cfelse>
		<cfset Request.MinorLine = "#Request.GetColors.MinorLineImage#"" border=""0">
	</cfif>
	
<cfelse>
	<cfset Request.MinorLine = "">
</cfif>

<!---- SALE -------------------->
<cfif len(Request.GetColors.SaleImage)>

	<cfset Request.SaleImage = "<img src=""#Request.ImagePath##Request.GetColors.SaleImage#"" border=""0"" style=""vertical-align: middle"" alt=""On Sale!"" />">

<cfelse>
	<cfset Request.SaleImage = " ">
</cfif>

<!---- NEW -------------------->
<cfif len(Request.GetColors.NewImage)>

	<cfset Request.NewImage = "<img src=""#Request.ImagePath##Request.GetColors.NewImage#"" border=""0"" style=""vertical-align: middle"" alt=""New!"" />">
	
<cfelse>
	<cfset Request.NewImage = " ">
</cfif>


<!---- HOT -------------------->
<cfif len(Request.GetColors.HOTImage)>

	<cfset Request.HOTImage = "<img src=""#Request.ImagePath##Request.GetColors.HOTImage#"" border=""0"" style=""vertical-align: middle"" alt=""HOT!"" />">
	
<cfelse>
	<cfset Request.HOTImage = " ">
</cfif>



