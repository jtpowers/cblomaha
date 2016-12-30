<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="menu" default="">
<cfparam name="action" default="">

<cfquery name="getCategories" datasource="#application.memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'MenuSection' and LeagueID = #url.lid#
	Order by Value_4
</cfquery>

<cfquery name="getCatOrder" datasource="#application.memberDSN#">
	Select Min(value_4) as minorder, Max(value_4) as maxorder
	From sl_general_purpose
	Where name = 'MenuSection' and LeagueID = #url.lid#
</cfquery>

<cfset pageTitle = "Menu Sections">
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
			<a href="javascript:fPopWindow('sectionedit.cfm?lid=#url.lid#', 'custom','350','450','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Menu Section">Add Menu Section</a>
			</cfoutput>
			<table class="table table-condensed table-bordered">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center">Section Code</td>
					<td class="titlesmw" align="center">Menu Display</td>
					<td class="titlesmw" align="center">Long Name</td>
					<td class="titlesmw" align="center">Menu</td>
					<td class="titlesmw" align="center">Homepage</td>
					<td class="titlesmw" align="center">Password</td>
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
							<a href="javascript:fPopWindow('sectionedit.cfm?lid=#url.lid#&cat=#value_1#', 'custom','350','450','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Menu Section">
							#value_1#
							</a>
						</td>
						<td class="small">#value_2#</td>
						<td class="small">#value_3#</td>
						<td class="small" align="center"><cfif value_5 EQ 1>Yes<cfelse>No</cfif></td>
						<td class="small" align="center"><cfif value_6 EQ 1>Yes<cfelse>No</cfif></td>
						<td class="small" align="center">#Password#&nbsp;</td>
						<td class="small" align="center">
						<cfif getCatOrder.minorder NEQ value_4>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&cat=#value_1#&dir=up&name=MenuSection', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="#rootdir#wsimages/up.gif" alt="Move Up" border="0"></a>
						<cfelse>
							<img src="#rootdir#wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						<cfif getCatOrder.maxorder NEQ value_4>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&cat=#value_1#&dir=down&name=MenuSection', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="#rootdir#wsimages/down.gif" alt="Move Down" border="0"></a>
						<cfelse>
							<img src="#rootdir#wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						</td>
						<td class="small"><a href="sectionitems.cfm?lid=#url.lid#&cat=#value_1#" CLASS="linksm" title="View Page List">Page List</a></td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
    </div>
	<div class="clearfix col-md-1 col-xs-hidden col-sm-hidden"></div>
</div></div>
<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
