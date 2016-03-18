<!--- CFWebstore, version 6.50 --->

<!--- Shift4 $$$ ON THE NET preprocessing step to merge multiple FORM variables into the existing CCProcess structure. Called from act_process.cfm --->

<cfinclude template="../../../checkout/creditcards/shift4/qry_get_Shift4OTN_Settings.cfm">

<cfparam name="attributes.ProxyServer" default="">
<cfparam name="attributes.ProxyPort" default="">
<cfparam name="attributes.ProxyUsername" default="">
<cfparam name="attributes.ProxyPassword" default="">
<cfparam name="attributes.UserCCardEdit" default="0">
<cfparam name="attributes.UserCCardDelete" default="0">
<cfparam name="attributes.UserCCardOnTheFlyUpdate" default="0">
<cfparam name="attributes.i4GoURL" default="">
<cfparam name="attributes.i4GoAccountID" default="">
<cfparam name="attributes.i4GoSiteID" default="">

<cfset attributes.Username="#Val(Trim(attributes.SerialNumber))#,#URLEncodedFormat(Trim(attributes.Username))#">
<cfif attributes.Password is "***same/same***">
	<cfset attributes.Password=get_Shift4OTN_Settings.Password>
</cfif>
<cfset attributes.Password=URLEncodedFormat(Encrypt(Trim(attributes.Password),Request.encrypt_key))>
<cfset attributes.ProxyPort=Val(attributes.ProxyPort)>
<cfif attributes.ProxyPort LTE 0>
	<cfset attributes.ProxyPort=80>
</cfif>
<cfif attributes.ProxyPassword is "***same/same***">
	<cfset attributes.ProxyPassword=get_Shift4OTN_Settings.ProxyPassword>
</cfif>
<cfset attributes.Setting1="#Val(Trim(attributes.MID))#,#Val(Trim(attributes.i4GoAccountID))#,#Val(Trim(attributes.i4GoSiteID))#,#Trim(attributes.i4GoURL)#">
<cfset attributes.Setting2="#URLEncodedFormat(Trim(attributes.ProxyServer)&' ')#,#Val(Trim(attributes.ProxyPort))#,#URLEncodedFormat(Trim(attributes.ProxyUsername)&' ')#,#URLEncodedFormat(Encrypt(Trim(attributes.ProxyPassword)&' ',Request.encrypt_key))#">
<cfset attributes.Setting3="#Val(attributes.UserCCardEdit)#,#Val(attributes.UserCCardDelete)#,#Val(attributes.UserCCardOnTheFlyUpdate)#">
