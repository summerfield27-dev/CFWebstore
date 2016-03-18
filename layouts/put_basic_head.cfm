
<!--- CFWebstore, version 6.50 --->

<!--- This page includes all the required code for CFWebstore layout files --->

<!--- The web page title is set dynamically to match category, page, product or feature name/title. Proper web page titles are important for search engine placement and ranking. --->

<cfparam name="webpage_title" default="#request.AppSettings.siteName#">

<!--- Strip any HTML tags from the title tag if necessary --->
<cfset Request.HTML_title = REReplace(webpage_title,"<[^>]*>","","ALL") & " - " & request.AppSettings.siteName>

<!--- Required to use the whitespace suppression --->
<cfinclude template="../includes/puthtmlcompress.cfm">

<!--- Required if you wish to pass parameters into the layout page, will appear as attribute scope --->
<cfinclude template="../includes/parseparams.cfm">

<!--- Includes code for dynamic meta tags --->
<cfparam name="metadescription" default="#request.appsettings.metadescription#">
<cfparam name="keywords" default="#request.appsettings.keywords#">

<cfset Request.Meta_Descript = metadescription>
<cfset Request.Meta_Keywords = keywords>

<cfsavecontent variable="AddtoHead">
<cfoutput>
<!---- REQUIRED for search engine safe URLs to work ---->
<base href="http://www.dogpatchphoto.com/index.cfm/store/" />

<!--- REQUIRED - provides for informative status bar messages on link roll-overs --->
<script type="text/javascript" src="#Request.StorePath#includes/statusbarmessage.js"></script>

<!--- REQUIRED - Qforms provides the javascript form field error checking --->
<cfinclude template="../includes/qforms.cfm">

<!--- This is used to keep the user's session alive --->
<script type="text/javascript" src="#Request.StorePath#includes/keepalive.js"></script>
<!--- Script for calendar popups --->
<script type="text/javascript" src="#Request.StorePath#includes/CalendarPopup.js"></script>

<link rel="stylesheet" href="#Request.StorePath#css/calendar.css" type="text/css"/>
<link rel="stylesheet" href="#Request.StorePath#css/default.css" type="text/css" />
</cfoutput>

<script type="text/javascript">
//used for the calendar popup
document.write(getCalendarStyles());
</script>	
</cfsavecontent>

<cfhtmlhead text="<!-- added by layouts/put_basic_head.cfm -->">
<cfhtmlhead text="#AddtoHead#">
 
<cfset Session.CatMenu = Application.objMenus.dspCatMenu(menu_type="list")>
