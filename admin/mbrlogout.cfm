<cfcookie name="Lynx_UserID" expires="now">

<cfset pageTitle = "#application.sl_name# - Logout">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput> - Administration</title>
	<script language="javascript">
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.location.href='<cfoutput>#application.sl_url#</cfoutput>'
			window.close();
		  }
		}
	</script>
</head>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="closeRefresh();">
</body
></html>
