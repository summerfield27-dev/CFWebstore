
<!--- CFWebstore, version 6.50 --->

<!--- Used to create the form key and add the hidden field, used to check for cross-site request forgeries --->

<cfparam name="keyname" default="csrfkey">

<cfset formkey = CreateUUID()>
<cfset session.formKeys[keyname] = formkey>
<cfoutput>
	<input type="hidden" name="formkey" value="#Hash(formkey,"SHA-256")#"/>
</cfoutput>
