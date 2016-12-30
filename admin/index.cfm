<cfset rootDir = "../">

<cfset pageTitle = "#application.sl_name# - Manager">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#pagetitle#</cfoutput></title>
<cfinclude template="#rootDir#ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="#rootDir#ssi/header.htm">
<cfinclude template="sl_header.cfm">
<div class="titlemain" align="center"><cfoutput>#pagetitle#</cfoutput></div>
<cfinclude template="#rootDir#ssi/footer_blank.htm">
</body>
</html>
