<cfset rootDir = "../../">
<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="url.action" default="Add">

<cfif isDefined("form.gid")><cfset url.gid = form.gid></cfif>
<cfset done = 0>
<cfset isSelected = "">
<cfset gMonth = DateFormat(Now(), "m")>
<cfset gDay = DateFormat(Now(), "d")>
<cfset gYear = DateFormat(Now(), "yyyy")>
<cfset gHour = "12">
<cfset gMinute = "00">
<cfset gTMarker = "p">
<cfset gGameNbr = "">
<cfset gCal = "">
<cfset gStatus = "1">
<cfset gSchedChange = "0">

<cfif isDefined("form.process")>
	<cfif url.action EQ "Update">
		<cfif form.process EQ "deletegame">
			<cfquery name="DeleteGamePlayers" datasource="#application.memberDSN#">
				Delete From sl_game_player
				where  GameID = #form.gid#
			</cfquery>
			<cfquery name="DeleteGame" datasource="#application.memberDSN#">
				Delete From sl_game
				where  GameID = #form.gid#
			</cfquery>
			<cfset url.gid = "">
		<cfelse>
			<cfset gamedate = "#form.u_year#-#form.u_month#-#form.u_day#">
			<cfif form.u_ampm EQ "a" AND form.u_hour EQ 12>
				<cfset gametime = "00:#form.u_min#:00">
			<cfelseif form.u_ampm EQ "p" AND form.u_hour LT 12>
				<cfset form.u_hour = form.u_hour + 12>
				<cfset gametime = "#form.u_hour#:#form.u_min#:00">
			<cfelseif form.u_ampm EQ "tbd">
				<cfset gametime = "">
			<cfelse>
				<cfset gametime = "#form.u_hour#:#form.u_min#:00">
			</cfif>
			<cfset locaid = ListFirst(form.u_loca)>
			<cfset cid = ListLast(form.u_loca)>
			<cfquery name="UpdateGame" datasource="#application.memberDSN#">
				Update sl_game
				Set H_TeamID = #u_htid#, 
						V_TeamID = #u_vtid#, 
						GameDate = '#gamedate#', 
						GameTime = <cfif LEN(gametime) GT 0>'#gametime#'<cfelse>NULL</cfif>, 
						GameNbr = <cfif LEN(u_gamenbr) GT 0>'#u_gamenbr#'<cfelse>NULL</cfif>, 
						LocationID = #locaid#,
						CourtID = #cid#,
						CalendarID = <cfif LEN(u_cal) GT 0>#u_cal#<cfelse>NULL</cfif>, 
						Status = <cfif LEN(u_status) GT 0>#u_status#<cfelse>NULL</cfif>,
						SchedChange = <cfif isDefined("u_schedchange")>1<cfelse>0</cfif>,
						SeasonID = #cookie.lynxbbsid#
				Where GameID = #form.gid#
			</cfquery>
		</cfif>
		<cfset done = 1>
	<cfelseif url.action EQ "Add">
		<cfset gamedate = "#form.u_year#-#form.u_month#-#form.u_day#">
		<cfif form.u_ampm EQ "a" AND form.u_hour EQ 12>
			<cfset gametime = "00:#form.u_min#:00">
		<cfelseif form.u_ampm EQ "p" AND form.u_hour LT 12>
			<cfset form.u_hour = form.u_hour + 12>
			<cfset gametime = "#form.u_hour#:#form.u_min#:00">
		<cfelseif form.u_ampm EQ "tbd">
			<cfset gametime = "">
		<cfelse>
			<cfset gametime = "#form.u_hour#:#form.u_min#:00">
		</cfif>
		<cfset locaid = ListFirst(form.u_loca)>
		<cfset cid = ListLast(form.u_loca)>
		<cfquery name="AddGame" datasource="#application.memberDSN#">
			Insert Into sl_game (H_TeamID, V_TeamID, GameDate, GameTime, GameNbr, LocationID, CourtID, CalendarID, Status, SchedChange, SeasonID)
			Values(#u_htid#,  
						#u_vtid#, 
						'#gamedate#', 
						<cfif LEN(gametime) GT 0>'#gametime#'<cfelse>NULL</cfif>,
						<cfif LEN(u_gamenbr) GT 0>'#u_gamenbr#'<cfelse>NULL</cfif>,
						#locaid#, 
						#cid#,
						<cfif LEN(u_cal) GT 0>#u_cal#<cfelse>NULL</cfif>,
						<cfif LEN(u_status) GT 0>#u_status#<cfelse>NULL</cfif>,
						<cfif isDefined("u_schedchange")>1<cfelse>0</cfif>,
						#cookie.lynxbbsid#)
		</cfquery>
		<cfquery name="getLastGame" datasource="#application.memberDSN#">
			Select Max(gameID) as lastgameid
			From sl_game 
		</cfquery>
		<cfset url.gid = getLastGame.lastgameid>
		<cfset url.action = "Update">
		<cfset done = 1>
	</cfif>
</cfif>

<cfif isDefined("url.gid") AND url.gid GT "">
	<cfquery name="getGame" datasource="#application.memberDSN#">
		Select d.divname, d.gender, d.divid, s.seasonname, l.leaguename, l.leagueid,
				g.gamedate, g.gametime, loca.locationname, c.courtname,
				g.h_teamid, g.v_teamid, g.h_points, g.v_points, g.courtid, g.locationid, g.gamenbr, g.calendarID, g.status,
				ht.name as hteam, vt.name as vteam, g.gameid, g.schedchange
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
	<cfset url.lid = getGame.leagueid>
	<cfset url.divid = getGame.divid>
	<cfset gMonth = DateFormat(getGame.gamedate, "m")>
	<cfset gDay = DateFormat(getGame.gamedate, "d")>
	<cfset gYear = DateFormat(getGame.gamedate, "yyyy")>
	<cfif getGame.gametime GT "">
		<cfset gHour = TimeFormat(getGame.gametime, "h")>
		<cfset gMinute = TimeFormat(getGame.gametime, "m")>
		<cfset gTMarker = TimeFormat(getGame.gametime, "t")>
	<cfelse>
		<cfset gHour = "">
		<cfset gMinute = "">
		<cfset gTMarker = "tbd">
	</cfif>
	<cfset gCal = getGame.calendarID>
	<cfset gStatus = getGame.status>
	<cfset gSchedChange = getGame.schedchange>
	<cfset gGameNbr = getGame.gamenbr>
</cfif>

<cfquery name="getDivision" datasource="#application.memberDSN#">
	Select l.leagueid, l.leaguename, s.seasonid, s.seasonname, d.divid, d.divname, d.gender
	From sl_league l, sl_season s, sl_division d
	Where s.seasonid = d.seasonid and
			l.leagueid = s.leagueid and
			d.divid = #url.divid#
</cfquery>
<cfquery name="getTeams" datasource="#application.memberDSN#">
	Select *
	From sl_team
	Where divid = #url.divid#
	Order by LeagueNbr
</cfquery>
<cfquery name="getLocations" datasource="#application.memberDSN#">
	Select loca.locationname, loca.locationid, c.courtname, c.courtid
	From sl_location loca, sl_court c, sl_league_location ll
	Where ll.leagueid = #url.lid# and
			loca.locationid = ll.locationid and
			c.locationid = loca.locationid
	Order by locationname, courtname
</cfquery>
<cfquery name="getCalendars" datasource="#application.memberDSN#">
	SELECT c.calendarid, c.calName, c.calOrder, l.leagueName
	FROM sl_calendar c LEFT OUTER JOIN sl_league l on l.leagueid = c.leagueid
	ORDER BY l.leagueName, c.calOrder
</cfquery>


<cfset pageTitle = "League Games">
<cfinclude template="#rootdir#ssi/header.cfm">

	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete is Game?"))
			{
				document.gameform.process.value = "deleteGame";
			} 
			else
			{
			}
		}	
		
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.history.go(0);
			window.close();
		  }
		}
	</script>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0"<cfif done> onload="closeRefresh();"</cfif>>

<cfif NOT done>
<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#<br>
		#application.sl_leaguename#<br>#url.action#</cfoutput> Game
	</td>
</tr>
<tr><td align="center" class="titlesub">
<cfoutput>
#getDivision.seasonname#<br>#getDivision.gender# #getDivision.divname#
</cfoutput>
</td></tr>
<tr><td valign="top" align="center">
	<cfform action="gameedit.cfm?action=#url.action#&lid=#url.lid#&divid=#url.divid#" method="post" name="gameform">
	<cfoutput>
	<input type="hidden" name="process" value="go">
	<cfif url.action EQ "Update">
	<input type="hidden" name="gid" value="#gid#">
	</cfif>
	</cfoutput>
	<table class="table table-condensed no-border">
		<tr>
			<td class="smallb">*Game Date:</td>
			<td class="small">
				<select name="u_month" class="small">
					<option value="1"<cfif gMonth EQ 1> selected</cfif>>Jan.</option>
					<option value="2"<cfif gMonth EQ 2> selected</cfif>>Feb.</option>
					<option value="3"<cfif gMonth EQ 3> selected</cfif>>Mar.</option>
					<option value="4"<cfif gMonth EQ 4> selected</cfif>>Apr.</option>
					<option value="5"<cfif gMonth EQ 5> selected</cfif>>May</option>
					<option value="6"<cfif gMonth EQ 6> selected</cfif>>June</option>
					<option value="7"<cfif gMonth EQ 7> selected</cfif>>July</option>
					<option value="8"<cfif gMonth EQ 8> selected</cfif>>Aug.</option>
					<option value="9"<cfif gMonth EQ 9> selected</cfif>>Sept.</option>
					<option value="10"<cfif gMonth EQ 10> selected</cfif>>Oct.</option>
					<option value="11"<cfif gMonth EQ 11> selected</cfif>>Nov.</option>
					<option value="12"<cfif gMonth EQ 12> selected</cfif>>Dec.</option>
				</select>
				<cfoutput>
				<select name="u_day" class="small">
				<cfloop from="1" to="31" index="dIndex">
					<option value="#dIndex#"<cfif gDay EQ dIndex> selected</cfif>>#dIndex#</option>
				</cfloop>
				</select>
				</cfoutput>
				</select>
				<cfoutput>
				<select name="u_year" class="small">
				<cfloop from="-1" to="2" index="yIndex">
					<cfset vYear = DateFormat(Now(), "yyyy") + yIndex>
					<option value="#vYear#"<cfif gYear EQ vYear> selected</cfif>>#vYear#</option>
				</cfloop>
				</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="smallb">Game Time:</td>
			<td class="small">
				<select name="u_hour" class="small">
				<cfoutput>
					<option value=""<cfif gHour EQ ""> selected</cfif>></option>
				<cfloop from="1" to="12" index="hIndex">
					<option value="#hIndex#"<cfif gHour EQ hIndex> selected</cfif>>#hIndex#</option>
				</cfloop>
				</cfoutput>
				</select>
				<select name="u_min" class="small">
					<option value=""<cfif gMinute EQ ""> selected</cfif>></option>
					<option value="00"<cfif gMinute EQ 0> selected</cfif>>00</option>
					<option value="15"<cfif gMinute EQ 15> selected</cfif>>15</option>
					<option value="30"<cfif gMinute EQ 30> selected</cfif>>30</option>
					<option value="45"<cfif gMinute EQ 45> selected</cfif>>45</option>
				</select>
				<select name="u_ampm" class="small">
					<option value="a"<cfif gTMarker EQ "a"> selected</cfif>>AM</option>
					<option value="p"<cfif gTMarker EQ "p"> selected</cfif>>PM</option>
					<option value="tbd"<cfif gTMarker EQ "tbd"> selected</cfif>>TBD</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="smallb">Game Nbr:</td>
			<td class="small"><input type="text" name="u_gamenbr" value="<cfoutput>#gGameNbr#</cfoutput>" size="6"></td>
		</tr>
		<tr>
			<td class="smallb">Location:</td>
			<td class="small">
			<select name="u_Loca" class="small">
			<cfoutput query="getLocations">
				<cfif url.action EQ "Update" AND locationid EQ getGame.locationid AND courtid EQ getGame.courtid>
					<cfset isSelected = " selected">
				<cfelse>
					<cfset isSelected = "">
				</cfif>
				<option value="#locationid#,#courtid#"#isSelected#>#locationname# - #courtname#</option>
			</cfoutput>
			</select>
			</td>
		</tr>
		<tr>
			<td class="smallb">Home:</td>
			<td class="small">
			<select name="u_htid" class="small">
			<cfoutput query="getTeams">
				<cfif url.action EQ "Update" AND getGame.H_TeamID EQ TeamID>
					<cfset isSelected = " selected">
				<cfelse>
					<cfset isSelected = "">
				</cfif>
				<cfif leaguenbr GT ""><cfset tDispay = "#leaguenbr#. #Name#"><cfelse><cfset tDispay = "#Name#"></cfif>
				<option value="#TeamID#"#isSelected#>#tDispay#</option>
			</cfoutput>
			</select>
			</td>
		</tr>
		<tr>
			<td class="smallb">Vistor:</td>
			<td class="small">
			<select name="u_vtid" class="small">
			<cfoutput query="getTeams">
				<cfif url.action EQ "Update" AND getGame.V_TeamID EQ TeamID>
					<cfset isSelected = " selected">
				<cfelse>
					<cfset isSelected = "">
				</cfif>
				<cfif leaguenbr GT ""><cfset tDispay = "#leaguenbr#. #Name#"><cfelse><cfset tDispay = "#Name#"></cfif>
				<option value="#TeamID#"#isSelected#>#tDispay#</option>
			</cfoutput>
				<cfif url.action EQ "Update" AND getGame.V_TeamID EQ 0>
					<cfset isSelected = " selected">
				<cfelse>
					<cfset isSelected = "">
				</cfif>
				<cfoutput>
				<option value="0"#isSelected#>TBD</option>
				</cfoutput>
			</select>
			</td>
		</tr>
		<tr>
			<td class="smallb">Put on Calendar:</td>
			<td class="small">
			<select name="u_cal" class="small">
				<option value=""<cfif gCal EQ ""> selected</cfif>>No Calendar</option>
			<cfoutput query="getCalendars">
				<option value="#calendarID#"<cfif gCal EQ calendarID> selected</cfif>>#calName#</option>
			</cfoutput>
			</select>
			</td>
		</tr>
		<tr>
			<td class="smallb">Status</td>
			<td class="small">
				<select name="u_status" class="small">
					<option value="1"<cfif gStatus eq 1> SELECTED</cfif>>Active</option>
					<option value="2"<cfif gStatus eq 2> SELECTED</cfif>>Cancelled</option>
					<option value="3"<cfif gStatus eq 3> SELECTED</cfif>>Postponed</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="smallb" colspan="2" align="center">
				List in New Game Time box:
				<input name="u_schedchange" type="checkbox" value="1"<cfif gSchedChange EQ 1> checked</cfif>>
			</td>
		</tr>
		<tr><td colspan="2" align="center" class="small">
		<cfoutput>
			<input type="submit" name="submit" value="#url.action# Game" class="small">
		</cfoutput>
		<cfif url.action EQ "Update">
			<input type="submit" name="delete" value="Delete Game" class="small" onClick="verify();">
		</cfif>
			<input type="reset" class="small"><br>
			<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
		</td></tr>
		<tr> 
			<td colspan="2" class="small">* Required Field</td>
		</tr>
	</table>
	</cfform>
</td></tr>
</table>

</cfif>
</body>
</html>
