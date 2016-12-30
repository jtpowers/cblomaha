<cfparam name="action" default="">

<cfquery name="getAlerts" datasource="#memberDSN#">
	Select *
	From sl_alert
	Where associd = #application.aid# and leagueid is null
	Order by startdate desc
</cfquery>
<cfset rootDir = "../">
<cfset pageTitle = "#application.sl_name# - Alert Edit">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#pageTitle#</cfoutput></title>
<cfinclude template="../ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="../ssi/header.htm">

<cfinclude template="sl_header.cfm">
<table>
	<tr>
		<td colspan="2" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td valign="top">
			<a href="javascript:fPopWindow('alertedit.cfm', 'custom','500','300','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Alert">Add Alert</a>
			<table border="1" cellspacing="0" cellpadding="3">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center">Name</td>
					<td class="titlesmw" align="center">Start Date</td>
					<td class="titlesmw" align="center">End Date</td>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getAlerts">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="#rColor#">
						<td class="small"><a href="javascript:fPopWindow('alertedit.cfm?aid=#alertid#', 'custom','500','300','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Alert">#AlertTitle#</a></td>
						<td class="small" align="center">#DateFormat(StartDate, "mm/dd/yyyy")#&nbsp;</td>
						<td class="small" align="center">#DateFormat(EndDate, "mm/dd/yyyy")#&nbsp;</td>
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
