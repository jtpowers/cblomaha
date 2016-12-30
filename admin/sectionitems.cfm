<cfset rootDir = "../">
<cfparam name="menu" default="">
<cfparam name="action" default="">

<cfif Not isDefined("url.cat")>
	<cfquery name="getFirstCategory" datasource="#memberDSN#" maxrows="1">
		Select *
		From sl_general_purpose
		Where name = 'MenuSection' and AssocID = #application.aid#
		Order by Value_4
	</cfquery>
	<cfset url.cat = "#getFirstCategory.Value_1[1]#">
</cfif>

<cfquery name="getCategoryInfo" datasource="#memberDSN#" maxrows="1">
	Select *
	From sl_general_purpose
	Where name = 'MenuSection' and 
				AssocID = #application.aid# and
				value_1 = '#url.cat#'
</cfquery>

<cfquery name="getNews" datasource="#memberDSN#">
	Select *
	From sl_news
	Where AssocID = #application.aid# and
			category = '#url.cat#'
	Order by displayflag desc, category, sortorder, createdate desc
</cfquery>

<cfquery name="getCatOrder" datasource="#memberDSN#">
	Select Min(sortorder) as minorder, Max(sortorder) as maxorder
	From sl_news
	Where category = '#url.cat#' and AssocID = #application.aid#
</cfquery>

<cfset pageTitle = "#application.sl_name# - #getCategoryInfo.value_3# Pages">
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
			<cfoutput>
			<a href="javascript:fPopWindow('sectionitemedit.cfm?cat=#url.cat#', 'custom','800','600','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0','resizable: 1')" CLASS="linksm" title="Add Page">Add #getCategoryInfo.value_3# Page</a>
			</cfoutput>
			<table border="1" cellspacing="0" cellpadding="3">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center">Title</td>
					<td class="titlesmw" align="center">Category</td>
					<td class="titlesmw" align="center">Create Date</td>
					<td class="titlesmw" align="center">Display</td>
					<td class="titlesmw" align="center">Sort Order</td>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getNews">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="#rColor#">
						<td class="small">
							<a href="javascript:fPopWindow('sectionitemedit.cfm?nid=#newsid#&cat=#category#', 'custom','800','600','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0','resizable: 1')" CLASS="linksm" title="Edit Page">
							#title#
							</a>
						</td>
						<td class="small">#category#</td>
						<td class="small">#DateFormat(createdate, "mm/dd/yyyy")#</td>
						<td class="small"><cfif DisplayFlag>Yes<cfelse>No</cfif></td>
						<td class="small" align="center">
						<cfif getCatOrder.minorder NEQ sortorder AND DisplayFlag>
							<a href="javascript:fPopWindow('changeorder.cfm?nid=#newsid#&dir=up&name=sl_news', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="../wsimages/up.gif" alt="Move Up" border="0"></a>
						<cfelse>
							<img src="../wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						<cfif getCatOrder.maxorder NEQ sortorder AND DisplayFlag>
							<a href="javascript:fPopWindow('changeorder.cfm?nid=#newsid#&dir=down&name=sl_news', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="../wsimages/down.gif" alt="Move Down" border="0"></a>
						<cfelse>
							<img src="../wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						</td>
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
