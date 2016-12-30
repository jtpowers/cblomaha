<cfparam name="url.fName" default="Fall_2010_CBLSchedule.csv">
<cfparam name="url.lid" default="1">
<cffile action="read" file="#application.leagueDir#\leagues\admin\loader\#url.fName#" variable="games">
<cfset rowCount = 0>
<cfset iDate = 0>
<cfset iTime = 0>
<cfset iLocation = 0>
<cfset iCourt = 0>
<cfset iSeason = 0>
<cfset iDivision = 0>
<cfset iVisitor = 0>
<cfset iHome = 0>
<cfset holdSeason = "">
<cfset holdDiv = "">
<cfset holdLoca = "">
<cfset holdCourt = "">

<table border="1" cellpadding="2" cellspacing="0">
<tr>
	<th>Date</th>
	<th>Time</th>
	<th>Vistor</th>
	<th>Home</th>
	<th>Location</th>
	<th>Court</th>
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
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Location">
				<cfset iLocation = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Court">
				<cfset iCourt = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Season">
				<cfset iSeason = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Division">
				<cfset iDivision = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Visitor">
				<cfset iVisitor = eCount>
			<cfelseif #Replace(gElement,'"','','ALL')# EQ "Home">
				<cfset iHome = eCount>
			<cfelse>
			</cfif>
		</cfloop>
	<cfelse>
		<!--- Check Date --->
		<cfset gmDate = #DateFormat(Replace(listgetAt(gIndex,iDate, ','),'"','','ALL'), "yyyy-mm-dd")#>
		<cfif isDate(gmDate)><cfelse><cfabort showerror="Bad Date Entered, #gmDate#"></cfif>
		<!--- Check Time --->
		<cfif iTime EQ 0>
			<cfset gmTime = #TimeFormat(Replace(listgetAt(gIndex,iDate, ','),'"','','ALL'), "HH:mm")#>
		<cfelse>
			<cfset gmTime = #TimeFormat(Replace(listgetAt(gIndex,iTime, ','),'"','','ALL'), "HH:mm")#>
		</cfif>
		
		<!--- Check Season --->
		<cfset gmSeason = #Replace(listgetAt(gIndex,iSeason, ','),'"','','ALL')#>
		<cfif gmSeason GT "">
			<cfif holdSeason NEQ gmSeason>
				<cfset holdSeason = gmSeason>
				<cfquery name="getSeason" datasource="#application.memberDSN#">
					Select seasonid
					From sl_season
					Where leagueid = #url.lid# and seasonname = '#gmSeason#'
				</cfquery>
				<cfif getSeason.RecordCount GT 0>
					<cfset gmSID = getSeason.seasonid>
				<cfelse>
					<cfabort showerror="Bad Season Entered, #gmSeason# - Row #rowCount#">
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
				<cfquery name="getDiv" datasource="#application.memberDSN#">
					Select divid
					From sl_division
					Where seasonid = #gmSID# and divname = '#gmDivision#'
				</cfquery>
				<cfif getDiv.RecordCount GT 0>
					<cfset gmDID = getDiv.divid>
				<cfelse>
					<cfabort showerror="Bad Divsion Entered, #gmDivision# - Row #rowCount#">
				</cfif>
			</cfif>
		<cfelse>
			<cfabort showerror="No Divsion Entered, Row #rowCount#">
		</cfif>
		<!--- Check Visitor Team --->
		<cfset gmVisitor = #Replace(listgetAt(gIndex,iVisitor),'"','','ALL')#>
		<cfif gmVisitor GT "">
			<cfif isNumeric(gmVisitor)>
				<cfquery name="getVisitor" datasource="#application.memberDSN#">
					Select teamid
					From sl_team
					Where leagueNbr = #gmVisitor# and DivID = #gmDID#
				</cfquery>
			<cfelse>
				<cfquery name="getVisitor" datasource="#application.memberDSN#">
					Select teamid
					From sl_team
					Where name = '#gmVisitor#' and DivID = #gmDID#
				</cfquery>
			</cfif>
			<cfif getVisitor.RecordCount GT 0>
				<cfset gmVTID = getVisitor.teamid>
			<cfelse>
				<cfquery name="insertVTeam" datasource="#application.memberDSN#">
					Insert Into sl_team (Name, DivID)
					Values('#gmVisitor#', 
								#gmDID#)
				</cfquery>
				<cfquery name="getVisitor" datasource="#application.memberDSN#">
					Select teamid
					From sl_team
					Where name = '#gmVisitor#' and DivID = #gmDID#
				</cfquery>
				<cfif getVisitor.RecordCount GT 0>
					<cfset gmVTID = "#getVisitor.teamid# - ADDED">
				<cfelse>
					<cfabort showerror="Bad Visitor Team Entered, #gmVisitor# in #gmDivision# - Row #rowCount#">
				</cfif>
			</cfif>
		<cfelse>
			<cfset gmVTID = 0>
		</cfif>
		<!--- Check Home Team --->
		<cfset gmHome = #Replace(listgetAt(gIndex,iHome),'"','','ALL')#>
		<cfif gmHome GT "">
			<cfif isNumeric(gmHome)>
				<cfquery name="getHome" datasource="#application.memberDSN#">
					Select teamid
					From sl_team
					Where leagueNbr = #gmHome# and DivID = #gmDID#
				</cfquery>
			<cfelse>
				<cfquery name="getHome" datasource="#application.memberDSN#">
					Select teamid
					From sl_team
					Where name = '#gmHome#' and DivID = #gmDID#
				</cfquery>
			</cfif>
			<cfif getHome.RecordCount GT 0>
				<cfset gmHTID = getHome.teamid>
			<cfelse>
				<cfquery name="insertHTeam" datasource="#application.memberDSN#">
					Insert Into sl_team (Name, DivID)
					Values('#gmHome#', 
								#gmDID#)
				</cfquery>
				<cfquery name="getHome" datasource="#application.memberDSN#">
					Select teamid
					From sl_team
					Where name = '#gmHome#' and DivID = #gmDID#
				</cfquery>
				<cfif getHome.RecordCount GT 0>
					<cfset gmHTID = "#getHome.teamid# - ADDED">
				<cfelse>
					<cfabort showerror="Bad Home Team Entered, #gmHome# in #gmDivision# - Row #rowCount#">
				</cfif>
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
				<cfquery name="getLocation" datasource="#application.memberDSN#">
					Select l.locationid
					From sl_location l, sl_league_location ll
					Where l.locationname = '#gmLocation#' and ll.LeagueID = #url.lid# and l.locationid = ll.locationid
				</cfquery>
				<cfif getLocation.RecordCount GT 0>
					<cfset gmLocaID = getLocation.locationid>
				<cfelse>
					<cfquery name="getLocation2" datasource="#application.memberDSN#">
						Select l.locationid
						From sl_location l, sl_league_location ll
						Where l.shortname = '#gmLocation#' and ll.LeagueID = #url.lid# and l.locationid = ll.locationid
					</cfquery>
					<cfif getLocation2.RecordCount GT 0>
						<cfset gmLocaID = getLocation2.locationid>
					<cfelse>
						<cfabort showerror="Bad Location Entered, #gmLocation# - Row #rowCount#">
					</cfif>
				</cfif>
			</cfif>
		<cfelse>
			<cfabort showerror="No Location Entered, Row #rowCount#">
		</cfif>
		<!--- Check Field --->
		<cfset gmCourt = #Replace(listgetAt(gIndex,iCourt, ','),'"','','ALL')#>
		<cfif gmCourt GT "">
			<cfif holdCourt NEQ gmCourt OR locationChange>
				<cfset holdCourt = gmCourt>
				<cfquery name="getField" datasource="#application.memberDSN#">
					Select courtid
					From sl_court
					Where courtname = '#gmCourt#' and locationid = #gmLocaID#
				</cfquery>
				<cfif getField.RecordCount GT 0>
					<cfset gmCourtID = getField.courtid>
				<cfelse>
					<cfquery name="getCourt" datasource="#application.memberDSN#">
						Select courtid
						From sl_court
						Where courtname = '#gmCourt#' and locationid = #gmLocaID#
					</cfquery>
					<cfif getCourt.RecordCount GT 0>
						<cfset gmCourtID = getCourt.courtid>
					<cfelse>
						<cfabort showerror="Bad Court Entered, #gmCourt# - Row #rowCount#">
					</cfif>
				</cfif>
			</cfif>
		<cfelse>
			<cfabort showerror="No Court Entered, Row #rowCount#">
		</cfif>
		
		<tr>
			<td><cfoutput>#DateFormat(Replace(listgetAt(gIndex,iDate, ','),'"','','ALL'), "mm/dd/yyyy")#</cfoutput></td>
			<td><cfoutput>#TimeFormat(gmTime, "h:mm tt")#</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iVisitor),'"','','ALL')# (#gmVTID#)</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iHome),'"','','ALL')# (#gmHTID#)</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iLocation, ','),'"','','ALL')# (#gmLocaID#)</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iCourt, ','),'"','','ALL')# (#gmCourtID#)</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iSeason, ','),'"','','ALL')# (#gmSID#)</cfoutput></td>
			<td><cfoutput>#Replace(listgetAt(gIndex,iDivision, ','),'"','','ALL')# (#gmDID#)</cfoutput></td>
		</tr>
		<cfif isDefined("url.load")>
			<cfquery name="AddGame" datasource="#application.memberDSN#">
				Insert Into sl_game (H_TeamID, V_TeamID, GameDate, GameTime, LocationID, CourtID, SeasonID)
				Values(#gmHTID#,  
							#gmVTID#, 
							'#gmDate#', 
							<cfif LEN(gmTime) GT 0>'#gmTime#'<cfelse>NULL</cfif>,
							#gmLocaID#, 
							#gmCourtID#,
							#gmSID#)
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
