<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfparam name="action" default="">

<cfquery name="getSeasons" datasource="#application.memberDSN#">
	Select s.*, l.leagueid, l.leaguename
	From sl_season s, sl_league l
	Where s.leagueid = l.leagueid and l.leagueid = #url.lid#
	Order by startdate desc
</cfquery>
<cfquery name="getLeagues" datasource="#application.memberDSN#">
	Select *
	From sl_league
	Where leagueid = #url.lid#
	Order by LeagueName
</cfquery>

<cfset pageTitle = "#application.sl_name# - Season Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
    <div class="col-xs-12 col-md-8">

<table class="table table-condensed no-border">
	<tr>
		<td valign="top">
			<a href="javascript:fPopWindow('seasonedit.cfm?lid=<cfoutput>#url.lid#</cfoutput>', 'custom','300','230','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Season">Add Season</a>
			<table class="table table-condensed table-bordered">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw">Name</td>
					<td class="titlesmw">Start Date</td>
					<td class="titlesmw">Deadline</td>
					<td class="titlesmw">League</td>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getSeasons">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="#rColor#">
						<td class="small"><a href="javascript:fPopWindow('seasonedit.cfm?lid=#url.lid#&sid=#seasonid#', 'custom','300','230','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Season">#SeasonName#</a></td>
						<td class="small">#DateFormat(StartDate, "mm/dd/yyyy")#&nbsp;</td>
						<td class="small">#DateFormat(DeadlineDate, "mm/dd/yyyy")#&nbsp;</td>
						<td class="small">#leaguename#</td>
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
