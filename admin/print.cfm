<!--- Bring in Style Sheet Elements --->
<cfinclude template="../css/docStyles.cfm">

<cfparam name="form.sortby" default="c.courtname, g.gametime">
<cfparam name="form.gDate" default="2006-11-12">
<cfparam name="form.lidsid" default="1,1">
<cfparam name="form.did" default="all">

<cfquery name="getGames" datasource="#memberDSN#">
	Select d.divname, d.gender, s.seasonname, l.leaguename, d.divlevel, d.gameperiods,
			d.gametos, d.game30tos, d.periodtos, d.period30tos, d.overtimetos,
			g.gamedate, g.gametime, loca.locationname, loca.shortname, c.courtname, g.h_teamid, g.v_teamid,
			ht.name as hteam, vt.name as vteam, ht.coachname as hcoach, vt.coachname as vcoach
	From sl_game g, sl_team ht, sl_team vt, sl_location loca, sl_court c, sl_division d, sl_season s, sl_league l
	Where g.gamedate = '#form.gDate#' and
			l.leagueid = #application.lid# and
			s.seasonid = #form.sid# and
		<cfif form.did NEQ "all">d.divid = #form.did# and</cfif>
			ht.teamid = g.h_teamid and
			vt.teamid = g.v_teamid and
			c.courtid = g.courtid and
			loca.locationid = g.locationid and
			d.divid = ht.divid and
			s.seasonid = d.seasonid and
			l.leagueid = s.leagueid
	Order By #sortby#
</cfquery>

<cfif isDefined("form.formatpdf")>
	<cfinclude template="scoresheet.cfm">
<cfelse>
<html>
<head>
<title>Sports League</title>
</head>
	<body onLoad="alert('Make sure you change the Page Orientation to Landscape before printing. Also set all your margins to .5 inches.');">
	<cfinclude template="scoresheet_bb.cfm">
	</body>
</html>
</cfif>
