<!--- CFWebstore, version 6.50 --->

<!--- This page provides a short, direct link to a particular page in the site. The default is to use it to display a product page, but you can customize for any particular fuseaction. --->

<cfif isdefined("url.ID")>
 <cflocation url="#request.self#?fuseaction=product.display&product_id=#url.ID#" addtoken="No">
<cfelse>
 <cflocation url="#request.self#" addtoken="No">
</cfif>


