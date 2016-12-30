<cfparam name="url.fName" default="2009ALSoftballSchedule.csv">
<cfparam name="url.lid" default="7">
<cffile action="read" file="#leagueDir#\leagues\admin\loader\#url.fName#" variable="games">
<cfset rowCount = 0>
<cfset iDate = 0>
<cfset iTime = 0>
<cfset iStartTime = 0>
<cfset iEndTime = 0>
<cfset iLocation = 0>
<cfset iCourt = 0>
<cfset iSeason = 0>
<cfset iDivision = 0>
<cfset iOpponent = 0>
<cfset iTeam = 0>
<cfset iCalendar = 0>
<cfset iGameType = 0>
<cfset holdSeason = "">
<cfset holdDiv = "">
<cfset holdLoca = "">
<cfset holdCourt = "">
<cfset holdCal = "">

<table border="1" cellpadding="2" cellspacing="0">
<tr>
	<th>Date</th>
	<th>Start Time</th>
	<th>End Time</th>
	<th>Game Type</th>
	<th>Team</th>
	<th>Opponent</th>
	<th>Location</th>
	<th>Court</th>
	<th>Calendar</th>
	<th>Season</th>
	<th>Division</th>
</tr>
<cfloop list="#games#" index="gIndex" delimiters="#chr(10)##chr(13)#">
	<cfset rowCount = rowCount + 1>
	<cfif rowCount EQ 1>
		<cfset eCount = 0>
		<cfloop list="#gIndex#" index="gElement">
			<cfset eCount = eCount + 1>
			<cfif #Replace(gElement,'"','','ALL')# EQ "Date">
				<cfset iDate = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Time">
				<cfset iTime = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Start Time">
				<cfset iStartTime = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "End Time">
				<cfset iEndTime = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Location">
				<cfset iLocation = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Court">
				<cfset iCourt = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Season">
				<cfset iSeason = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Division">
				<cfset iDivision = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Opponent">
				<cfset iOpponent = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Team">
				<cfset iTeam = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Calendar">
				<cfset iCalendar = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Game Type">
				<cfset iGameType = eCount>
			<cfelse>
			</cfif>
		</cfloop>
	<cfelse>
		<!--- Check Date --->
		<cfset gmDate = #DateFormat(Replace(listgetAt(gIndex,iDate, ','),'"','','ALL'), "yyyy-mm-dd")#>
		<cfif isDate(gmDate)><cfelse><cfabort showerror="Bad Date Entered, #gmDate#"></cfif>
		<!--- Check Time --->
		<cfif iTime GT 0>
			<cfif Replace(listgetAt(gIndex,iTime, ','),'"','','ALL') CONTAINS "TBA">
				<cfset gmTime = "">
			<cfelse>
				<cfset gmTime = #TimeFormat(Replace(listgetAt(gIndex,iTime, ','),'"','','ALL'), "HH:mm")#>
			</cfif>
		<cfelseif iStartTime GT 0>
			<cfif Replace(listgetAt(gIndex,iStartTime, ','),'"','','ALL') CONTAINS "TBA">
				<cfset gmTime = "">
			<cfelse>
				<cfset gmTime = #TimeFormat(Replace(listgetAt(gIndex,iStartTime, ','),'"','','ALL'), "HH:mm")#>
			</cfif>
		<cfelse>
			<cfset gmTime = #TimeFormat(Replace(listgetAt(gIndex,iDate, ','),'"','','ALL'), "HH:mm")#>
		</cfif>
		
		<cfif iEndTime GT 0>
			<cfif Replace(listgetAt(gIndex,iEndTime, ','),'"','','ALL') CONTAINS "TBA">
				<cfset gmEndTime = "">
			<cfelse>
				<cfset gmEndTime = #TimeFormat(Replace(listgetAt(gIndex,iEndTime, ','),'"','','ALL'), "HH:mm")#>
			</cfif>
		<cfelse>
			<cfset gmEndTime = "">
		</cfif>

		<cfif iOpponent GT 0>
			<cfset gmOpponent = Replace(listgetAt(gIndex,iOpponent),'"','','ALL')>
		<cfelse>
			<cfset gmOpponent = "">
		</cfif>
		
		<cfif iGameType GT 0>
			<cfset gmGameType = Replace(listgetAt(gIndex,iGameType),'"','','ALL')>
		<cfelse>
			<cfset gmGameType = "Game">
		</cfif>
		<!--- Check Season --->
		<cfset gmSeason = #Replace(listgetAt(gIndex,iSeason, ','),'"','','ALL')#>
		<cfif gmSeason GT "">
			<cfif holdSeason NEQ gmSeason>
				<cfset holdSeason = gmSeason>
				<cfquery name="getSeason" datasource="#memberDSN#">
					Select seasonid
					From sl_season
					Where leagueid = #url.lid# and seasonname = '#gmSeason#'
				</cfquery>
				<cfif getSeason.RecordCount GT 0>
					<cfset gmSID = getSeason.seasonid>
				<cfelse>
					<cfabort showerror="Bad Season Entered, #gmSeason#">
				</cfif>
			</cfif>
		<cfelse>
			<cfabort showerror="No Season Entered, Row #rowCount#">
		</cfif>
		<!--- Check Division --->
		<cfset gmDivision = #Replace(listgetAt(gIndex,iDivision, ','),'"','','ALL')#>
		<cfif gmDivision GT "">
			<cfif holdDiv NEQ gmDivision>
				<cfset holdDiv = gmDivision>
				<cfquery name="getDiv" datasource="#memberDSN#">
					Select divid
					From sl_division
					Where seasonid = #gmSID# and divname = '#gmDivision#'
				</cfquery>
				<cfif getDiv.RecordCount GT 0>
					<cfset gmDID = getDiv.divid>
				<cfelse>
					<cfabort showerror="Bad Divsion Entered, #gmDivision#">
				</cfif>
			</cfif>
		<cfelse>
			<cfabort showerror="No Divsion Entered, Row #rowCount#">
		</cfif>
		<!--- Check Team --->
		<cfset gmTeam = #Replace(listgetAt(gIndex,iTeam),'"','','ALL')#>
		<cfif gmTeam GT "">
			<cfif isNumeric(gmTeam)>
				<cfquery name="getHome" datasource="#memberDSN#">
					Select teamid
					From sl_team
					Where leagueNbr = #gmHome# and DivID = #gmDID#
				</cfquery>
			<cfelse>
				<cfquery name="getHome" datasource="#memberDSN#">
					Select teamid
					From sl_team
					Where name = '#gmTeam#' and DivID = #gmDID#
				</cfquery>
			</cfif>
			<cfif getHome.RecordCount GT 0>
				<cfset gmTeamID = getHome.teamid>
			<cfelse>
				<cfabort showerror="Bad Home Team Entered, #gmTeam# (#rowCount#)">
			</cfif>
		<cfelse>
			<cfabort showerror="No Home Team Entered, Row #rowCount#">
		</cfif>
		<!--- Check Location --->
		<cfset gmLocation = #Replace(listgetAt(gIndex,iLocation, ','),'"','','ALL')#>
		<cfset locationChange = 0>
		<cfif gmLocation GT "">
			<cfif holdLoca NEQ gmLocation>
				<cfset holdLoca = gmLocation>
				<cfset locationChange = 1>
				<cfquery name="getLocation" datasource="#memberDSN#">
					Select l.locationid
					From sl_location l, sl_league_location ll
					Where l.locationname = '#gmLocation#' and ll.LeagueID = #url.lid# and l.locationid = ll.locationid
				</cfquery>
				<cfif getLocation.RecordCount GT 0>
					<cfset gmLocaID = getLocation.locationid>
				<cfelse>
					<cfabort showerror="Bad Location Entered, #gmLocation# (#rowCount#)">
				</cfif>
			</cfif>
		<cfelse>
			<cfabort showerror="No Location Entered, Row #rowCount#">
		</cfif>
		<!--- Check Court --->
		<cfif iCourt GT 0>
			<cfset gmCourt = #Replace(listgetAt(gIndex,iCourt, ','),'"','','ALL')#>
			<cfif gmCourt GT "">
				<cfif holdCourt NEQ gmCourt OR locationChange>
					<cfset holdCourt = gmCourt>
					<cfquery name="getCourt" datasource="#memberDSN#">
						Select courtid
						From sl_court
						Where courtname = '#gmCourt#' and locationid = #gmLocaID#
					</cfquery>
					<cfif getCourt.RecordCount GT 0>
						<cfset gmCourtID = getCourt.courtid>
					<cfelse>
						<cfquery name="getCourt" datasource="#memberDSN#">
							Select courtid
							From sl_court
							Where courtname = '#gmCourt#' and locationid = #gmLocaID#
						</cfquery>
						<cfif getCourt.RecordCount GT 0>
							<cfset gmCourtID = getCourt.courtid>
						<cfelse>
							<cfabort showerror="Bad Court Entered, #gmCourt#">
						</cfif>
					</cfif>
				</cfif>
			<cfelse>
				<cfabort showerror="No Field Entered, Row #rowCount#">
			</cfif>
		<cfelse>
			<cfquery name="getCourt" datasource="#memberDSN#">
				Select courtid
				From sl_court
				Where courtname is NULL and locationid = #gmLocaID#
			</cfquery>
			<cfif getCourt.RecordCount GT 0>
				<cfset gmCourtID = getCourt.courtid>
			<cfelse>
				<cfabort showerror="Bad Court Entered, #gmCourt#">
			</cfif>
		</cfif>
		<!--- Check Calendar --->
		<cfset gmCal = #Replace(listgetAt(gIndex,iCalendar, ','),'"','','ALL')#>
		<cfset calChange = 0>
		<cfif gmCal GT "">
			<cfif holdCal NEQ gmCal>
				<cfset holdCal = gmCal>
				<cfset calChange = 1>
				<cfquery name="getCal" datasource="#memberDSN#">
					Select calendarID
					From sl_calendar
					Where calname = '#gmCal#' and LeagueID = #url.lid#
				</cfquery>
				<cfif getCal.RecordCount GT 0>
					<cfset gmCalID = getCal.calendarID>
				<cfelse>
					<cfabort showerror="Bad Calendar Entered, #gmCal#">
				</cfif>
			</cfif>
		<cfelse>
			<cfabort showerror="No Calendar Entered, Row #rowCount#">
		</cfif>
		<tr>
			<td><cfoutput>#DateFormat(Replace(listgetAt(gIndex,iDate, ','),'"','','ALL'), "mm/dd/yyyy")#</cfoutput></td>
			<td><cfoutput>#gmTime#</cfoutput></td>
			<td><cfoutput>#gmEndTime#</cfoutput></td>
			<td><cfoutput>#gmGameType#</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iTeam),'"','','ALL')# (#gmTeamID#)</cfoutput></td>
			<td><cfoutput>#gmOpponent#</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iLocation, ','),'"','','ALL')# (#gmLocaID#)</cfoutput></td>
			<td><cfif iCourt GT 0><cfoutput>#Replace(listgetAt(gIndex,iCourt, ','),'"','','ALL')# (#gmCourtID#)</cfoutput><cfelse>&nbsp;</cfif></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iCalendar, ','),'"','','ALL')# (#gmCalID#)</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iSeason, ','),'"','','ALL')# (#gmSID#)</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iDivision, ','),'"','','ALL')# (#gmDID#)</cfoutput></td>
		</tr>
		<cfif isDefined("url.load")>
			<cfquery name="AddGame" datasource="#memberDSN#">
				Insert Into sl_game (H_TeamID, GameDate, GameTime, GameType, Opponent,  LocationID, CourtID, Status, CalendarID, SeasonID, EndTime)
				Values(#gmTeamID#,  
							'#gmDate#', 
							<cfif LEN(gmTime) GT 0>'#gmTime#'<cfelse>NULL</cfif>,
							'#gmGameType#', 
							<cfif LEN(gmOpponent) GT 0>'#gmOpponent#'<cfelse>NULL</cfif>,
							#gmLocaID#, 
							#gmCourtID#,
							1,
							<cfif LEN(gmCalID) GT 0>#gmCalID#<cfelse>NULL</cfif>,
							#gmSID#,
							<cfif LEN(gmEndTime) GT 0>'#gmEndTime#'<cfelse>NULL</cfif>)
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
</table>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

</body>
</html>
