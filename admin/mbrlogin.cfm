<cfset ermsg = "">
<cfset done = 0>
<cfset rootDir = "../">
<cfif isDefined("form.slPassword")>
	<cfif slPassword GT "">
		<cfset ePassword = Encrypt(slPassword, '#application.pwKey#')>
	<cfelse>
		<cfset ePassword = slPassword>
	</cfif>
	<cfquery name="checkUser" datasource="#memberDSN#">
		Select userid
		From sl_user
		Where UserEmail = '#s_email#' and password = '#ePassword#' and associd = #application.aid#
	</cfquery>
	<cfif checkUser.RecordCount GT 0>
		<cfcookie name="Lynx_UserID" value="#checkUser.userid#">
		<cfset ermsg = "OK">
		<cfset done = 1>
	<cfelse>
		<cfset ermsg = "Sorry, Email Address and/or Password was not found.">
	</cfif>
</cfif>

<cfset pageTitle = "#application.sl_name# - Login">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput> - Administration</title>
<cfinclude template="../ssi/webscript.htm">
	<script language="javascript">
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.history.go(0)
			window.close();
		  }
		}
	</script>
</head>
<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfset onloadattr = "document.forms(0).s_email.focus();">
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<cfif ermsg NEQ "OK">
<form action="mbrlogin.cfm" method="post" name="loginform">
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
						<input type="submit" name="Login" value="Login" class="small">
						<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
					</div>
				</td></tr>
				<tr><td colspan="2">
					<div align="center">
						<a href="mbrforgot.cfm" class="linksm">Forgot Password</a>
					</div>
				</td></tr>
			</table>
			</td></tr></table>
		</td>
	</tr>
</table>
</form>
<br><br>
</cfif>
</body>
</html>

