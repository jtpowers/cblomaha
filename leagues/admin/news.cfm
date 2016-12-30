<cfparam name="menu" default="">
<cfparam name="action" default="">

<cfquery name="getCategories" datasource="#memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'NewsCategory' and LeagueID = #url.lid#
	Order by Value_4
</cfquery>
<cfparam name="form.cat" default="#getCategories.Value_1[1]#">

<cfquery name="getLeagues" datasource="#memberDSN#">
	Select *
	From sl_league
	Order by LeagueName
</cfquery>

<cfquery name="getNews" datasource="#memberDSN#">
	Select *
	From sl_news
	Where leagueid = #url.lid# and
			category = '#form.cat#'
	Order by category, sortorder, createdate desc
</cfquery>

<cfset rootDir = "../../">
<cfset pageTitle = "Sports League - News Edit">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput> - Administration</title>
<cfinclude template="#rootDir#ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="#rootDir#ssi/header.htm">

<cfinclude template="sl_header.cfm">
<table>
	<tr>
		<td colspan="2" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<form action="news.cfm" method="post">
	<tr>
		<td colspan="2" align="left" class="smallb">
			News Category:
			<select name="cat" onChange="document.forms(0).submit();" class="small">
			<cfoutput query="getCategories">
				<option value="#Value_1#"<cfif Value_1 EQ form.cat> SELECTED</cfif>>#Value_3#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
	</form>
	<tr>
		<td valign="top">
			<cfoutput>
			<a href="javascript:fPopWindow('newsedit.cfm?cat=#form.cat#', 'custom','700','500','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="small">Add News Item</a>
			</cfoutput>
			<table border="1" cellspacing="0" cellpadding="3">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center">Title</td>
					<td class="titlesmw" align="center">Category</td>
					<td class="titlesmw" align="center">Sort Order</td>
					<td class="titlesmw" align="center">Create Date</td>
				</tr>
				<cfoutput query="getNews">
					<tr>
						<td class="small">
							<a href="javascript:fPopWindow('newsedit.cfm?nid=#newsid#&cat=#category#', 'custom','700','500','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="small">
							#title#
							</a>
						</td>
						<td class="small">#category#</td>
						<td class="small" align="center">#sortorder#</td>
						<td class="small">#DateFormat(createdate, "mm/dd/yyyy")#</td>
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
