
<!--- CFWebstore, version 6.50 --->

<!--- This is used to update the shopping cart settings. Called by shopping.admin&cart=save --->

<!--- CSRF Check --->
<cfset keyname = "cartSettings">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<cfparam name="attributes.BaseOrderNum" default="0">
<cfparam name="attributes.Require_Text" default="">
<cfparam name="attributes.Require_Select" default="">

<cfif NOT isNumeric(attributes.MinTotal)>
	<cfset attributes.MinTotal = 0>
</cfif>

<!--- Initialize list of required custom fields --->
<cfset RequireTextList = "">
<cfset RequireSelectList = "">

<!--- Loop through the list of required custom fields and make sure something has been entered for the label of that field --->
<!--- textboxes --->
<cfif len(attributes.Require_Text)>
	<cfloop index="fieldnum" list="#attributes.Require_Text#">
		<cfset FieldText = attributes[fieldnum]>
		<cfif len(Trim(FieldText))>
			<cfset RequireTextList = ListAppend(RequireTextList, fieldnum)>
		</cfif>
	</cfloop>
</cfif>
<!--- selectboxes --->
<cfif len(attributes.Require_Select)>
	<cfloop index="fieldnum" list="#attributes.Require_Select#">
		<cfset FieldText = attributes[fieldnum]>
		<cfif len(Trim(FieldText))>
			<cfset RequireSelectList = ListAppend(RequireSelectList, fieldnum)>
		</cfif>
	</cfloop>
</cfif>

<cfquery name="EditOrderSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
	UPDATE #Request.DB_Prefix#OrderSettings
	SET Giftwrap = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Giftwrap#">,
	Giftcard = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Giftcard#">,
	Delivery = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Delivery#">,
	Coupons = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Coupons#">,
	Backorders = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.Backorders#">,
	ShowBasket = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.showbasket#">,
	MinTotal = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MinTotal#">,
	NoGuests = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.NoGuests#">,
	AllowInt = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.AllowInt#">,
	SkipAddressForm = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.SkipAddressForm#">,
	BaseOrderNum = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(attributes.BaseOrderNum),attributes.BaseOrderNum,0)#">,
	AgreeTerms = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Trim(attributes.AgreeTerms)#">,
	<!--- custom textboxes --->
	<cfloop index="num" from="1" to="3">
	CustomText#num# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes['CustomText' & num])#">,
	</cfloop>
	<!--- custom selectboxes --->
	<cfloop index="num" from="1" to="2">
	CustomSelect#num# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes['CustomSelect' & num])#">,
	CustomChoices#num# = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Trim(Replace(attributes['CustomChoices' & num], ", ", ",", "All"))#">,
	</cfloop>
	CustomText_Req = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RequireTextList#">,
	CustomSelect_Req = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RequireSelectList#">,
	EmailUser = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.EmailUser#">,
	EmailAdmin = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.EmailAdmin#">,
	EmailDrop = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.EmailDrop#">,
	EmailAffs = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.EmailAffs#">,
	EmailDropWhen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EmailDropWhen#">,
	OrderEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.OrderEmail)#">,
	DropEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.DropEmail)#">
</cfquery>

<cfquery name="EditMainSettings" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
UPDATE #Request.DB_Prefix#Settings
SET GiftRegistry = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.giftregistry#">,
	Wishlists = <cfqueryparam cfsqltype="#Request.SQL_Bit#" value="#attributes.wishlists#">
</cfquery>


<!--- Get New Settings --->
<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfinclude template="../../qry_get_order_settings.cfm">
<cfinclude template="../../../queries/qry_getsettings.cfm">



