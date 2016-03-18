
<!--- CFWebstore, version 6.50 --->

<!--- This template is used to continue the PayPal Website Payments Express Checkout process. It uses the token to retrieve the shipping information for the order and continues the user through the checkout process. Called from checkout/do_checkout.cfm --->

<!--- Retrive PayPal Express Checkout settings --->
<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
	SELECT CCServer, Password, Setting1, Transtype, Username 
	FROM #Request.DB_Prefix#CCProcess
	<cfif get_Order_Settings.CCProcess IS NOT "PayPalPro">
		WHERE Setting3 = 'PayPalExpress'
	<cfelse>
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	</cfif>
</cfquery>

<cfparam name="attributes.token" default="">


<cfif get_Order_Settings.PayPalServer IS "live">
	<cfset PPServer = "https://api-3t.paypal.com/2.0/" >
<cfelse>
	<cfset PPServer = "https://api-3t.sandbox.paypal.com/2.0/" >
</cfif>	


<CF_PPExpressCheckoutDetails
		STRUCTNAME="Results"
		USERNAME="#GetSettings.Username#"
	    PASSWORD="#GetSettings.Password#"
		SERVER="#PPServer#"
		SIGNATURE="#GetSettings.Setting1#"
		TOKEN="#attributes.token#">
			  
			  
<!--- DEBUG 
<cfoutput><h1>#Results.response_code#</h1></cfoutput> 
----->

<cfif Results.Success IS NOT "1">
	<cfset Message = Results.errormessage>    
	<cfset attributes.step = "address">

<cfelse>
	<!--- <cfdump var="#Results#"> --->

	<cfscript>
	//Move the address information into the attributes variables and save the Express Checkout token to a session variable
	Session.PP_Token = attributes.token;
	Session.PayerID = results.CustInfo.ID;
	
	//Set billing address information 
	attributes.FirstName = results.CustInfo.FirstName;
	attributes.LastName = results.CustInfo.LastName;
	attributes.Company = 'PayPal Account';
	attributes.Address1 = 'Hidden';
	attributes.Address2 = '';
	attributes.City = 'Hidden';
	attributes.State = 'XX';
	attributes.State2 = '';
	attributes.County = '';
	attributes.Zip = '00000';
	attributes.Country = 'US^United States';
	attributes.Phone = 'xxx-xxx-xxxx';
	attributes.email = results.CustInfo.Email;
	attributes.residence = 1;
	
	//Set shipping address information
	attributes.ShipToYes = 0;
	ShipName = results.CustInfo.Address.Name.XMLText;
	NameLen = ListLen(ShipName, " ");
	attributes.FirstName_shipto = ListDeleteAt(ShipName, NameLen, " ");
	attributes.LastName_shipto = ListLast(ShipName, " ");
	attributes.Company_shipto = results.CustInfo.Company;
	attributes.Address1_shipto = results.CustInfo.Address.Street1.XMLText;
	if (isDefined("results.CustInfo.Address.Street2")) 
		attributes.Address2_shipto = results.CustInfo.Address.Street2.XMLText;
	else
		attributes.Address2_shipto = '';
	attributes.City_shipto = results.CustInfo.Address.CityName.XMLText;
	attributes.County_shipto = '';
	attributes.State_shipto = results.CustInfo.Address.StateorProvince.XMLText;
	attributes.State2_shipto = '';
	attributes.Zip_shipto = results.CustInfo.Address.PostalCode.XMLText;
	attributes.Country_shipto = '#results.CustInfo.Address.Country.XMLText#^#results.CustInfo.Address.CountryName.XMLText#';
	attributes.Phone_shipto = results.CustInfo.Phone;
	attributes.residence_shipto = 1;

	attributes.step = "address";		
	attributes.SubmitAddress = 'Continue';	
	</cfscript>		
	
</cfif>


