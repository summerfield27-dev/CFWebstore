<!--- CFWebstore, version 6.50 --->

<!--- Runs the CSRF checks for the product image upload forms --->

<cfif isdefined("Form.TheTableName")>
	
	<!--- CSRF Check --->
	<cfset keyname = "uploadImage">
	<cfinclude template="../../../includes/act_check_csrf_key.cfm">
	
</cfif>

<cfset formkey = CreateUUID()>
<cfset session.formKeys.uploadImage = formkey>
