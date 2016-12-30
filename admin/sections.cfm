<cfset rootDir = "../">
<cfparam name="menu" default="">
<cfparam name="action" default="">

<cfquery name="getCategories" datasource="#memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'MenuSection' and AssocID = #application.aid# and LeagueID is NULL
	Order by Value_4
</cfquery>

<cfquery name="getCatOrder" datasource="#memberDSN#">
	Select Min(value_4) as minorder, Max(value_4) as maxorder
	From sl_general_purpose
	Where name = 'MenuSection' and AssocID = #application.aid# and LeagueID is NULL
</cfquery>

<cfset pageTitle = "#application.sl_name# - Menu Sections">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput> - Administration</title>
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
			<cfoutput>
			<a href="javascript:fPopWindow('sectionedit.cfm', 'custom','300','250','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Menu Section">Add Menu Section</a>
			</cfoutput>
			<table border="1" cellspacing="0" cellpadding="3">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center">Section Code</td>
					<td class="titlesmw" align="center">Menu Display</td>
					<td class="titlesmw" align="center">Long Name</td>
					<td class="titlesmw" align="center">Menu</td>
					<td class="titlesmw" align="center">Homepage</td>
					<td class="titlesmw" align="center">Sort Order</td>
					<td class="titlesmw" align="center">Pages</td>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getCategories">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="#rColor#">
						<td class="small">
							<a href="javascript:fPopWindow('sectionedit.cfm?cat=#value_1#', 'custom','300','250','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Menu Section">
							#value_1#
							</a>
						</td>
						<td class="small">#value_2#</td>
						<td class="small">#value_3#</td>
						<td class="small" align="center"><cfif value_5 EQ 1>Yes<cfelse>No</cfif></td>
						<td class="small" align="center"><cfif value_6 EQ 1>Yes<cfelse>No</cfif></td>
						<td class="small" align="center">
						<cfif getCatOrder.minorder NEQ value_4>
							<a href="javascript:fPopWindow('changeorder.cfm?cat=#value_1#&dir=up&name=MenuSection', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="../wsimages/up.gif" alt="Move Up" border="0"></a>
						<cfelse>
							<img src="../wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						<cfif getCatOrder.maxorder NEQ value_4>
							<a href="javascript:fPopWindow('changeorder.cfm?cat=#value_1#&dir=down&name=MenuSection', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="../wsimages/down.gif" alt="Move Down" border="0"></a>
						<cfelse>
							<img src="../wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						</td>
						<td class="small"><a href="sectionitems.cfm?cat=#value_1#" CLASS="linksm" title="View Page List">Page List</a></td>
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
