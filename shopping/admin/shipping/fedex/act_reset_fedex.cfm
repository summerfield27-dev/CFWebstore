
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to reset the cached query for the FedEx methods. Called from act_fedex_method.cfm and act_save_fedex_used.cfm --->

<!--- Reset cached query --->

<cfset Request.Cache = CreateTimeSpan(0, 0, 0, 0)>
<cfset Application.objShipping.getFedExMethods()>

