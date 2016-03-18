
<!--- CFWebstore, version 6.50 --->

<!---
<fusedoc fuse="FBX_Settings.cfm">
	<responsibilities>
		I set up the enviroment settings for this circuit. If this settings file is being inherited, then you can use CFSET to override a value set in a parent circuit or CFPARAM to accept a value set by a parent circuit
	</responsibilities>	
</fusedoc>
--->

<cfinclude template="qry_ship_settings.cfm">
<cfinclude template="qry_get_order_settings.cfm">

<cfinclude template="../users/qry_get_user_settings.cfm">


