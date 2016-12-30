<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="action" default="">

<cfif isDefined("url.did")><cfset form.did = url.did></cfif>

<cfquery name="getSeasons" datasource="#application.memberDSN#">
	Select seasonid, seasonname
	From sl_season
	Where leagueid = #url.lid#
	Order by startdate desc, seasonname
</cfquery>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfquery name="getDivisions" datasource="#application.memberDSN#">
	Select d.divname, d.gender, d.divid
	From sl_division d
	Where d.seasonID = #form.sid#
	Order by divorder, divname
</cfquery>
<cfif form.sid NEQ sidCookie>
	<cfset form.did = getDivisions.divid[1]>
</cfif>
<cfparam name="form.did" default="#getDivisions.divid#">

<cfif form.did gt "">
	<cfquery name="getTeams" datasource="#application.memberDSN#">
		Select t.*, d.divname, d.gender
		From sl_team t, sl_division d
		Where d.divid = t.divid
			and t.divid = #form.did#
		Order by t.leaguenbr, t.Name
	</cfquery>
</cfif>

<cfset pageTitle = "Team Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
    <div class="col-md-8">
<table class="table table-condensed no-border">
	<form action="team.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
	<tr>
		<td align="center">
			<label>Season:</label>
			<select name="sid" class="small" onChange="submit();">
			<cfoutput query="getSeasons">
				<option value="#SeasonID#"<cfif SeasonID EQ form.sid> SELECTED</cfif>>#SeasonName#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
<cfif form.did gt "">
	<tr>
		<td align="center" class="smallb">
			Division:
			<select name="did" class="small" onChange="submit();">
			<cfoutput query="getDivisions">
				<option value="#divid#"<cfif form.did EQ divid> SELECTED</cfif>>#gender# #divname#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
</cfif>
	</form>
<cfif form.did gt "">
	<tr>
		<td valign="top">
			<a href="javascript:fPopWindow('teamedit.cfm?lid=<cfoutput>#url.lid#&did=#form.did#</cfoutput>', 'custom','800','530','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">Add Team</a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:fPopWindow('teamcopy.cfm?lid=<cfoutput>#url.lid#&todid=#form.did#</cfoutput>', 'custom','800','300','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">Copy Team/Players to this Division</a>
			<table class="table table-condensed table-bordered">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw">#</td>
					<td class="titlesmw">Name</td>
					<td class="titlesmw hidden-xs">Level</td>
					<td class="titlesmw">Division</td>
					<td class="titlesmw hidden-xs">Coach</td>
					<td class="titlesmw hidden-xs">Phone</td>
					<td class="titlesmw hidden-xs">Email</td>
					<td class="titlesmw">&nbsp;</td>
					<td class="titlesmw">&nbsp;</td>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getTeams">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="#rColor#">
						<td class="small">#leaguenbr#&nbsp;</td>
						<td class="small"><a href="javascript:fPopWindow('teamedit.cfm?lid=#url.lid#&tid=#Teamid#', 'custom','800','530','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">#name#&nbsp;</a></td>
						<td class="small hidden-xs">#level#&nbsp;</td>
						<td class="small">#gender# #divname#</td>
						<td class="small hidden-xs">#coachname#&nbsp;</td>
						<td class="small hidden-xs">#phone#&nbsp;</td>
						<td class="small hidden-xs">
							<cfif LEN(email) GT 0>
								<a href="mailto::#email#">#email#</a>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td class="small"><a href="player.cfm?lid=#url.lid#&tid=#Teamid#&did=#form.did#" class="linksm">Players</a></td>
						<td class="small"><a href="game.cfm?lid=#url.lid#&tid=#Teamid#&did=#form.did#" class="linksm">Games</a></td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
<cfelse>
	<tr>
		<td colspan="2" align="left" class="titlesub">
			<br>No Divisions have been created for this Season Yet.
		</td>
	</tr>
</cfif>
</table>
    </div>
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
