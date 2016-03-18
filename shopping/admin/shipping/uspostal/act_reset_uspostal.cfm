
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to reset the cached query for the U.S.P.S. methods. Called from act_uspostal_method.cfm and act_save_uspostal_used.cfm --->

<!--- Reset cached query --->

<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfset Application.objShipping.getUSPSMethods()>

