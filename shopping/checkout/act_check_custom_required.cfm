<!--- CFWebstore, version 6.50 --->

<!--- This page is run to check that any required custom fields have been filled out. Called by shopping.checkout (step=shipping) --->

<cfparam name="customneeded" default="0">

<cfif len(attributes.CustomText_Req)>
	
	<cfloop index="customfield" list="#attributes.CustomText_Req#">
		<cfif NOT isDefined("attributes.#customfield#") OR NOT Len(attributes[customfield])>
			<cfset customneeded = 1>
		</cfif>
	</cfloop>
	
<cfelseif len(attributes.CustomSelect_Req)>
	
	<cfloop index="customfield" list="#attributes.CustomSelect_Req#">
		<cfif NOT isDefined("attributes.#customfield#") OR NOT Len(attributes[customfield])>
			<cfset customneeded = 1>
		</cfif>
	</cfloop>

	
<cfelse>
	<!--- No custom fields required --->
	<cfset customneeded = 0>
	
</cfif>
