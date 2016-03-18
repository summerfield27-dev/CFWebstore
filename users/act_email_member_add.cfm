<!--- CFWebstore, version 6.50 --->

<!--- This template emails the ADMIN when a new member signs up. It is called from act_register.cfm. ---->	

<cfset LineBreak = Chr(13) & Chr(10)>

<cfif NOT isDefined("attributes.FirstName")>
	<!--- See if the user has a customer record --->
	<cfif qry_get_user.Customer_ID IS NOT 0>
		<cfset attributes.Customer_ID = qry_get_user.Customer_ID>
		<cfinclude template="qry_get_customer.cfm">
		<cfloop list="#qry_get_customer.ColumnList#" index="counter">
			<cfset attributes[counter] = qry_get_customer[counter][1]>
		</cfloop>			
	</cfif>
</cfif>

<cfset MergeContent = "User Name:  #qry_get_user.Username#" & LineBreak & LineBreak>

<cfif isDefined("attributes.FirstName")>
<cfset MergeContent = MergeContent & "#HTMLEditFormat(attributes.FirstName)# #HTMLEditFormat(attributes.LastName)#" & LineBreak>
<cfif len(attributes.Company)>
	<cfset MergeContent = MergeContent & "#HTMLEditFormat(attributes.Company)#" & LineBreak>	
</cfif>
<cfset MergeContent = MergeContent & "#HTMLEditFormat(attributes.Address1)#" & LineBreak>	
<cfif len(attributes.address2)>
	<cfset MergeContent = MergeContent & "#HTMLEditFormat(attributes.Address2)#" & LineBreak>	
</cfif>
<cfset MergeContent = MergeContent & LineBreak & "#HTMLEditFormat(attributes.City)#, ">

<cfif attributes.State IS NOT "Unlisted">
	<cfset MergeContent = MergeContent & "#HTMLEditFormat(attributes.State)# ">
<cfelse>
	<cfset MergeContent = MergeContent & "#HTMLEditFormat(attributes.State2)# ">
</cfif>

<cfset MergeContent = MergeContent & "#HTMLEditFormat(attributes.Zip)# ">

<cfif attributes.Country IS NOT "" AND attributes.Country IS NOT Request.AppSettings.HomeCountry>
	<cfset MergeContent = MergeContent & ListLast(attributes.Country,"^")& LineBreak & LineBreak>
</cfif>

<cfset MergeContent = MergeContent & "Phone: #HTMLEditFormat(attributes.Phone)#" & LineBreak>
<cfset MergeContent = MergeContent & "Fax: #HTMLEditFormat(attributes.Fax)#" & LineBreak>

</cfif>

<cfset MergeContent = MergeContent & "Email: #HTMLEditFormat(attributes.Email)#" & LineBreak>

<!--- Send Confirmation Email --->
<cfset Application.objGlobal.sendAutoEmail(Email=Request.AppSettings.Merchantemail,MailAction='NewMemberNotice',MergeContent=MergeContent)>


