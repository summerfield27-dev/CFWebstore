
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to reset the cached query for the intershipper methods. Called from act_intship_method.cfm and act_save_intship_used.cfm --->

<!--- Reset cached query --->

<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfset Application.objShipping.getIntShipMethods()>



