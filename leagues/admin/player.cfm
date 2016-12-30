<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfif isDefined("url.did")><cfset form.did = url.did></cfif>
<cfif isDefined("url.tid")><cfset form.tid =  url.tid></cfif>

<cfparam name="menu" default="">
<cfparam name="action" default="">
<cfset erMsg = "">

<cfif isDefined("form.u_tid")>
	<cfset form.tid = form.u_tid>
<cfelseif isDefined("form.a_tid")>
	<cfset form.tid = form.a_tid>
</cfif>

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
<cfif getDivisions.RecordCount EQ 0>
	<cfset erMsg = "No divisions have been setup for this season.">
</cfif>
<cfif form.sid NEQ sidCookie>
	<cfset form.did = getDivisions.divid[1]>
</cfif>
<cfparam name="form.did" default="#getDivisions.divid#">
<cfif erMsg EQ "">
	<cfquery name="getTeams" datasource="#application.memberDSN#">
		Select Name, TeamID, Level, LeagueNbr
		From sl_team
		Where divid =  #form.did#
		Order by LeagueNbr, Name
	</cfquery>
	<cfif getTeams.RecordCount EQ 0>
		<cfset erMsg = "No Teams have been setup for this season and division.">
	</cfif>
	<cfif form.sid NEQ sidCookie>
		<cfset form.tid = getTeams.teamid[1]>
	</cfif>
	<cfparam name="form.tid" default="#getTeams.teamid[1]#">
	<cfif erMsg EQ "">
		<cfquery name="getPlayers" datasource="#application.memberDSN#">
			Select p.*, t.Name, d.seasonid
			From sl_player p, sl_team t, sl_division d
			Where t.TeamID = p.TeamID and
					d.divid = t.divid and
					p.TeamID =  #form.tid#
			Order by Alternate, JerseyNbr, playername
		</cfquery>
	</cfif>
</cfif>
<cfset pageTitle = "Player Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
    <div class="col-md-8">
<cfif erMsg EQ "">
<table class="table table-condensed no-border">
	<form action="player.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
	<tr>
		<td align="right" class="smallb">Season:</td>
		<td>
			<select name="sid" class="small" onChange="document.forms[0].submit();">
			<cfoutput query="getSeasons">
				<option value="#SeasonID#"<cfif SeasonID EQ form.sid> SELECTED</cfif>>#SeasonName#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td align="right" class="smallb">Division:</td>
		<td>
			<select name="did" class="small" onChange="submit();">
			<cfoutput query="getDivisions">
				<option value="#divid#"<cfif form.did EQ divid> SELECTED</cfif>>#gender# #divname#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td align="right" class="smallb">Team:</td>
		<td>
			<select name="tid" class="small" onChange="document.forms[0].submit();">
			<cfoutput query="getTeams">
				<option value="#TeamID#"<cfif TeamID EQ form.tid> SELECTED</cfif>>#LeagueNbr#. #Name# </option>
			</cfoutput>
			</select>
		</td>
	</tr>
	</form>
	<tr>
		<td valign="top" align="center" colspan="2">
			<cfoutput>
			<a href="javascript:fPopWindow('playeredit.cfm?lid=#url.lid#&tid=#form.tid#&sid=#form.sid#', 'custom','420','500','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">Add Player</a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:fPopWindow('playeradds.cfm?lid=#url.lid#&tid=#form.tid#&sid=#form.sid#', 'custom','430','600','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">Add Multiple Players</a>
			</cfoutput>
			<table class="table table-condensed table-bordered">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw">#</td>
					<td class="titlesmw">Name</td>
					<td class="titlesmw hidden-xs">Phone #</td>
					<td class="titlesmw hidden-xs">Email</td>
					<td class="titlesmw hidden-xs hidden-sm">Contact</td
					><td class="titlesmw hidden-xs hidden-sm">Contact Phone #</td>
				</tr>
				<cfset alternates = 0>
				<cfoutput query="getPlayers">
					<cfif getPlayers.alternate EQ 1 AND alternates EQ 0>
						<tr>
							<td class="smallb" colspan="3" align="center">Alternates</td>
						</tr>
						<cfset alternates = 1>
					</cfif>
					<tr>
						<td class="small"><cfif  jerseynbr LT 999>#jerseynbr#</cfif>&nbsp;</td>
						<td><a href="javascript:fPopWindow('playeredit.cfm?lid=#url.lid#&pid=#playerid#&sid=#seasonid#', 'custom','420','500','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">#playername#</a></td>
						<td class="small hidden-xs">#PhoneNbr#&nbsp;</td>
						<td class="small hidden-xs">#Email#&nbsp;</td>
						<td class="small hidden-xs hidden-sm">#Contacts#&nbsp;</td>
						<td class="small hidden-xs hidden-sm">#ContactsPhone#&nbsp;</td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
<cfelse>
	<table class="table table-condensed no-border">
	<form action="player.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
	<tr>
		<td align="right" class="smallb">Season:</td>
		<td>
			<select name="sid" class="small" onChange="submit();">
			<cfoutput query="getSeasons">
				<option value="#SeasonID#"<cfif SeasonID EQ form.sid> SELECTED</cfif>>#SeasonName#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
	</form>
	</table>
	<cfoutput>#erMsg#</cfoutput>
</cfif>
    </div>
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
