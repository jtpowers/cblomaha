<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="menu" default="">
<cfparam name="action" default="">

<cfif Not isDefined("url.cat")>
	<cfquery name="getFirstCategory" datasource="#application.memberDSN#" maxrows="1">
		Select *
		From sl_general_purpose
		Where name = 'MenuSection' and LeagueID = #url.lid#
		Order by Value_4
	</cfquery>
	<cfset url.cat = "#getFirstCategory.Value_1[1]#">
</cfif>

<cfquery name="getCategoryInfo" datasource="#application.memberDSN#" maxrows="1">
	Select *
	From sl_general_purpose
	Where name = 'MenuSection' and 
				LeagueID = #url.lid# and
				value_1 = '#url.cat#'
</cfquery>

<cfquery name="getNews" datasource="#application.memberDSN#">
	Select *
	From sl_news
	Where leagueid = #url.lid# and
			category = '#url.cat#'
	Order by displayflag desc, category, sortorder, createdate desc
</cfquery>

<cfquery name="getCatOrder" datasource="#application.memberDSN#">
	Select Min(sortorder) as minorder, Max(sortorder) as maxorder
	From sl_news
	Where category = '#url.cat#' and LeagueID = #url.lid#
</cfquery>

<cfset pageTitle = "#getCategoryInfo.value_3# Pages">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
    <div class="col-md-8">

<table class="table table-condensed no-border">
	<tr>
		<td valign="top">
			<cfoutput>
			<a href="javascript:fPopWindow('sectionitemedit.cfm?lid=#url.lid#&cat=#url.cat#', 'custom','800','600','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0','resizable: 1')" CLASS="linksm" title="Add Page">Add #getCategoryInfo.value_3# Page</a>
			</cfoutput>
			<table class="table table-condensed table-bordered">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center">Title</td>
					<td class="titlesmw hidden-xs" align="center">Category</td>
					<td class="titlesmw hidden-xs" align="center">Create Date</td>
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
							<a href="javascript:fPopWindow('sectionitemedit.cfm?lid=#url.lid#&nid=#newsid#&cat=#category#', 'custom','800','600','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0','resizable: 1')" CLASS="linksm" title="Edit Page">
							#title#
							</a>
						</td>
						<td class="small hidden-xs">#category#</td>
						<td class="small hidden-xs">#DateFormat(createdate, "mm/dd/yyyy")#</td>
						<td class="small"><cfif DisplayFlag>Yes<cfelse>No</cfif></td>
						<td class="small" align="center">
						<cfif getCatOrder.minorder NEQ sortorder AND DisplayFlag>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&nid=#newsid#&dir=up&name=sl_news', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="#rootdir#wsimages/up.gif" alt="Move Up" border="0"></a>
						<cfelse>
							<img src="#rootdir#wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						<cfif getCatOrder.maxorder NEQ sortorder AND DisplayFlag>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&nid=#newsid#&dir=down&name=sl_news', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="#rootdir#wsimages/down.gif" alt="Move Down" border="0"></a>
						<cfelse>
							<img src="#rootdir#wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						</td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
    </div>
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
