<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="url.tid" default="all">
<cfparam name="url.gDate" default="all">
<cfparam name="url.sortby" default="g.gamedate, g.gametime, ht.name">
<cfparam name="url.rid" default="all">

<cfif isDefined("url.sid")>
	<cfset form.sid = url.sid>
</cfif>

<cfquery name="getSeasons" datasource="#application.memberDSN#">
	Select seasonid, seasonname
	From sl_season
	Where leagueid = #url.lid#
	Order by startdate desc, seasonname
</cfquery>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfif url.tid NEQ "all">
	<cfif form.sid NEQ sidCookie>
		<cfquery name="getTeam" datasource="#application.memberDSN#">
		Select t.teamid, d.seasonid, t.divid
		From sl_team t, sl_division d
		Where d.divid = t.divid and d.seasonid = #form.sid#
		Order By t.leaguenbr, t.Name
		</cfquery>
		<cfset url.did = getTeam.divid[1]>
		<cfset url.tid = getTeam.teamid[1]>
	<cfelse>
		<cfquery name="getTeam" datasource="#application.memberDSN#">
		Select t.teamid, d.seasonid, t.divid
		From sl_team t, sl_division d
		Where teamid = #url.tid# and d.divid = t.divid
		</cfquery>
		<cfset url.did = getTeam.divid>
		<cfset form.sid = getTeam.seasonid>
	</cfif>
	
<cfelse>
	<cfquery name="getDivs" datasource="#application.memberDSN#">
		Select l.leagueid, l.leaguename, s.seasonid, s.seasonname, d.divid, d.divname, d.gender
		From sl_league l, sl_season s, sl_division d
		Where s.seasonid = d.seasonid and
				l.leagueid = s.leagueid and
				s.seasonid = #form.sid#
		Order By LeagueName, StartDate, DivOrder, DivName
	</cfquery>
	<cfif (form.sid NEQ sidCookie) OR Not isDefined("url.did")>
		<cfset url.did="#getDivs.divid#">
	</cfif>
	<cfquery name="getGameDates" datasource="#application.memberDSN#">
		Select gamedate
		From sl_game g, sl_division d, sl_team t
		Where d.seasonid = #form.sid# and g.H_teamid = t.teamid and t.divid = d.divid
		Group by gamedate
		Order by gamedate
	</cfquery>
	<cfquery name="getRefs" datasource="#application.memberDSN#">
		Select RefID, RefName
		From sl_referee
		Where leagueid = #url.lid#
		Order By RefName
	</cfquery>
</cfif>
<cfquery name="getTeams" datasource="#application.memberDSN#">
	Select t.teamid, t.name, d.divname, d.gender, d.divid, s.seasonname, l.leaguename, t.leaguenbr
	From sl_team t, sl_division d, sl_season s, sl_league l
	Where d.divid = t.divid and 
			s.seasonid = d.seasonid and 
			l.leagueid = s.leagueid and
			s.seasonid = #form.sid#
	Order by l.leaguename, s.seasonname, d.divname, t.leaguenbr, t.Name
</cfquery>
<cfquery name="getGames" datasource="#application.memberDSN#">
	Select d.divname, d.divid, d.gender, s.seasonname, l.leaguename, l.leagueid, g.gametype, g.status, gs.value_2 as gamestatus,
			g.gamedate, g.gametime, g.endtime, loca.shortname, c.courtname, g.h_teamid, g.v_teamid, g.h_points, g.v_points, g.gamenbr,
			ht.name as hteam, ht.leaguenbr as hlnbr, g.gameid, g.refid_1, g.refid_2
			<cfif application.sl_leaguetype EQ "League">, vt.name as vteam, vt.leaguenbr as vlnbr
			<cfelse>, g.opponent as vteam, null as vlnbr</cfif>
	From sl_game g, sl_team ht, sl_location loca, sl_court c, sl_division d, sl_season s, sl_league l,
				(select value_1, value_2 from sl_general_purpose where name = 'GameStatus') gs
		<cfif application.sl_leaguetype EQ "League">, sl_team vt</cfif>
	Where 
		<cfif url.tid NEQ "all">
			(g.h_teamid = #url.tid# or g.v_teamid = #url.tid#) and
		<cfelse>
			<cfif url.gDate EQ "all">
			<cfelseif url.gDate EQ "current">
				g.gamedate >= '#DateFormat(Now(), "YYYY-MM-DD")#' and
			<cfelse>
				g.gamedate = '#url.gDate#' and
			</cfif>
			<cfif url.did NEQ "all">d.divid = #url.did# and</cfif>
		</cfif>
		<cfif url.rid NEQ "all">
			(g.refid_1 = #url.rid# or g.refid_2 = #url.rid#) and
		</cfif>
			ht.teamid = g.h_teamid and
		<cfif application.sl_leaguetype EQ "League">
			vt.teamid = g.v_teamid and
		</cfif>
			c.courtid = g.courtid and
			loca.locationid = g.locationid and
			gs.value_1 = g.status and
			d.divid = ht.divid and
			s.seasonid = d.seasonid and
			l.leagueid = s.leagueid and
			s.seasonid = #form.sid#
	Order By #url.sortby#
</cfquery>

<cfif application.sl_leaguetype EQ "League">
	<cfset editPgm = "gameedit.cfm">
<cfelse>
	<cfset editPgm = "gameedit2.cfm">
</cfif>

<cfset pageTitle = "Edit Games">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-1 col-xs-hidden col-sm-hidden"></div>
    <div class="col-md-10">
<table class="table table-condensed no-border">
	<tr>
		<td align="center">
			<cfoutput>
			<form action="game.cfm?lid=#url.lid#&tid=#url.tid#" method="post">
			</cfoutput>
			<table>
			<tr>
				<td class="smallb">Season:</td>
				<td>
					<select name="sid" class="small" onChange="document.forms[0].submit();">
					<cfoutput query="getSeasons">
						<option value="#SeasonID#"<cfif SeasonID EQ form.sid> SELECTED</cfif>>#SeasonName#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
			</table>
			</form>
		</td>
	</tr>
	<tr>
		<td align="center">
		<form action="gamesubmit.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
			<input type="hidden" name="sid" value="<cfoutput>#form.sid#</cfoutput>">
			<table class="table table-condensed table-bordered">
			<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>"><td class="titlesmw">Search Criteria</td></tr>
			<tr><td align="center">
			<cfif url.tid EQ "all">
				<table class="table table-condensed no-border">
				<tr>
					<td class="smallb">Division:</td>
					<td>
						<select name="did" class="small">
							<option value="all"<cfif url.did EQ "all"> selected</cfif>>All</option>
						<cfoutput query="getDivs">
							<option value="#divid#"<cfif url.did EQ divid> selected</cfif>>#gender# #divname#</option>
						</cfoutput>
						</select>
					</td>
					<td class="smallb">Game Date:</td>
					<td>
						<select name="gDate" class="small">
							<option value="all"<cfif url.gDate EQ "all"> selected</cfif>>All</option>
							<option value="current"<cfif url.gDate EQ "current"> selected</cfif>>Current Only</option>
						<cfoutput query="getGameDates">
							<option value="#DateFormat(gamedate, 'yyyy-mm-dd')#"<cfif url.gDate EQ DateFormat(gamedate, 'yyyy-mm-dd')> selected</cfif>>#DateFormat(gamedate, 'ddd, mm/dd/yyyy')#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">Team:</td>
					<td>
						<select name="tid" class="small">
							<option value="all"<cfif url.tid EQ "all"> selected</cfif>>All</option>
						<cfoutput query="getTeams">
							<option value="#teamid#"<cfif url.tid EQ teamid> selected</cfif>><cfif leaguenbr GT "">#leaguenbr#. </cfif>#name#</option>
						</cfoutput>
						</select>
					</td>
					<td class="smallb">Sort By:</td>
					<td>
						<select name="sortby" class="small">
							<option value="loca.shortname, c.courtname, g.gamedate, g.gametime"<cfif url.sortby EQ "c.courtname, g.gamedate, g.gametime"> selected</cfif>>Court & Game Date/Time</option>
							<option value="d.divid"<cfif url.sortby EQ "d.divid"> selected</cfif>>Division</option>
							<option value="g.gamedate, g.gametime, ht.name"<cfif url.sortby EQ "g.gamedate, g.gametime, ht.name"> selected</cfif>>Game Date/Time</option>
						</select>
					</td>
					<td>
						<input type="submit" name="go" value="Go" class="small">
					</td>
				</tr>
				</table>
			<cfelse>
				<input type="hidden" name="did" value="<cfoutput>#url.did#</cfoutput>">
				<table>
				<tr>
					<td class="smallb">Team:</td>
					<td>
						<select name="tid" class="small">
							<option value="all"<cfif url.tid EQ "all"> selected</cfif>>All</option>
						<cfoutput query="getTeams">
							<option value="#teamid#"<cfif url.tid EQ teamid> selected</cfif>><cfif leaguenbr GT "">#leaguenbr#. </cfif>#name#</option>
						</cfoutput>
						</select>
					</td>
					<td>
						<input type="submit" name="go" value="Go" class="small">
					</td>
				</tr>
				</table>
			</cfif>
			</td></tr></table>
		</form>
		</td>
	</tr>
<cfif useraccesslevel GTE 5>
	<tr>
		<td valign="top" align="center">
			<cfoutput>
			<cfif url.did NEQ "all">
					<a href="javascript:fPopWindow('#editPgm#?lid=#url.lid#&divid=#url.did#', 'custom','450','450','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Add One Game">Add Single Game</a>
				&nbsp;&nbsp;&nbsp;
			<cfif application.sl_leaguetype EQ "League">
			<a href="gameeditdiv.cfm?lid=#url.lid#&did=#url.did#&gdate=#url.gDate#" class="linksm" title="Add Multiple Games for a Division">Add Games by Division</a>
			</cfif>
            <cfelse>
            	<span class="small">Must select a Division to Add Games</span>
			</cfif>
			</cfoutput>
		</td>
	</tr>
</cfif>
	<tr>
		<td valign="top" align="center">
    		<table class="table table-hover table-bordered table-striped table-condensed">
        	<thead>
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<th class="text-center titlesmw">Date/Time</th>
					<th class="text-center titlesmw hidden-xs hidden-sm">Type</th>
					<th class="text-center titlesmw hidden-xs">Status</th>
					<th class="text-center titlesmw"><cfif application.sl_leaguetype EQ "League">Visitor Team<cfelse>Opponent</cfif></th>
					<th class="text-center titlesmw"><cfif application.sl_leaguetype EQ "League">Home Team<cfelse>Team</cfif></th>
					<th class="text-center titlesmw">Score</th>
					<th class="text-center titlesmw">Location</th>
				</tr>
			</thead>
			<tbody>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getGames">
					<tr>
						<td>
						<cfif useraccesslevel GTE 5>
							<a href="javascript:fPopWindow('#editPgm#?lid=#url.lid#&gid=#gameid#&divid=#url.did#&action=Update', 'custom','450','450','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Edit Game">
						</cfif>
							#DateFormat(GameDate, "mm/dd/yyyy")#
							#TimeFormat(GameTime, "h:mm tt")#<cfif EndTime GT "">-#TimeFormat(EndTime, "h:mm tt")#</cfif>
						<cfif useraccesslevel GTE 5>
							</a>
						</cfif>
						</td>
						<td class="hidden-xs hidden-sm small">#gametype#&nbsp;</td>
						<td class="hidden-xs small">#gamestatus#</td>
						<td<cfif H_Points LT V_Points> class="smallb"<cfelse> class="small"</cfif>>
							<cfif LEN(vlnbr) GT 0>#vlnbr#. </cfif>#vteam#&nbsp;
						</td>
						<td<cfif H_Points GT V_Points> class="smallb"<cfelse> class="small"</cfif>>
							<cfif LEN(hlnbr) GT 0>#hlnbr#. </cfif>#hteam#
						</td>
						<td align="center">
						<cfif gametype EQ "Game">
						<a href="javascript:fPopWindow('gameresult2.cfm?lid=#url.lid#&gid=#gameid#', 'custom','550','620','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Edit Game Results">
						<cfif H_Points GT "">
							#V_Points# - #H_Points#
						<cfelse>
							edit results
						</cfif>
						</a>
						<cfelse>
							&nbsp;
						</cfif>
						</td>
						<td class="small">#shortname# - #courtname#</td>
					</tr>
				</cfoutput>
				</tbody>
			</table>
		</td>
	</tr>
</table>
    </div>
	<div class="clearfix col-md-1 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
