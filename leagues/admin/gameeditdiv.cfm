<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="url.tid" default="all">
<cfparam name="url.sortby" default="g.gamedate, g.gametime">

<cfif isDefined("url.sid")>
	<cfset form.sid = url.sid>
</cfif>
<cfif isDefined("url.did")>
	<cfset form.did = url.did>
</cfif>

<cfquery name="getSeasons" datasource="#application.memberDSN#">
	Select seasonid, seasonname
	From sl_season
	Where leagueid = #url.lid#
	Order by startdate desc, seasonname
</cfquery>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfquery name="getDivs" datasource="#application.memberDSN#">
	Select s.seasonid, s.seasonname, d.divid, d.divname, d.gender
	From sl_season s, sl_division d
	Where s.seasonid = d.seasonid and
			s.seasonid = #form.sid#
	Order By DivOrder, StartDate, DivName
</cfquery>
<cfif (form.sid NEQ sidCookie) OR Not isDefined("url.did")>
	<cfset url.did="#getDivs.divid#">
</cfif>

<cfif isDefined("form.submit")>
	<cfset addCount = 0>
	<cfloop from="1" to="10" index="gIndex">
		<cfset gmDateEval = "form.gDate#gIndex#">
		<cfset gmDate = Evaluate(gmDateEval)>
		<cfset gmHourEval = "form.gHour#gIndex#">
		<cfset gmHour = Evaluate(gmHourEval)>
		<cfset gmMinEval = "form.gMin#gIndex#">
		<cfset gmMin = Evaluate(gmMinEval)>
		<cfset gmAmPmEval = "form.gAmPm#gIndex#">
		<cfset gmAmPm = Evaluate(gmAmPmEval)>
		<cfset gmHtidEval = "form.gHtid#gIndex#">
		<cfset gmHtid = Evaluate(gmHtidEval)>
		<cfset gmVtidEval = "form.gVtid#gIndex#">
		<cfset gmVtid = Evaluate(gmVtidEval)>
		<cfset gmLocaEval = "form.gLoca#gIndex#">
		<cfset gmLoca = Evaluate(gmLocaEval)>
		<cfset gmGameNbrEval = "form.gGameNbr#gIndex#">
		<cfset gmGameNbr = Evaluate(gmGameNbrEval)>

		<cfif IsDate(gmDate)>
			<cfset gamedate = "#gmDate#">
			<cfif gmAmPm EQ "a" AND gmHour EQ 12>
				<cfset gametime = "00:#gmMin#:00">
			<cfelseif gmAmPm EQ "p" AND gmHour LT 12>
				<cfset gmHour = gmHour + 12>
				<cfset gametime = "#gmHour#:#gmMin#:00">
			<cfelseif gmAmPm EQ "tbd">
				<cfset gametime = "">
			<cfelse>
				<cfset gametime = "#gmHour#:#gmMin#:00">
			</cfif>
			<cfset locaid = ListFirst(gmLoca)>
			<cfset cid = ListLast(gmLoca)>
			<cfquery name="AddGame" datasource="#application.memberDSN#">
				Insert Into sl_game (H_TeamID, V_TeamID, GameDate, GameTime, LocationID, CourtID, SeasonID, GameNbr)
				Values(#gmHtid#,  #gmVtid#, 
							'#DateFormat(gamedate, "yyyy-mm-dd")#', 
							<cfif LEN(gametime) GT 0>'#gametime#'<cfelse>NULL</cfif>,
							#locaid#, 
							#cid#,
							#form.sid#,
							<cfif LEN(gmGameNbr) GT 0>'#gmGameNbr#'<cfelse>NULL</cfif>)
			</cfquery>
			<cfset addCount = addCount + 1>
		</cfif>
	</cfloop>
</cfif>

<cfquery name="getTeams" datasource="#application.memberDSN#">
	Select *
	From sl_team
	Where divid = #form.did#
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

<cfset pageTitle = "Edit Games">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
    <div class="col-xs-12 col-md-8">

<table class="table table-condensed no-border">
	<tr>
		<td align="left">
			<cfoutput>
			<form action="gameeditdiv.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
			</cfoutput>
			<table class="table table-condensed no-border">
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
		<td align="left">
		<form action="gameeditdiv.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
			<input type="hidden" name="sid" value="<cfoutput>#form.sid#</cfoutput>">
			<table class="table table-bordered table-condensed">
			<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>"><td class="titlesmw">Search Criteria</td></tr>
			<tr><td>
				<table class="table table-condensed no-border">
				<tr>
					<td class="smallb">Division:</td>
					<td>
						<select name="did" class="small" onChange="submit();">
						<cfoutput query="getDivs">
							<option value="#divid#"<cfif form.did EQ divid> selected</cfif>>#gender# #divname#</option>
						</cfoutput>
						</select>
					</td>
					<td>
						<input type="submit" name="go" value="Go" class="small">
					</td>
				</tr>
				</table>
			</td></tr></table>
		</form>
		</td>
	</tr>
	<cfif isDefined("addCount")>
	<tr>
		<td align="center" class="smallr">
			<cfoutput>#addCount#</cfoutput> Games Added
		</td>
	</tr>
	</cfif>
	<form action="gameeditdiv.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
	<input type="hidden" name="sid" value="<cfoutput>#form.sid#</cfoutput>">
	<input type="hidden" name="did" value="<cfoutput>#form.did#</cfoutput>">
	<tr>
		<td valign="top">
			<table class="table table-hover table-bordered table-striped table-condensed">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw">Date<br>(mm/dd/yyyy)</td>
					<td class="titlesmw">Time</td>
					<td class="titlesmw">Game #</td>
					<td class="titlesmw">Visitor Team</td>
					<td class="titlesmw">Home Team</td>
					<td class="titlesmw">Location</td>
				</tr>
				<cfloop from="1" to="10" index="gIndex">
					<tr class="small">
						<td class="small">
							<cfoutput><input type="text" name="gDate#gIndex#" value="" size="10" class="small"></cfoutput>
						</td>
						<td class="small" nowrap>
							<cfoutput>
							<input type="text" name="gHour#gIndex#" value="" size="2" class="small">
							<input type="text" name="gMin#gIndex#" value="00" size="2" class="small">
							<select name="gAmPm#gIndex#" class="small">
								<option value="a">AM</option>
								<option value="p" selected>PM</option>
								<option value="tbd">TBD</option>
							</select>
							</cfoutput>
						</td>
						<td class="small">
							<cfoutput><input type="text" name="gGameNbr#gIndex#" value="" size="6"></cfoutput>
						</td>
						<td class="small">
							<select name="gVtid<cfoutput>#gIndex#</cfoutput>" class="small">
							<cfoutput query="getTeams">
								<option value="#TeamID#">#leaguenbr#. #Name#</option>
							</cfoutput>
								<option value="0">TBD</option>
							</select>
						</td>
						<td class="small">
							<select name="gHtid<cfoutput>#gIndex#</cfoutput>" class="small">
							<cfoutput query="getTeams">
								<option value="#TeamID#">#leaguenbr#. #Name#</option>
							</cfoutput>
							</select>
						</td>
						<td class="small">
							<select name="gLoca<cfoutput>#gIndex#</cfoutput>" class="small">
							<cfoutput query="getLocations">
								<option value="#locationid#,#courtid#">#locationname# - #courtname#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
				</cfloop>
				<tr><td colspan="5" align="center" class="small">
					<input type="submit" name="submit" value="Add Games" class="small">
					<input type="reset" class="small">
				</td></tr>
			</table>
		</td>
	</tr>
	</form>
</table>
    </div>
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
