<cfset ermsg = "">
<cfset rootDir = "../../">
<cfif isDefined("form.slPassword")>
	<cfset ePassword = Encrypt(slPassword, '#application.pwKey#')>
	<cfquery name="checkUser" datasource="#application.memberDSN#">
		Select userid
		From sl_user
		Where UserEmail = '#s_email#' and password = '#ePassword#'
	</cfquery>
	<cfif checkUser.RecordCount GT 0>
		<cfcookie name="Lynx_UserID" value="#checkUser.userid#">
		<cfset ermsg = "OK">
		<cfinclude template="index.cfm">
	<cfelse>
		<cfset ermsg = "Sorry, Email Address and/or Password was not found.">
	</cfif>
</cfif>

<cfif ermsg NEQ "OK">

<cfset pageTitle = "#application.sl_name# - Login">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput> - Administration</title>
<cfinclude template="#rootdir#ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0" onLoad="document.forms(0).s_email.focus();">
<cfinclude template="#rootdir#ssi/header.htm">
<form action="sl_login.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post" name="loginform">
<table width="100%">
	<tr>
		<td colspan="2" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td colspan="2" class="notice" align="center"><cfoutput>#ermsg#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td valign="top" align="center">
			<table border="1" cellspacing="0" cellpadding="3"><tr><td>
			<table border="0" cellspacing="0" cellpadding="3">
				<tr>
					<td class="smallb">Email Address: </td>
					<td><input type="text" name="s_email" class="small" size="40"></td>
				</tr>
				<tr>
					<td class="smallb">Password: </td>
					<td><input name="slPassword" type="password" class="small"></td>
				</tr>
				<tr><td colspan="2">
					<div align="center">
						<input type="submit" name="Submit" value="Submit" class="small">
					</div>
				</td></tr>
				<tr><td colspan="2">
					<div align="center">
						<a href="sl_forgot.cfm?lid=<cfoutput>#url.lid#</cfoutput>" class="linksm">Forgot Password</a>
					</div>
				</td></tr>
			</table>
			</td></tr></table>
		</td>
	</tr>
</table>
</form>
<br><br>
</body>
</html>
</cfif>

