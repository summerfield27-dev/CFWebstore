
<!--- CFWebstore, version 6.50 --->

<!--- Gets list of all Groups used in various admin pages. Called from: 		
	shopping\admin\discount\act_discount.cfm
	users\admin\email\dsp_email.cfm
	users\admin\email\dsp_select_form.cfm
	users\admin\user\act_users_list_form.cfm
	users\admin\user\dsp_users_list_form.cfm
	users\admin\user\dsp_users_list.cfm
	users\admin\user\dsp_user_form.cfm --->

<cfquery name="qry_get_all_groups" datasource="#Request.ds#" username="#Request.DSuser#" password="#Request.DSpass#">
	SELECT * FROM #Request.DB_Prefix#Groups
</cfquery>
		


