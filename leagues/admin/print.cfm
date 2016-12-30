<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<!--- Bring in Style Sheet Elements --->
<!--- <cfinclude template="#rootDir#css/docStyles.cfm"> --->
<cfset smallb = "font-family: Verdana,Arial,Helvetica,sans-serif; font-weight: bold; font-size: 8 pt;">
<cfset small = "font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 8 pt;">
<cfset xsmall = "font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 6 pt;">
<cfset xsmallb = "font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 6 pt; font-weight: bold;">
<cfset titlesub = "font-family: Verdana,Arial,Helvetica,sans-serif;	font-size: 10 pt; font-weight: bold;">
<cfset titlemain = "font-family: Verdana,Arial,Helvetica, ans-serif; font-weight: bold; font-size: 16 pt;">

<cfparam name="form.sortby" default="loca.shortname, c.courtname, g.gametime">
<cfparam name="form.gDate" default="2006-11-12">
<cfparam name="form.lidsid" default="1,1">
<cfparam name="form.did" default="all">

<cfquery name="getGames" datasource="#application.memberDSN#">
	Select d.divname, d.gender, s.seasonname, l.leaguename, d.divlevel, d.gameperiods,
			d.gametos, d.game30tos, d.periodtos, d.period30tos, d.overtimetos,
			g.gamedate, g.gametime, loca.locationname, loca.shortname, c.courtname, g.h_teamid, g.v_teamid,
			ht.name as hteam, vt.name as vteam, ht.coachname as hcoach, vt.coachname as vcoach
	From sl_game g, sl_team ht, sl_team vt, sl_location loca, sl_court c, sl_division d, sl_season s, sl_league l
	Where g.gamedate = '#form.gDate#' and
			l.leagueid = #url.lid# and
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

<LINK rel=\"stylesheet\" type=\"text/css\" href=\"<cfoutput>#rootDir#</cfoutput>css/scoresheet.css\">
<!---<style type="text/css">
	.small { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 16 pt; }
	.smallb { font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 8 pt; }
	.xsmall { font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 6 pt; }
	.xsmallb { font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 6 pt; font-weight: bold; }
	.titlesub { font-family: Verdana,Arial,Helvetica,sans-serif;	font-size: 10 pt; font-weight: bold; }
	.titlemain { font-family: Verdana,Arial,Helvetica, ans-serif; font-weight: bold; font-size: 16 pt; }
	table.applicant-break {page-break-before:always;}
	hr.applicant-break {page-break-before:always;}
</style>--->

<title>Sports League</title>
</head>
	<body onLoad="alert('Make sure you change the Page Orientation to Landscape before printing. Also set all your margins to .5 inches.');">
	<cfinclude template="scoresheet_bb.cfm">
	</body>
</html>
</cfif>
