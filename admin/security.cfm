<cfif ParameterExists(Lynx_UserID)>
<cfelse>
	<cflocation url="sl_login.cfm">
</cfif>
