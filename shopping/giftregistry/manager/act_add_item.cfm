
<!--- CFWebstore, version 6.50 --->

<!--- This template adds items to the Gift Registry from a product page. --->

<!--- Select Gift Registry if needed.  --->
<cfset variables.uid = Session.User_ID>
<cfinclude template="../qry_get_giftregistries.cfm">

<!--- If gift registry not found, reselect ---->
<cfif NOT qry_Get_registries.recordcount>

	<cflocation url="#request.self#?fuseaction=shopping.giftregistry&manager=additems#request.token2#" addtoken="No">
	
<!--- If more than one registry found, present selection page --->
<cfelseif qry_Get_registries.recordcount GT 1 AND NOT len(attributes.GiftRegistry_ID)>

	<cfinclude template="dsp_select_registry.cfm">

<!--- One registry found, so add product to it --->
<cfelse>

	<cfparam name="attributes.product_id" default="0">
	
	<!--- If passing in registry ID, make sure it is valid for this user --->
	<cfif len(attributes.GiftRegistry_ID)>
	
		<cfquery name="checkRegistry" dbtype="query">
			SELECT * FROM qry_Get_registries
			WHERE GiftRegistry_ID = #attributes.GiftRegistry_ID#
		</cfquery>
	
		<cfif NOT checkRegistry.RecordCount>
			<cflocation url="#request.self#?fuseaction=shopping.giftregistry&manager=additems#request.token2#" addtoken="No">
		</cfif>
	
	<!--- otherwise set the id to the user's only registry --->
	<cfelse>
		<cfset attributes.GiftRegistry_ID = qry_Get_registries.GiftRegistry_ID>
	</cfif>

	<cfset Application.objCart.addProducttoRegistry(argumentcollection=attributes)>
	
	<!--- Success! Now display Gift Registry Item Form --->
	<cflocation url="#request.self#?fuseaction=shopping.giftregistry&manage=items&giftregistry_id=#attributes.GiftRegistry_ID##request.token2#" addtoken="No">

</cfif>
	
