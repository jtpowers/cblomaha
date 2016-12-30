<cfset rootdir = "../">
<cfparam name="url.lid" default="">
<cfparam name="url.tid" default="all">
<cfparam name="url.format" default="html">
<cfparam name="url.gType" default="">

<cfif isDefined("url.year")>
	<cfset currentdate = "#dateformat('#url.year#-#url.month#-01')#">
</cfif>
<!--- set parameters --->
	<CFPARAM NAME="currentdate" DEFAULT="#dateformat(now())#">
	<CFPARAM NAME="currentMonth" DEFAULT="#month(currentdate)#">
	<CFPARAM NAME="currentYear" DEFAULT="#year(currentdate)#">
	<CFPARAM NAME="detail" DEFAULT="0">
	<CFPARAM NAME="FormDate" DEFAULT="#currentdate#">
	<CFPARAM NAME="ThisDate" DEFAULT="#FormDate#">
	<CFPARAM NAME="SelectedMonth" DEFAULT="#month(ThisDate)#">
	<CFPARAM NAME="SelectedYear" DEFAULT="#year(ThisDate)#">
	<CFSET FIRSTDAY= SelectedMonth & "/1/" & SelectedYear>
	<CFSET LASTDAY= SelectedMonth & "/" & #DAYSINMONTH(FIRSTDAY)# & "/" & SelectedYear >
	<CFSET FIRST_NN = #DAYOFWEEK(FIRSTDAY)# - 1>
	<CFSET LAST_NN = 7 - #DAYOFWEEK(LASTDAY)# >
	<CFSET Next_month = #dateformat(DateAdd("m",1,"#currentdate#"))#>
	<CFSET LAst_month = #dateformat(DateAdd("m",-1,"#currentdate#"))#>
<!--- end parameters --->


<cfquery name="getCal" datasource="#memberDSN#" dbtype="ODBC">
SELECT *
FROM sl_calendar
WHERE 	calendarID in (#url.calid#)
ORDER BY calOrder
</cfquery>
<cfif LEN(url.calid) GT 2>
	<cfset cName = "ALHS Boys & Girls">
<cfelse>
	<cfset cName = getCal.calName>
</cfif>
<cfquery name="getEvents" datasource="#memberDSN#" dbtype="ODBC">
SELECT eventdate, starttime, endtime, location, description, title, status, eventid, calendarid, 0 as locationid, '' as otherinfo, '' as gametype
FROM sl_calendar_event 
WHERE 	calendarID in (#url.calid#)
			AND (eventDate > '#DateFormat(LAst_month, "YYYY-MM")#-21'
					 AND eventDate < '#DateFormat(Next_month, "YYYY-MM")#-10')
			<cfif url.gType NEQ "all" AND url.gType NEQ "other">
				and 0 = 1
			</cfif>
ORDER BY eventDate, starttime, title
</cfquery>

<cfif application.sl_leaguetype EQ "League">
	<cfquery name="getGames" datasource="#memberDSN#">
		Select g.gamedate as eventdate, g.gametime as starttime, TIME(NULL) as endtime,
				CONCAT(loca.locationname, '-', IF(c.courtname is NULL, '',c.courtname)) as location,
				CONCAT(vt.name, ' vs ', ht.name) as description,
				CONCAT(d.gender, ' ', d.divname) as title,
				g.status, g.gameid as eventid, g.calendarid, loca.locationid,
				g.description as otherinfo, g.gametype
		From sl_game g, sl_team ht, sl_team vt, sl_location loca, sl_court c, sl_division d
		Where calendarID in (#url.calid#) and
				(gameDate > '#DateFormat(LAst_month, "YYYY-MM")#-21'
					 AND gameDate < '#DateFormat(Next_month, "YYYY-MM")#-10') and
				ht.teamid = g.h_teamid and
				vt.teamid = g.v_teamid and
				<cfif url.tid NEQ "all">(ht.teamid = #url.tid# or vt.teamid = #url.tid#) and</cfif>
				<cfif url.gType NEQ "all">
					g.gametype = '#url.gType#' and
				</cfif>
				c.courtid = g.courtid and
				loca.locationid = g.locationid and
				d.divid = ht.divid
		Order By gameDate, gametime
	</cfquery>
<cfelse>
	<cfquery name="getGames" datasource="#memberDSN#">
		Select g.gamedate as eventdate, g.gametime as starttime, TIME(NULL) as endtime,
				CONCAT(loca.locationname, '-', IF(c.courtname is NULL, '',c.courtname)) as location,
				CONCAT(' vs ', g.opponent) as description,
			<cfif LEN(url.calid) GT 2>
				CONCAT(d.gender, ' ', ht.name, ' ', g.gametype) as title,
			<cfelse>
				CONCAT(ht.name, ' ', g.gametype) as title,
			</cfif>
				g.status, g.gameid as eventid, g.calendarid, loca.locationid,
				g.description as otherinfo, g.gametype
		From sl_game g, sl_team ht, sl_location loca, sl_court c, sl_division d
		Where calendarID in (#url.calid#) and
				(gameDate > '#DateFormat(LAst_month, "YYYY-MM")#-21'
					 AND gameDate < '#DateFormat(Next_month, "YYYY-MM")#-10') and
				ht.teamid = g.h_teamid and
				<cfif url.tid NEQ "all">ht.teamid = #url.tid# and</cfif>
				<cfif url.gType NEQ "all">
					g.gametype = '#url.gType#' and
				</cfif>
				c.courtid = g.courtid and
				loca.locationid = g.locationid and
				d.divid = ht.divid
		Order By gameDate, gametime
	</cfquery>
</cfif>

<cfquery name="Events" dbtype="query">
	Select *	From getEvents
	Union
	Select * From getGames
</cfquery>

<cfset pageTitle = "#application.sl_name# Calendar">
<html>
<head>
<cfinclude template="#rootdir#ssi/webscript.htm">
<title><cfoutput>#pageTitle#</cfoutput></title>
</head>

<body topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<cfoutput>#url.calid#</cfoutput>
<cfif url.format EQ "html">
	<cfinclude template="calprint-html.cfm">
<cfelse>
	<cfinclude template="calprint-cfdoc.cfm">
</cfif>

</body>
</html>