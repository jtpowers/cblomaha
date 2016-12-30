<cfset addLevel = 9>
<cf_securityaccess userid="#cookie.Lynx_UserID#" aid="#application.aid#" dsn="#memberDSN#">
<cfset thisUserAccess = #useraccesslevel#>
<cfparam name="action" default="">

<cfquery name="getStaff" datasource="#memberDSN#">
	Select *
	From sl_user
	Where associd = #application.aid#
	Order by UserName
</cfquery>

<cfset rootDir = "../">
<cfset pageTitle = "#application.sl_name# - User Edit">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput> - Administration</title>
<cfinclude template="#rootdir#ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="#rootdir#ssi/header.htm">

<cfinclude template="sl_header.cfm">
<table>
	<tr>
		<td colspan="2" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td valign="top" align="left">
		<cfif thisUserAccess GTE addLevel>
			<a href="javascript:fPopWindow('memberedit.cfm', 'custom','500','480','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">Add User</a>
		</cfif>
		</td>
		<td valign="top" align="right">
		<span class="small"><cfoutput>#getStaff.RecordCount# Members Found</cfoutput></span>
		</td>
	<tr>
		<td valign="top" colspan="2">
			<table border="1" cellspacing="0" cellpadding="3">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<!---<td class="titlesmw">#</td>--->
					<td class="titlesmw">Name</td>
					<td class="titlesmw">Email</td>
					<td class="titlesmw">Notifications</td>
					<td class="titlesmw">Cell Nbr.</td>
				<cfif Lynx_UserID EQ 5 or Lynx_UserID EQ 6>
					<td class="titlesmw">Password</td>
				</cfif>
				</tr>
				<cfset colColor = "C6D6FF">
				<cfoutput query="getStaff">
					<cfset thisUserID =#getStaff.UserID#>

					<cfif colColor EQ "C6D6FF">
						<cfset colColor = "FFFFFF">
					<cfelse>
						<cfset colColor = "C6D6FF">
					</cfif>
					<TR bgcolor="#colColor#">
						<td valign="top">
						<cfif thisUserAccess GTE addLevel OR Lynx_UserID EQ thisUserID>
							<a href="javascript:fPopWindow('memberedit.cfm?cid=#Userid#', 'custom','500','480','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm">#username#</a>
						<cfelse>
							<span class="small">#username#</span>
						</cfif>
						</td>
						<td class="small" valign="top">#useremail#&nbsp;</td>
						<td class="small" valign="top">#UserTextNbr#&nbsp;</td>
						<td class="small" valign="top">
							<cfquery name="getLeagueNotify" datasource="#memberDSN#">
								Select l.leaguename
								From sl_user_notify un, sl_league l
								Where userid = #getStaff.Userid# and l.leagueid = un.leagueid and l.associd = #application.aid#
							</cfquery>
							#ValueList(getLeagueNotify.leaguename, ', ')#&nbsp;
						</td>
						<cfif Lynx_UserID EQ 5 or Lynx_UserID EQ 6>
						<td class="small" valign="top">
							<cfif Password GT "">
								#Decrypt(Password,'#application.pwKey#')#
							</cfif>
						</td>
						</cfif>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
</td></TR>
</TABLE>
<br><br>

</body>
</html>
