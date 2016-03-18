
<cfparam name="Form.Page" default="0">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>CFWebstore Version Updater</title>
</head>

<body>
This page has been created to update the current data in your store to the new CFWebstore version 6.<br>
<br>

<cfif ListFind("1,2,3,4,5,6", Form.Page)>

<cfoutput>
NOW RUNNING PART #Form.Page# OF THE MIGRATION<br><br>
</cfoutput>

<cfswitch expression="#Form.Page#">

	<cfcase value="1">
		Updating your store settings, adding new pages, setting up new tax and shipping tables<br><br>
	</cfcase>

	<cfcase value="2">
		Hashing the user passwords, encrypting credit card numbers, and migrating product options to new tables<br><br>
	</cfcase>
	
	<cfcase value="3">
		Migrating the product/category discounts to new tables<br><br>
	</cfcase>

	<cfcase value="4">
		Updating the group/user permissions with new settings<br><br>
	</cfcase>
	
	<cfcase value="5">
		Completing the database changes, dropping unusued fields and tables<br><br>
	</cfcase>

</cfswitch>

<cfflush>

<cfinclude template="migrations#Form.Page#.cfm">

	Changes complete<br>
	<br>
	<cfif ListFind("1,2,3,4", Form.Page)>
		<form action="migration.cfm" method="post">
		<cfoutput>
		<input type="Hidden" name="Page" value="#(Form.Page+1)#">
		</cfoutput>
		<input type="submit" value="Continue">
		</form>	
		
	<cfelseif Form.Page IS 5>
		<form action="migration.cfm" method="post">
		<cfoutput>
		<input type="Hidden" name="Page" value="6">
		</cfoutput>
		This final step will remove any credit card data saved in the database, unless you are using Shift4 (and the data saved is tokens). Removing stored credit card data is required under current PCI Compliance regulations, please contact Dogpatch Software if you do not understand these rules and need further information. <br/><br/>
		<input type="submit" value="Continue">
		</form>	
		
	<cfelse>
		ColdFusion updates complete! You are now ready to set up your new version 6 store.<br><br>
	</cfif>
	
	
<cfelse>
	Invalid migration page requested.
</cfif>
	
</body>
</html>
