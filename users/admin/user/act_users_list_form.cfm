<!--- CFWebstore, version 6.50 --->

<!--- Performs admin actions when editing a list of users. Called by the fuseaction users.admin&user=actform --->

<!--- CSRF Check --->
<cfset keyname = "userListEdit">
<cfinclude template="../../../includes/act_check_csrf_key.cfm">

<!--- Create the string with the filter parameters --->	
<cfset addedpath="fuseaction=users.admin&user=list">
<cfset fieldlist="uid,un,email,email_bad,subscribe,cid,gid,account_id,birthdate,CardisValid,currentbalance">
<cfinclude template="../../../includes/act_setpathvars.cfm">

<cfif attributes.action is "Move">

	<!--- first time through, present Group form ----------------->
	<cfif NOT StructKeyExists(attributes,"groupmove")>
	
		<!--- Create list of users to move to new group --->
		<cfset ListtoMove = "">
		<cfloop index="User_ID" list="#attributes.UserList#">
			<cfset Checked = StructKeyExists(attributes, 'User_ID' & User_ID)>
			<cfif Checked>
				<cfset ListtoMove = ListAppend(ListtoMove, User_ID)>
			</cfif>
		</cfloop>
	
		<cfinclude template="../group/qry_get_all_groups.cfm">
	
		<cfmodule template="../../../customtags/format_admin_form.cfm"
		box_title="User Administration"
		Width="400"
		required_fields="0"
		>
		<tr><td align="center" class="formtitle">
			<cfoutput>
			<form action="#self#?#replace(addedpath, "list", "actform")##request.token2#" method="post">
			<input type="hidden" name="UserList" value="#attributes.UserList#"/>
			<input type="hidden" name="Action" value="Move"/>
			<input type="hidden" name="ListtoMove" value="#ListtoMove#"/>
			<cfset keyname = "userListEdit">
			<cfinclude template="../../../includes/act_add_csrf_key.cfm">
			</cfoutput>
	<br/>
			Select Group to move users to:<p>
			<select name="GroupMove">
			<cfoutput query="qry_get_all_groups">
				<option value="#Group_ID#">#Name#</option>
			</cfoutput>
			</select>
			<p>
			<input class="formbutton" type="submit" value="Move Users"/>
			</form>	
		</td></tr>
		</cfmodule> 
	
	<cfelse>
	
		<cfloop index="UID" list="#attributes.ListtoMove#">
			<!--- Display message if trying to delete Admin account --->
			<cfif UID IS 1>
				<cfoutput>
				<script type="text/javascript">
				 alert('Sorry, you cannot move the main Administrator account!');    
				</script>
				</cfoutput>	

			<cfelse>
				<cfquery name="EditUser" datasource="#Request.DS#" username="#Request.DSuser#" password="#Request.DSpass#">
					UPDATE #Request.DB_Prefix#Users
					SET Group_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GroupMove#">
					WHERE User_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#UID#">
				</cfquery>
			</cfif>		
		</cfloop>

		<!--- Display confirmation message. --->
		<cfset attributes.XFA_success=addedpath>
		<cfset attributes.box_title="User Group">
		<cfinclude template="../../../includes/admin_confirmation.cfm">	
	
	</cfif>	
	
<cfelseif attributes.action is "Delete">

	<cfloop index="User_ID" list="#attributes.UserList#">
		<cfset Checked = StructKeyExists(attributes, 'User_ID' & User_ID)>

		<cfif Checked>
			<!--- Display message if trying to delete Admin account --->
			<cfif User_ID IS 1>
				<cfoutput>
				<cfprocessingdirective suppresswhitespace="no">
				<script type="text/javascript">
				<!--
 				alert('Sorry, you cannot delete the main Administrator account!');   
				//-->
				</script>
				</cfprocessingdirective>
				</cfoutput>

			<cfelse>
				<cfset attributes.uid = user_ID>
				<cfinclude template="act_delete_user.cfm">

			</cfif>
		</cfif>
	</cfloop>

		<!--- Display confirmation message. --->
		<cfset attributes.XFA_success=addedpath>
		<cfset attributes.box_title="User Group">
		<cfinclude template="../../../includes/admin_confirmation.cfm">	


</cfif>

		