<cfset rootDir = "../../">
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
	<cfquery name="UpdateGame" datasource="#memberDSN#">
		Update sl_game
		Set H_Points = <cfif LEN(u_hpoints) GT 0>#u_hpoints#<cfelse>NULL</cfif>, 
				V_Points = <cfif LEN(u_vpoints) GT 0>#u_vpoints#<cfelse>NULL</cfif>
		Where GameID = #url.gid#
	</cfquery>
	<cfset message = "Game Updated">
	<cfset done = 1>
</cfif>

<cfquery name="getGame" datasource="#memberDSN#">
	Select d.divname, d.gender, d.divid, s.seasonname, l.leaguename, l.leagueid,
			g.gamedate, g.gametime, loca.locationname, c.courtname,
			g.h_teamid, g.v_teamid, g.h_points, g.v_points, g.courtid, g.locationid,
			ht.name as hteam, ht.leaguenbr as hlnbr, g.gameid
		<cfif application.sl_leaguetype EQ "League">, vt.name as vteam, vt.leaguenbr as vlnbr
			<cfelse>, g.opponent as vteam, null as vlnbr</cfif>	
	From sl_game g, sl_team ht, sl_location loca, sl_court c, sl_division d, sl_season s, sl_league l
			<cfif application.sl_leaguetype EQ "League">, sl_team vt</cfif>
	Where 
			g.gameid = #url.gid# and
			ht.teamid = g.h_teamid and
		<cfif application.sl_leaguetype EQ "League">
			vt.teamid = g.v_teamid and
		</cfif>
			c.courtid = g.courtid and
			loca.locationid = g.locationid and
			d.divid = ht.divid and
			s.seasonid = d.seasonid and
			l.leagueid = s.leagueid
</cfquery>

<cfquery name="getDivision" datasource="#memberDSN#">
	Select l.leagueid, l.leaguename, s.seasonid, s.seasonname, d.divid, d.divname, d.gender
	From sl_league l, sl_season s, sl_division d
	Where s.seasonid = d.seasonid and
			l.leagueid = s.leagueid and
			d.divid = #getGame.divid#
</cfquery>

<cfset tvpPoints = 0>
<cfset thpPoints = 0>

<cfset pageTitle = "#application.sl_leaguename# - Game Results">
<html>
<head>
	<cfinclude template="#rootDir#ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.history.go(0);
			window.close();
		  }
		}
	</script>
</head>

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfset onloadattr = "document.forms(0).u_vpoints.focus();">
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">

<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center" colspan="2">
		<cfoutput>#application.sl_name#<br>
		#application.sl_leaguename#<br></cfoutput>Game Results
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
</cfif>
<cfform action="gameresult.cfm?gid=#url.gid#" method="post" name="gameform">
<input type="hidden" name="process" value="go">
<input type="hidden" name="v_teamid" value="<cfoutput>#getGame.v_teamid#</cfoutput>">
<input type="hidden" name="h_teamid" value="<cfoutput>#getGame.h_teamid#</cfoutput>">

<tr><td valign="top" align="center" colspan="2">
	<table cellpadding="2" cellspacing="0" border="1"><tr><td>
		<table cellpadding="3" cellspacing="0">
			<tr>
				<td class="smallb"><cfoutput>#getGame.vlnbr#. #getGame.vteam#:</cfoutput></td>
				<td class="small">
					<cfinput type="text" name="u_vpoints" message="#getGame.vteam# team points must be a Number." validate="integer" required="no" class="small" value="#getGame.V_Points#" size="4">
				</td>
			</tr>
			<tr>
				<td class="smallb"><cfoutput>#getGame.hlnbr#. #getGame.hteam#:</cfoutput></td>
				<td class="small">
					<cfinput type="text" name="u_hpoints" message="#getGame.hteam# team points must be a Number." validate="integer" required="no" class="small" value="#getGame.h_Points#" size="4">
				</td>
			</tr>
		</table>
	</td></tr></table>
</td></tr>

<tr><td align="center" colspan="2" class="small">
		<input type="submit" name="submit" value="Update Game" class="small">
		<input type="reset" class="small">
</td></tr>
<tr><td align="center" colspan="2" class="small">
	<input type="button" name="close" value="Close Window" onClick="closeRefresh();" class="small">
</td></tr>
</cfform>
</table>
</body>
</html>
