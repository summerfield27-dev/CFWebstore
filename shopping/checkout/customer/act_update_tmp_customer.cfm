
<!--- CFWebstore, version 6.50 --->

<!--- Used to temporarily save the customer information entered in the address form. Called by shopping.checkout (step=address) --->

<cfparam name="attributes.shiptoyes" default ="0">
<cfparam name="attributes.phone2" default="">
<cfparam name="attributes.fax" default="">
<cfparam name="attributes.residence" default="1">

<cfif NOT len(attributes.state)>
	<cfset attributes.state = "Unlisted">
</cfif>

<cfset attributes.TableName = "TempCustomer">
<cfset Application.objUsers.UpdateCustomer(argumentcollection=attributes)>

		
