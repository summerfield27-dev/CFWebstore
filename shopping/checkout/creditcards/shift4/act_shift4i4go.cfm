
<!--- CFWebstore, version 6.50 --->

<!--- I normalize the token information returned from i4Go into a variables CFWebstore is used to handling. I am called from do_checkout.cfm. --->

<cfparam name="attributes.i4go_uniqueID" default="" />
<cfparam name="attributes.i4go_expirationMonth" default="" />
<cfparam name="attributes.i4go_expirationYear" default="" />
<cfparam name="attributes.i4go_cardType" default="" />

<cfset attributes.step="payment" />
<cfif attributes.i4go_uniqueID NEQ "">
	<cfset attributes.cardNumber="@"&attributes.i4go_uniqueID />
<cfelse>
	<cfset attributes.cardNumber="" />
</cfif>
<cfset month=attributes.i4go_expirationMonth />
<cfset attributes.month=attributes.i4go_expirationMonth />
<cfset year=attributes.i4go_expirationYear />
<cfset attributes.year=attributes.i4go_expirationYear />

<cfscript>
	variables.ct=StructNew();
	variables.ct.AX = "Amex";
	variables.ct.CB = "Carte Blanche";
	variables.ct.NS = "Discover";
	variables.ct.DC = "Diner's Club";
	variables.ct.EN = "enRoute";
	variables.ct.JC = "JCB";
	variables.ct.MC = "MasterCard";
	variables.ct.VS = "Visa";
	variables.ct.YC = "Gift Card";
	variables.ct.GC = "Gift Card";
	variables.ct.PL = "Gift Card";
</cfscript>

<cfset cardType=attributes.i4go_cardType />
<cfif cardType NEQ "" and StructKeyExists(variables.ct,cardType)>
	<cfset cardType=variables.ct[cardType] />
</cfif>
<cfset attributes.cardType=cardType />
