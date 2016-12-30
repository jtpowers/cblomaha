<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="url.action" default="Add">
<cfparam name="url.lid" default="1">
<cfif isDefined("form.gid")><cfset url.gid = form.gid></cfif>
<cfset message = "">
<cfset done = 0>
<cfset isSelected = "">
<cfset gMonth = DateFormat(Now(), "m")>
<cfset gDay = DateFormat(Now(), "d")>
<cfset gYear = DateFormat(Now(), "yyyy")>
<cfset gHour = "12">
<cfset gMinute = "00">
<cfset gTMarker = "p">

<cfif isDefined("form.process")>
	<cfquery name="UpdateGame" datasource="#application.memberDSN#">
		Update sl_game
		Set H_Points = <cfif LEN(u_hpoints) GT 0>#u_hpoints#<cfelse>NULL</cfif>, 
				V_Points = <cfif LEN(u_vpoints) GT 0>#u_vpoints#<cfelse>NULL</cfif>
		Where GameID = #url.gid#
	</cfquery>
	<cftransaction>
		<cfquery name="deleteGamePlayer" datasource="#application.memberDSN#">
			Delete
			From sl_game_player
			Where GameID = #url.gid#
		</cfquery>
		<!--- Insert Vistor Players Points--->
		<cfquery name="getVisitorPlayers" datasource="#application.memberDSN#">
			Select playerid
			From sl_player
			Where teamid = #form.v_teamid#
		</cfquery>
		<cfloop query="getVisitorPlayers">
			<cfset vpPointsName = "u_vpoints#playerid#">
			<cfset vpPoints = Evaluate(vpPointsName)>
			<cfif isNumeric(vpPoints)>
				<cfquery name="insertGamePlayer" datasource="#application.memberDSN#">
					Insert Into sl_game_player (GameID, PlayerID, Points)
					Values (#url.gid#, #playerid#, #vpPoints#)
				</cfquery>
			</cfif>
		</cfloop>
		<!--- Insert Home Players Points--->
		<cfquery name="getHomePlayers" datasource="#application.memberDSN#">
			Select playerid
			From sl_player
			Where teamid = #form.h_teamid#
		</cfquery>
		<cfloop query="getHomePlayers">
			<cfset hpPointsName = "u_hpoints#playerid#">
			<cfset hpPoints = Evaluate(hpPointsName)>
			<cfif isNumeric(hpPoints)>
				<cfquery name="insertGamePlayer" datasource="#application.memberDSN#">
					Insert Into sl_game_player (GameID, PlayerID, Points)
					Values (#url.gid#, #playerid#, #hpPoints#)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
	<cfset done = 1>
	<cfset message = "Game Updated">
</cfif>

<cfquery name="getGame" datasource="#application.memberDSN#">
	Select d.divname, d.gender, d.divid, s.seasonname, l.leaguename, l.leagueid,
			g.gamedate, g.gametime, loca.locationname, c.courtname,
			g.h_teamid, g.v_teamid, g.h_points, g.v_points, g.courtid, g.locationid,
			ht.name as hteam, vt.name as vteam, ht.leaguenbr as hlnbr, vt.leaguenbr as vlnbr, g.gameid
	From sl_game g, sl_team ht, sl_team vt, sl_location loca, sl_court c, sl_division d, sl_season s, sl_league l
	Where 
			g.gameid = #url.gid# and
			ht.teamid = g.h_teamid and
			vt.teamid = g.v_teamid and
			c.courtid = g.courtid and
			loca.locationid = g.locationid and
			d.divid = ht.divid and
			s.seasonid = d.seasonid and
			l.leagueid = s.leagueid
</cfquery>

<cfquery name="getDivision" datasource="#application.memberDSN#">
	Select l.leagueid, l.leaguename, s.seasonid, s.seasonname, d.divid, d.divname, d.gender
	From sl_league l, sl_season s, sl_division d
	Where s.seasonid = d.seasonid and
			l.leagueid = s.leagueid and
			d.divid = #getGame.divid#
</cfquery>

<cfquery name="getHPlayers" datasource="#application.memberDSN#">
	Select p.playerid, p.playername, p.jerseynbr, gp.points
	From sl_player p LEFT JOIN sl_game_player gp
							ON gp.playerid = p.playerid and gp.gameid = #url.gid#
	Where p.teamid = #getGame.h_teamid#
	Order by p.alternate, p.jerseynbr, p.playername
</cfquery>

<cfquery name="getVPlayers" datasource="#application.memberDSN#">
	Select p.playerid, p.playername, p.jerseynbr, gp.points
	From sl_player p LEFT JOIN sl_game_player gp
							ON gp.playerid = p.playerid and gp.gameid = #url.gid#
	Where p.teamid = #getGame.v_teamid#
	Order by p.alternate, p.jerseynbr, p.playername
</cfquery>

<cfset tvpPoints = 0>
<cfset thpPoints = 0>
<cfloop query="getVPlayers">
	<cfif isNumeric(Points)><cfset tvpPoints = tvpPoints + Points></cfif>
</cfloop>
<cfloop query="getHPlayers">
	<cfif isNumeric(Points)><cfset thpPoints = thpPoints + Points></cfif>
</cfloop>

<cfset pageTitle = "Game Results">
<cfinclude template="#rootdir#ssi/header.cfm">
	<script language="javascript">
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.history.go(0);
			window.close();
		  }
		}
	</script>

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfset onloadattr = "document.forms[0].u_vpoints.focus();">
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0"<cfif done> onload="closeRefresh();"</cfif>>

<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center" colspan="2">
		<cfoutput>#application.sl_name#<br></cfoutput>Game Results
	</td>
</tr>
<tr><td valign="top" align="center" class="titlesub" colspan="2">
<cfoutput>
#getDivision.seasonname# - #getDivision.gender# #getDivision.divname#<br>
#Dateformat(getGame.gamedate, "mm/dd/yyyy")# at #TimeFormat(getGame.gametime, "hh:mm tt")#
</cfoutput>
</td></tr>
<cfif tvpPoints GT 0 OR thpPoints GT 0>
	<cfif message GT "">
	<cfoutput>
		<tr><td valign="top" align="center" class="smallr" colspan="2">
		#message#
		</td></tr>
	</cfoutput>
	</cfif>
	<cfif tvpPoints NEQ getGame.V_Points>
	<cfoutput>
		<tr><td valign="top" align="center" class="smallr" colspan="2">
		#getGame.vteam# Player points (#tvpPoints#) don't add up to team score (#getGame.V_Points#).
		</td></tr>
	</cfoutput>
	</cfif>
	<cfif thpPoints NEQ getGame.H_Points>
	<cfoutput>
		<tr><td valign="top" align="center" class="smallr" colspan="2">
		#getGame.hteam# Player points (#thpPoints#) don't add up to team score (#getGame.H_Points#).
		</td></tr>
	</cfoutput>
	</cfif>
</cfif>
<cfform action="gameresult2.cfm?lid=#url.lid#&gid=#url.gid#" method="post" name="gameform">
<input type="hidden" name="process" value="go">
<input type="hidden" name="v_teamid" value="<cfoutput>#getGame.v_teamid#</cfoutput>">
<input type="hidden" name="h_teamid" value="<cfoutput>#getGame.h_teamid#</cfoutput>">

<tr><td valign="top" align="center" colspan="2">
	<table class="table table-condensed table-bordered"><tr><td>
		<table class="table table-condensed no-border">
			<tr>
				<td class="smallb"><cfoutput>#getGame.vteam#:</cfoutput></td>
				<td class="small">
					<cfinput type="text" name="u_vpoints" message="#getGame.vteam# team points must be a Number." validate="integer" required="no" class="small" value="#getGame.V_Points#" size="4">
				</td>
			</tr>
			<tr>
				<td class="smallb"><cfoutput>#getGame.hteam#:</cfoutput></td>
				<td class="small">
					<cfinput type="text" name="u_hpoints" message="#getGame.hteam# team points must be a Number." validate="integer" required="no" class="small" value="#getGame.h_Points#" size="4">
				</td>
			</tr>
		</table>
	</td></tr></table>
</td></tr>

<tr>
	<td class="titlesub" align="center" valign="top">
	<cfoutput>#getGame.vteam#</cfoutput>
	<table class="table table-condensed table-bordered"><tr><td>
		<table class="table table-condensed no-border">
			<tr bgcolor="#999999">
				<td class="smallb">#</td>
				<td class="smallb">Name</td>
				<td class="smallb" align="center">Pts.</td>
			</tr>
			<cfset bgcolor="FFFFFF">
			<cfoutput query="getVPlayers">
			<tr bgcolor="#bgcolor#">
				<td class="small"><cfif  jerseynbr LT 999>#jerseynbr#</cfif>&nbsp;</td>
				<td class="small"><a href="javascript:fPopWindow('playeredit.cfm?pid=#playerid#&game=1', 'custom','400','330','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="small"><cfif playername GT "">#playername#<cfelse>Unknown</cfif></a></td>
				<td class="small">
					<cfinput type="text" name="u_vpoints#playerid#" value="#points#" size="3" class="small" message="Player points must be a Number." validate="integer">
				</td>
			</tr>
			<cfif bgcolor EQ "DDDDDD"><cfset bgcolor="FFFFFF"><cfelse><cfset bgcolor = "DDDDDD"></cfif>
			</cfoutput>
		</table>
	</td></tr></table>
	</td>
	<td class="titlesub" align="center" valign="top">
	<cfoutput>#getGame.hteam#</cfoutput>
	<table class="table table-condensed table-bordered"><tr><td>
		<table class="table table-condensed no-border">
			<tr bgcolor="#999999">
				<td class="smallb">#</td>
				<td class="smallb">Name</td>
				<td class="smallb" align="center">Pts.</td>
			</tr>
			<cfset bgcolor="FFFFFF">
			<cfoutput query="getHPlayers">
			<tr bgcolor="#bgcolor#">
				<td class="small">#jerseynbr#</td>
				<td class="small"><a href="javascript:fPopWindow('playeredit.cfm?pid=#playerid#&game=1', 'custom','400','330','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="small"><cfif playername GT "">#playername#<cfelse>Unknown</cfif></a></td>
				<td class="small">
					<cfinput type="text" name="u_hpoints#playerid#" message="Player points must be a Number." validate="integer" class="small" value="#points#" size="3">
				</td>
			</tr>
			<cfif bgcolor EQ "DDDDDD"><cfset bgcolor="FFFFFF"><cfelse><cfset bgcolor = "DDDDDD"></cfif>
			</cfoutput>
		</table>
	</td></tr></table>
	</td>
</tr>
<tr><td align="center" colspan="2" class="small">
		<input type="submit" name="submit" value="Update Game" class="small">
		<input type="reset" class="small">
</td></tr>
<tr><td align="center" colspan="2" class="small">
	<input type="button" name="close" value="Close Window" class="small" onClick="closeRefresh();">
</td></tr>
</cfform>
</table>
</body>
</html>
