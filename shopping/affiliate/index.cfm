
<!--- CFWebstore, version 6.50 --->

<!--- This is the shopping.affiliate circuit. It runs the functions for the store affiliates --->

<cfset Webpage_title = "Affiliate #attributes.do#">

<cfmodule template="../../access/secure.cfm"
keyname="login"
requiredPermission="0"
>
	
<cfif ispermitted AND isDefined("attributes.do")>
	<cfswitch expression="#attributes.do#">
	
		<cfcase value="register">
			<cfif isDefined("attributes.sub_affiliate")>
				<cfinclude template="act_register.cfm">
				<cfinclude template="dsp_register.cfm">	
			<cfelse>
				<cfinclude template="dsp_register_form.cfm">
			</cfif>				
		</cfcase>
	
		<cfcase value="report">
			<cfinclude template="dsp_report.cfm">			
		</cfcase>

		<cfcase value="links">
			<cfinclude template="dsp_links.cfm">
		</cfcase>
			
	</cfswitch>
</cfif>


