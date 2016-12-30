<cfset rootDir = "../../">

<cfquery name="getRefs" datasource="#memberDSN#">
	Select *
	From sl_referee
	Where LeagueID = #url.lid#
	Order by RefName
</cfquery>

<cfset pageTitle = "#application.sl_name# - Referee Edit">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#pageTitle#</cfoutput></title>
<cfinclude template="#rootDir#ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="#rootDir#ssi/header.htm">

<cfinclude template="sl_header.cfm">
<table>
	<tr>
		<td class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td valign="top">
			<cfoutput>
			<a href="javascript:fPopWindow('refereeedit.cfm?lid=#url.lid#', 'custom','400','380','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Add New Referee">Add Umpire/Ref</a>
			</cfoutput>
			<table border="1" cellspacing="0" cellpadding="3">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center">Name</td>
					<td class="titlesmw" align="center">Phone</td>
					<td class="titlesmw" align="center">Cell Phone</td>
					<td class="titlesmw" align="center">Email Address</td>
					<td class="titlesmw" align="center">&nbsp;</td>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getRefs">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="#rColor#">
						<td><a href="javascript:fPopWindow('refereeedit.cfm?lid=#url.lid#&rid=#refid#', 'custom','400','380','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Edit Referee">#refname#</a></td>
						<td class="small">#phonenbr#&nbsp;</td>
						<td class="small">#cellphone#&nbsp;</td>
						<td class="small">#email#&nbsp;</td>
						<td class="small"><a href="game.cfm?lid=#url.lid#&rid=#RefID#&did=all" class="linksm" title="View Referee Games">Games</a></td>
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
