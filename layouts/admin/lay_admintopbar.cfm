
<!--- CFWebstore, version 6.50 --->

<!--- This is the default layout page for the store admin. Edit it as much as you desire using the components below. The default admin page includes a cascading menu using Ajax components. --->

<cfparam name="attributes.xfa_admin_link" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>

<title>CFWebstore: Admin</title>

<cfinclude template="../put_meta.cfm">	

<cfoutput>
<!--- This is used to keep the user's session alive --->
<script SRC="#Request.StorePath#includes/keepalive.js"></script>

<!--- Makes sure this page is not being loaded outside the admin frameset --->
<script type="text/javascript">
if( self == top ) { top.location.href = '#request.self#?fuseaction=home.admin#Request.Token2#'; }
</script>

<link href="#Request.StorePath#css/adminstyle.css" rel="stylesheet" type="text/css">

</cfoutput>	
</head>

<body  text="#333333" link="#666699" vlink="#666699" alink="#666699" LEFTMARGIN="0" TOPMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0">

<!--- THIS IS WHERE ALL GENERATED PAGE CONTENT GOES ---->
<!-- Compress to remove whitespace -->
<cfoutput>#fusebox.layout#</cfoutput>

</body></html>

