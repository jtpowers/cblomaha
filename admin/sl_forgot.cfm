<cfset ermsg = "">

<cfif isDefined("form.s_email")>
	<cfquery name="checkUser" datasource="#memberDSN#">
		Select password, username
		From sl_user
		Where UserEmail = '#s_email#'
	</cfquery>
	<cfif checkUser.RecordCount GT 0>
<cfmail subject="#application.sl_name#" to="#s_email#" from="webmaster@lynxbasketball.org">
Hello #checkUser.username#,

Here's your login info for the Admin section of #application.sl_url#:

email: #s_email#
password: #Decrypt(checkUser.password,'#application.pwKey#')#

Have a Great Day!!!!!

</cfmail>
			<cfset ermsg = "Your password had been emailed to you.">
	<cfelse>
		<cfset ermsg = "Sorry, But you Email Address was not found.">
	</cfif>
</cfif>

<cfif ermsg NEQ "OK">
<cfset rootDir = "../">
<cfset pageTitle = "Sports League - Forgot Password">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput> - Administration</title>
<cfinclude template="../ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0" onLoad="document.forms(0).s_email.focus();">
<cfinclude template="../ssi/header.htm">
<form action="sl_forgot.cfm" method="post" name="loginform">
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
				<tr><td colspan="2">
					<div align="center">
						<input type="submit" name="Submit" value="Submit" class="small">
					</div>
				</td></tr>
				<tr><td colspan="2">
					<div align="center">
						<a href="sl_login.cfm" class="linksm">Return to Login</a>
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

