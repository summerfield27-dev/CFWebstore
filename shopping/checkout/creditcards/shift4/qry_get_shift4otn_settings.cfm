<cfif not IsDefined("get_Shift4OTN_Settings")>
	<cfquery name="GetSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#" maxrows="1">
		SELECT CCServer, Transtype, Username, Password, Setting1, Setting2, Setting3 
		FROM #Request.DB_Prefix#CCProcess
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
	</cfquery>

	<cfscript>
		get_Shift4OTN_Settings								= StructNew();
		get_Shift4OTN_Settings.SerialNumber					= 265;
		get_Shift4OTN_Settings.Username						= "1941_Api_User";
		get_Shift4OTN_Settings.xxPassword					= "";
		get_Shift4OTN_Settings.Password						= "demoPassword@123";
		get_Shift4OTN_Settings.MID							= 1941;
		get_Shift4OTN_Settings.FunctionRequestCode			= "1B";
		get_Shift4OTN_Settings.URL							= "certify.dollarsonthenet.net";
		get_Shift4OTN_Settings.ProxyServer					= "";
		get_Shift4OTN_Settings.ProxyPort					= 80;
		get_Shift4OTN_Settings.ProxyUsername				= "";
		get_Shift4OTN_Settings.ProxyPassword				= "";
		get_Shift4OTN_Settings.i4GoURL						= "certify.i4Go.com";
		get_Shift4OTN_Settings.i4GoAccountID				= 1;
		get_Shift4OTN_Settings.i4GoSiteID					= 146;
	
		get_Shift4OTN_Settings.URL = GetSettings.CCServer;
		get_Shift4OTN_Settings.FunctionRequestCode = GetSettings.Transtype;
		parms = GetSettings.Username;
		if (ListLen(parms) GTE 2) {
			get_Shift4OTN_Settings.SerialNumber		= Val(Trim(ListGetAt(parms,1)));
			get_Shift4OTN_Settings.Username			= URLDecode(Trim(ListGetAt(parms,2)));
			get_Shift4OTN_Settings.xxPassword		= GetSettings.Password;
		}
		parms = GetSettings.Setting1;
		if (ListLen(parms) GTE 1) {	
			get_Shift4OTN_Settings.MID              = Val(Trim(ListGetAt(parms,1)));
			if (ListLen(parms) GTE 3) {
				get_Shift4OTN_Settings.i4GoAccountID				= Val(Trim(ListGetAt(parms,2)));
				get_Shift4OTN_Settings.i4GoSiteID					= Val(Trim(ListGetAt(parms,3)));
				get_Shift4OTN_Settings.i4GoURL						= "";
				if (ListLen(parms) GTE 4)
					get_Shift4OTN_Settings.i4GoURL						= Trim(ListGetAt(parms,4));
			}
        } 
		
		parms = GetSettings.Setting2;
		if (ListLen(parms) GTE 4) {
			get_Shift4OTN_Settings.ProxyServer		= Trim(URLDecode(ListGetAt(parms,1)));
			get_Shift4OTN_Settings.ProxyPort		= Val(Trim(ListGetAt(parms,2)));
			get_Shift4OTN_Settings.ProxyUsername	= Trim(URLDecode(Trim(ListGetAt(parms,3))));
			get_Shift4OTN_Settings.ProxyPassword	= Trim(ListGetAt(parms,4));
		}
	</cfscript>
	
	<cfif get_Shift4OTN_Settings.xxPassword is not "">
		<cftry>
			<cfset get_Shift4OTN_Settings.Password=Trim(Decrypt(URLDecode(get_Shift4OTN_Settings.xxPassword),Request.encrypt_key))>
			<cfcatch type="Any">
				<!--- do nothing, simply let through --->
			</cfcatch>
		</cftry>
	</cfif>
	<cfif get_Shift4OTN_Settings.ProxyPassword is not "">
		<cftry>
			<cfset get_Shift4OTN_Settings.ProxyPassword=Trim(Decrypt(URLDecode(get_Shift4OTN_Settings.ProxyPassword),Request.encrypt_key))>
			<cfcatch type="Any">
				<!--- do nothing, simply let through --->
			</cfcatch>
		</cftry>
	</cfif>
	
	<!--- The following settings are here until this functionality gets moved to the User Settings section --->
	<cfscript>
		// changing the defaults to take advantage of the new features because of the tokenization technology
		get_Shift4OTN_Settings.UserCCardEdit				= 1;	// used to show or hide the credit card "Update" button on the My Account page
		get_Shift4OTN_Settings.UserCCardDelete				= 1;	// used to show or hide the credit card "Delete" button on the My Account page
		get_Shift4OTN_Settings.UserCCardOnTheFlyUpdate		= 1;	// used to display the "Save/Update credit card on file" checkbox during the checkout process
		parms = GetSettings.Setting3;
		if (ListLen(parms) GTE 3) {
			get_Shift4OTN_Settings.UserCCardEdit				= Val(ListGetAt(parms,1));
			get_Shift4OTN_Settings.UserCCardDelete				= Val(ListGetAt(parms,2));
			get_Shift4OTN_Settings.UserCCardOnTheFlyUpdate		= Val(ListGetAt(parms,3));
		}
	</cfscript>
</cfif>
