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
<cfset gRef1 = "">
<cfset gRef2 = "">
<cfset gSchedChange = "0">

<cfif isDefined("form.process")>
	<cfset gamedate = "#form.u_year#-#form.u_month#-#form.u_day#">
	<cfif form.u_eyear GT "" AND form.u_emonth GT "" AND form.u_eday GT "">
		<cfset enddate = "#form.u_eyear#-#form.u_emonth#-#form.u_eday#">
	<cfelse>
		<cfset enddate = "">
	</cfif>
	<!--- Format Start Time --->
	<cfif form.s_ampm EQ "tbd" OR form.s_hour EQ "">
		<cfset starttime = "">
	<cfelseif form.s_ampm EQ "a" AND form.s_hour EQ 12>
		<cfset starttime = "00:#form.s_min#:00">
	<cfelseif form.s_ampm EQ "p" AND form.s_hour LT 12>
		<cfset form.s_hour = form.s_hour + 12>
		<cfset starttime = "#form.s_hour#:#form.s_min#:00">
	<cfelse>
		<cfset starttime = "#form.s_hour#:#form.s_min#:00">
	</cfif>
	<!--- Format End Time --->
	<cfif form.e_hour EQ "">
		<cfset endtime = "">
	<cfelseif form.e_ampm EQ "a" AND form.e_hour EQ 12>
		<cfset endtime = "00:#form.e_min#:00">
	<cfelseif form.e_ampm EQ "p" AND form.e_hour LT 12>
		<cfset form.e_hour = form.e_hour + 12>
		<cfset endtime = "#form.e_hour#:#form.e_min#:00">
	<cfelse>
		<cfset endtime = "#form.e_hour#:#form.e_min#:00">
	</cfif>
	<cfset locaid = ListFirst(form.u_loca)>
	<cfset cid = ListLast(form.u_loca)>
	<cfif url.action EQ "Update">
		<cfif form.process EQ "deletegame">
			<cfquery name="DeleteGamePlayers" datasource="#memberDSN#">
				Delete From sl_game_player
				where  GameID = #form.gid#
			</cfquery>
			<cfquery name="DeleteGame" datasource="#memberDSN#">
				Delete From sl_game
				where  GameID = #form.gid#
			</cfquery>
			<cfset url.gid = "">
		<cfelse>
			<cfquery name="UpdateGame" datasource="#memberDSN#">
				Update sl_game
				Set H_TeamID =  #u_team#,
						GameDate = '#gamedate#', 
						GameTime = <cfif LEN(starttime) GT 0>'#starttime#'<cfelse>NULL</cfif>, 
						EndTime = <cfif LEN(endtime) GT 0>'#endtime#'<cfelse>NULL</cfif>, 
						GameType = '#form.u_gametype#', 
						Opponent = <cfif LEN(form.u_opponent) GT 0>'#form.u_opponent#'<cfelse>NULL</cfif>,
						LocationID = #locaid#,
						CourtID = <cfif LEN(cid) GT 0>#cid#<cfelse>NULL</cfif>,
						Status = #form.u_status#, 
						Description = <cfif LEN(form.u_desc) GT 0>'#form.u_desc#'<cfelse>NULL</cfif>, 
						H_Points = <cfif LEN(form.u_usscore) GT 0>#form.u_usscore#<cfelse>NULL</cfif>, 
						V_Points = <cfif LEN(form.u_themscore) GT 0>#form.u_themscore#<cfelse>NULL</cfif>,
						CalendarID = <cfif LEN(u_cal) GT 0>#u_cal#<cfelse>NULL</cfif>, 
						EndDate = <cfif LEN(enddate) GT 0>'#enddate#'<cfelse>NULL</cfif>
					Where GameID = #form.gid#
			</cfquery>
		</cfif>
		<cfset done = 1>
	<cfelseif url.action EQ "Add">
		<cfquery name="AddGame" datasource="#memberDSN#">
			Insert Into sl_game (H_TeamID, GameDate, GameTime, EndTime, GameType, Opponent,  LocationID, CourtID, Status, Description, H_Points, V_Points, CalendarID, EndDate, SeasonID)
			Values(#u_team#,  
						'#gamedate#', 
						<cfif LEN(starttime) GT 0>'#starttime#'<cfelse>NULL</cfif>,
						<cfif LEN(endtime) GT 0>'#endtime#'<cfelse>NULL</cfif>,
						'#form.u_gametype#', 
						<cfif LEN(form.u_opponent) GT 0>'#form.u_opponent#'<cfelse>NULL</cfif>,
						#locaid#, 
						#cid#,
						#form.u_status#,
						<cfif LEN(form.u_desc) GT 0>'#form.u_desc#'<cfelse>NULL</cfif>,
						<cfif LEN(form.u_UsScore) GT 0>#form.u_UsScore#<cfelse>NULL</cfif>,
						<cfif LEN(form.u_ThemScore) GT 0>#form.u_ThemScore#<cfelse>NULL</cfif>,
						<cfif LEN(u_cal) GT 0>#u_cal#<cfelse>NULL</cfif>,
						<cfif LEN(enddate) GT 0>'#enddate#'<cfelse>NULL</cfif>,
						#cookie.lynxbbsid#)
		</cfquery>
		<cfset done = 1>
	</cfif>
	<cfif repeat NEQ 'n'>
		<cfset repeatvalue = repeatvalue - 1>
		<cfif repeatvalue lt 0><cfset repeatvalue = 0></cfif>
		<cfloop from="1" to="#repeatvalue#" index="addindex">
			<cfset dateEvent = #DateFormat(DateAdd(#repeat#, #addindex#, #gamedate#),"mm/dd/yy")#>
			<cfoutput>#dateEvent# #addindex# #gamedate#</cfoutput>
			<cfquery name="AddGame" datasource="#memberDSN#">
			Insert Into sl_game (H_TeamID, GameDate, GameTime, EndTime, GameType, Opponent,  LocationID, CourtID, Status, Description, H_Points, V_Points, CalendarID, EndDate)
			Values(#u_team#,  
						'#DateFormat(dateEvent, "yyyy-mm-dd")#', 
						<cfif LEN(starttime) GT 0>'#starttime#'<cfelse>NULL</cfif>,
						<cfif LEN(endtime) GT 0>'#endtime#'<cfelse>NULL</cfif>,
						'#form.u_gametype#', 
						<cfif LEN(form.u_opponent) GT 0>'#form.u_opponent#'<cfelse>NULL</cfif>,
						#locaid#, 
						#cid#,
						#form.u_status#,
						<cfif LEN(form.u_desc) GT 0>'#form.u_desc#'<cfelse>NULL</cfif>,
						<cfif LEN(form.u_UsScore) GT 0>#form.u_UsScore#<cfelse>NULL</cfif>,
						<cfif LEN(form.u_ThemScore) GT 0>#form.u_ThemScore#<cfelse>NULL</cfif>,
						<cfif LEN(u_cal) GT 0>#u_cal#<cfelse>NULL</cfif>,
						<cfif LEN(enddate) GT 0>'#enddate#'<cfelse>NULL</cfif>)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>

<cfquery name="getTeams" datasource="#memberDSN#">
	Select *
	From sl_team
	Where divid = #url.divid#
	Order By name
</cfquery>

<cfif isDefined("url.gid") AND url.gid GT "">
	<cfquery name="getGame" datasource="#memberDSN#">
		Select g.*, loca.locationname, c.courtname
		From sl_game g, sl_location loca, sl_court c
		Where 
				g.gameid = #url.gid# and
				c.courtid = g.courtid and
				loca.locationid = g.locationid
	</cfquery>
	<cfset form.u_team = getGame.h_teamid>
	<cfset form.u_month = DateFormat(getGame.gamedate, "m")>
	<cfset form.u_day = DateFormat(getGame.gamedate, "d")>
	<cfset form.u_year = DateFormat(getGame.gamedate, "yyyy")>
	<cfif getGame.enddate GT "">
		<cfset form.u_emonth = DateFormat(getGame.enddate, "m")>
		<cfset form.u_eday = DateFormat(getGame.enddate, "d")>
		<cfset form.u_eyear = DateFormat(getGame.enddate, "yyyy")>
	<cfelse>
		<cfset form.u_emonth = "">
		<cfset form.u_eday = "">
		<cfset form.u_eyear = "">
	</cfif>
	<cfif getGame.gametime GT "">
		<cfset form.s_hour = TimeFormat(getGame.gametime, "h")>
		<cfset form.s_min = TimeFormat(getGame.gametime, "m")>
		<cfset form.s_ampm = TimeFormat(getGame.gametime, "t")>
	<cfelse>
		<cfset form.s_hour = "">
		<cfset form.s_min = "">
		<cfset form.s_ampm = "tbd">
	</cfif>
	<cfif getGame.endtime GT "">
		<cfset form.e_hour = TimeFormat(getGame.endtime, "h")>
		<cfset form.e_min = TimeFormat(getGame.endtime, "m")>
		<cfset form.e_ampm = TimeFormat(getGame.endtime, "t")>
	<cfelse>
		<cfset form.e_hour = "">
		<cfset form.e_min = "">
		<cfset form.e_ampm = "tbd">
	</cfif>
	<cfset form.u_gametype = getGame.gametype>
	<cfset form.u_opponent = getGame.Opponent>
	<cfset form.u_UsScore = getGame.H_Points>
	<cfset form.u_ThemScore = getGame.V_Points>
	<cfset form.u_status = getGame.Status>
	<cfset form.u_desc = getGame.Description>
	<cfset gCal = getGame.calendarID>
<cfelse>
	<cfset form.u_team = getTeams.teamid[1]>
	<cfset form.u_month = DateFormat(Now(), "m")>
	<cfset form.u_day = DateFormat(Now(), "d")>
	<cfset form.u_year = DateFormat(Now(), "yyyy")>
	<cfset form.u_emonth = "">
	<cfset form.u_eday = "">
	<cfset form.u_eyear = "">
	<cfset form.s_hour = "1">
	<cfset form.s_min = "0">
	<cfset form.s_ampm = "p">
	<cfset form.e_hour = "">
	<cfset form.e_min = "0">
	<cfset form.e_ampm = "p">
	<cfset form.u_gametype = "Practice">
	<cfset form.u_opponent = "">
	<cfset form.u_UsScore = "">
	<cfset form.u_ThemScore = "">
	<cfset form.u_status = 1>
	<cfset form.u_desc = "">
	<cfquery name="getCal" datasource="#memberDSN#" dbtype="ODBC">
		SELECT c.calendarid
		FROM sl_calendar c LEFT OUTER JOIN sl_league l on l.leagueid = c.leagueid
		Where l.leagueid = #url.lid#
	</cfquery>
	<cfif getCal.RecordCount GT 0>
		<cfset gCal = "#getCal.calendarid#">
	<cfelse>
		<cfset gCal = "">
	</cfif>
</cfif>

<cfquery name="getLocations" datasource="#memberDSN#">
	Select loca.locationname, loca.locationid, c.courtname, c.courtid
	From sl_league_location ll, sl_location loca Left Outer Join sl_court c On c.locationid = loca.locationid
	Where ll.leagueid = #url.lid# and
			loca.locationid = ll.locationid
	Order by locationname, courtname
</cfquery>

<cfquery name="getGameTypes" datasource="#memberDSN#">
	Select value_1 as gametype
	From sl_general_purpose
	Where name = 'GameType'
	Order By value_4
</cfquery>
<cfquery name="getGameStatus" datasource="#memberDSN#">
	Select value_1 as statusid, value_2 as gamestatus
	From sl_general_purpose
	Where name = 'GameStatus'
	Order By value_1
</cfquery>
<cfquery name="getCalendars" datasource="#memberDSN#" dbtype="ODBC">
	SELECT c.calendarid, c.calName, c.calOrder, l.leagueName
	FROM sl_calendar c LEFT OUTER JOIN sl_league l on l.leagueid = c.leagueid
	ORDER BY l.leagueName, c.calOrder
</cfquery>

<cfset rootDir = "../../">
<cfset pageTitle = "Sports League - Edit Team Schedule">
<html>
<head>
	<cfinclude template="#rootDir#ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete is Event?"))
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
</head>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0"<cfif done> onload="closeRefresh();"</cfif>>

<cfif NOT done>
<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#<br>#url.action#</cfoutput> Event
	</td>
</tr>
<!---<tr><td valign="top" align="center" class="titlesub">
<cfoutput>
#getDivision.leaguename#<br>#getDivision.seasonname#<br>#getDivision.gender# #getDivision.divname#
</cfoutput>
</td></tr>--->
<tr><td valign="top" align="center">
	<cfoutput>
	<form action="gameedit2.cfm?action=#url.action#&lid=#url.lid#&divid=#url.divid#" method="post" name="gameform">
	<input type="hidden" name="process" value="go">
	<cfif url.action EQ "Update">
	<input type="hidden" name="gid" value="#gid#">
	</cfif>
	</cfoutput>
	<table border="1" cellspacing="0" cellpadding="3">
		<tr><td>
		<table cellpadding="2" cellspacing="0">
		<tr> 
			<td valign="TOP" class="smallb">Team:</td>
			<td valign="TOP" class="smallb"> 
			<select name="u_team" class="small">
			<cfoutput query="getTeams">
				<option value="#teamid#"<cfif form.u_team EQ teamid> selected</cfif>>#name#</option>
			</cfoutput>
			</select>
			</td>
		</tr>
		<tr>
			<td class="smallb">Game Date:</td>
			<td class="small">
				<select name="u_month" class="small">
					<option value="1"<cfif form.u_month EQ 1> selected</cfif>>Jan.</option>
					<option value="2"<cfif form.u_month EQ 2> selected</cfif>>Feb.</option>
					<option value="3"<cfif form.u_month EQ 3> selected</cfif>>Mar.</option>
					<option value="4"<cfif form.u_month EQ 4> selected</cfif>>Apr.</option>
					<option value="5"<cfif form.u_month EQ 5> selected</cfif>>May</option>
					<option value="6"<cfif form.u_month EQ 6> selected</cfif>>June</option>
					<option value="7"<cfif form.u_month EQ 7> selected</cfif>>July</option>
					<option value="8"<cfif form.u_month EQ 8> selected</cfif>>Aug.</option>
					<option value="9"<cfif form.u_month EQ 9> selected</cfif>>Sept.</option>
					<option value="10"<cfif form.u_month EQ 10> selected</cfif>>Oct.</option>
					<option value="11"<cfif form.u_month EQ 11> selected</cfif>>Nov.</option>
					<option value="12"<cfif form.u_month EQ 12> selected</cfif>>Dec.</option>
				</select>
				<cfoutput>
				<select name="u_day" class="small">
				<cfloop from="1" to="31" index="dIndex">
					<option value="#dIndex#"<cfif form.u_day EQ dIndex> selected</cfif>>#dIndex#</option>
				</cfloop>
				</select>
				</cfoutput>
				</select>
				<cfoutput>
				<select name="u_year" class="small">
				<cfloop from="-1" to="2" index="yIndex">
					<cfset vYear = DateFormat(Now(), "yyyy") + yIndex>
					<option value="#vYear#"<cfif form.u_year EQ vYear> selected</cfif>>#vYear#</option>
				</cfloop>
				</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="smallb">Start Time:</td>
			<td class="small">
				<select name="s_hour" class="small">
				<cfoutput>
					<option value=""<cfif form.e_hour EQ ""> selected</cfif>>NA</option>
				<cfloop from="1" to="12" index="hIndex">
					<option value="#hIndex#"<cfif form.s_hour EQ hIndex> selected</cfif>>#hIndex#</option>
				</cfloop>
				</cfoutput>
				</select>
				<select name="s_min" class="small">
					<option value=""<cfif form.s_min EQ ""> selected</cfif>></option>
					<option value="00"<cfif form.s_min EQ 0> selected</cfif>>00</option>
					<option value="15"<cfif form.s_min EQ 15> selected</cfif>>15</option>
					<option value="30"<cfif form.s_min EQ 30> selected</cfif>>30</option>
					<option value="45"<cfif form.s_min EQ 45> selected</cfif>>45</option>
				</select>
				<select name="s_ampm" class="small">
					<option value="a"<cfif form.s_ampm EQ "a"> selected</cfif>>AM</option>
					<option value="p"<cfif form.s_ampm EQ "p"> selected</cfif>>PM</option>
					<option value="tbd"<cfif form.s_ampm EQ "tbd"> selected</cfif>>TBD</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="smallb">End Time:</td>
			<td class="small">
				<select name="e_hour" class="small">
				<cfoutput>
					<option value=""<cfif form.e_hour EQ ""> selected</cfif>>NA</option>
				<cfloop from="1" to="12" index="hIndex">
					<option value="#hIndex#"<cfif form.e_hour EQ hIndex> selected</cfif>>#hIndex#</option>
				</cfloop>
				</cfoutput>
				</select>
				<select name="e_min" class="small">
					<option value="00"<cfif form.e_min EQ 0> selected</cfif>>00</option>
					<option value="15"<cfif form.e_min EQ 15> selected</cfif>>15</option>
					<option value="30"<cfif form.e_min EQ 30> selected</cfif>>30</option>
					<option value="45"<cfif form.e_min EQ 45> selected</cfif>>45</option>
				</select>
				<select name="e_ampm" class="small">
					<option value="a"<cfif form.e_ampm EQ "a"> selected</cfif>>AM</option>
					<option value="p"<cfif form.e_ampm EQ "p"> selected</cfif>>PM</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="smallb">End Date:</td>
			<td class="small">
				<select name="u_emonth" class="small">
					<option value=""<cfif form.u_emonth EQ ""> selected</cfif>>N/A</option>
					<option value="1"<cfif form.u_emonth EQ 1> selected</cfif>>Jan.</option>
					<option value="2"<cfif form.u_emonth EQ 2> selected</cfif>>Feb.</option>
					<option value="3"<cfif form.u_emonth EQ 3> selected</cfif>>Mar.</option>
					<option value="4"<cfif form.u_emonth EQ 4> selected</cfif>>Apr.</option>
					<option value="5"<cfif form.u_emonth EQ 5> selected</cfif>>May</option>
					<option value="6"<cfif form.u_emonth EQ 6> selected</cfif>>June</option>
					<option value="7"<cfif form.u_emonth EQ 7> selected</cfif>>July</option>
					<option value="8"<cfif form.u_emonth EQ 8> selected</cfif>>Aug.</option>
					<option value="9"<cfif form.u_emonth EQ 9> selected</cfif>>Sept.</option>
					<option value="10"<cfif form.u_emonth EQ 10> selected</cfif>>Oct.</option>
					<option value="11"<cfif form.u_emonth EQ 11> selected</cfif>>Nov.</option>
					<option value="12"<cfif form.u_emonth EQ 12> selected</cfif>>Dec.</option>
				</select>
				<cfoutput>
				<select name="u_eday" class="small">
					<option value=""<cfif form.u_eday EQ ""> selected</cfif>></option>
				<cfloop from="1" to="31" index="dIndex">
					<option value="#dIndex#"<cfif form.u_eday EQ dIndex> selected</cfif>>#dIndex#</option>
				</cfloop>
				</select>
				</cfoutput>
				</select>
				<cfoutput>
				<select name="u_eyear" class="small">
					<option value=""<cfif form.u_eyear EQ ""> selected</cfif>></option>
				<cfloop from="-1" to="2" index="yIndex">
					<cfset vYear = DateFormat(Now(), "yyyy") + yIndex>
					<option value="#vYear#"<cfif form.u_eyear EQ vYear> selected</cfif>>#vYear#</option>
				</cfloop>
				</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="smallb">Event Type:</td>
			<td class="small">
			<select name="u_gametype" class="small">
			<cfoutput query="getGameTypes">
				<option value="#gametype#"<cfif form.u_gametype EQ gametype> selected</cfif>>#gametype#</option>
			</cfoutput>
			</select>
			</td>
		</tr>
		<tr> 
			<td valign="TOP" class="smallb">Opponent:</td>
			<td valign="TOP"> 
				<input type="text" name="u_opponent" value="<cfoutput>#form.u_opponent#</cfoutput>" size="35" class="small">
			</td>
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
			<td valign="TOP" class="small"><b>Status:</b></td>
			<td valign="TOP"> 
				<select name="u_status" class="small">
				<cfoutput query="getGameStatus">
					<option value="#statusid#"<cfif form.u_status EQ statusid> selected</cfif>>#gamestatus#</option>
				</cfoutput>
				</select>
			</td>
		</tr>
		<tr> 
			<td valign="TOP" class="smallb">Other Info:</td>
			<td valign="TOP"> 
				<textarea name="u_desc" cols="30" rows="2"><cfoutput>#form.u_desc#</cfoutput></textarea>
			</td>
		</tr>
		<tr> 
			<td class="smallb">Score:</td>
			<td> 
				<span class="smallb">Us:</span>
				<input type="text" name="u_UsScore" value="<cfoutput>#form.u_UsScore#</cfoutput>" size="3" class="small">
				&nbsp;&nbsp;&nbsp;
				<span class="smallb">Them:</span>
				<input type="text" name="u_ThemScore" value="<cfoutput>#form.u_ThemScore#</cfoutput>" size="3" class="small">
			</td>
		</tr>
	    <tr> 
			<td valign="TOP" class="smallb">Repeat:</td>
			<td class="small"> 
				<input type="radio" name="repeat" value="n" checked class="small">None
				<input type="radio" name="repeat" value="d" class="small">Daily
				<input type="radio" name="repeat" value="ww" class="small">Weekly
				<input type="radio" name="repeat" value="m" class="small">Monthly<br>
				<div align="center">
				For how long: <input type="text" name="repeatvalue" size="2" maxlength="2" class="small">
				</div>
			</td>
		</tr>
	</table>
	</td></tr></table>
		<cfoutput>
			<input type="submit" name="submit" value="#url.action# Game" class="small">
		<cfif url.action EQ "Update">
			<input type="submit" name="delete" value="Delete Game" class="small" onClick="verify();">
		</cfif>
			<input type="reset" class="small">
		</cfoutput>
	<br>
	<input type="button" name="close" value="Close Window" class="small" onClick="window.close()">
	</form>
</td></tr>
</table>

</cfif>
</body>
</html>
