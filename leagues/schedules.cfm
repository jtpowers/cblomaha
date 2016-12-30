<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfset errmsg = "">
<cfset rootdir = "../">

<cfif isDefined("url.did")><cfset form.did = url.did></cfif>
<cfif isDefined("url.tid")><cfset form.tid = url.tid></cfif>
<cfparam name="form.u_locaid" default="all">
<cfparam name="form.refid" default="all">
<cfparam name="url.lid" default="1">

<cfset getSeasons = leagueObj.getSeasons(#url.lid#)>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfset getDivisions = leagueObj.getDivisions(#url.lid#, #form.sid#)>

<cfif form.sid NEQ sidCookie>
	<cfset form.did = getDivisions.divid[1]>
</cfif>
<cfparam name="form.did" default="#getDivisions.divid[1]#">

<cfif form.did GT "">
	<cfif form.did NEQ "all">
    	<cfset getTeams = leagueObj.getTeams(#form.did#)>
		<cfset sortby = "g.gamedate, g.gametime">
	<cfelse>
		<cfset sortby = "loca.locationname, c.courtname, g.gamedate, g.gametime">
	</cfif>
	<cfif isDefined("form.didold") AND form.didold NEQ form.did><cfset form.tid = "all"></cfif>
	<cfparam name="form.tid" default="all">
	
    <cfset getGameDates = leagueObj.getGameDates(#form.sid#)>
	<cfparam name="form.gdate" default="current">
	
    <cfset getGames = leagueObj.getGameSchedule(#form.sid#,#form.did#,#form.tid#,#form.gDate#,#form.u_locaid#,#form.refid#)>
</cfif>

<cfset getRefs = leagueObj.getRefs(#url.lid#)>
<cfset getLocations = leagueObj.getLocationsList(#url.lid#,#form.sid#)>

<cfset pageTitle = "Schedule">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<cfinclude template="#rootdir#ssi/header_empty.cfm">
<center>
<table class="table table-condensed table-responsive table-noborders" style="width: 100%">
	<tr>
		<td class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br></td>
	</tr>
	<form action="schedules.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
	<input type="hidden" name="didold" value="<cfoutput>#form.did#</cfoutput>">
	<tr>
		<td align="center">
			<table>
			<tr>
				<td class="smallb">Season:</td>
				<td>
					<select name="sid" class="small" onChange="submit();">
					<cfoutput query="getSeasons">
						<option value="#SeasonID#"<cfif SeasonID EQ form.sid> SELECTED</cfif>>#SeasonName#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
			</table>
		</td>
	</tr>
<cfif form.did GT "">
	<tr>
		<td align="center">
			<cfif form.did EQ "all">
				<div class="col-sm-2"></div>
			</cfif>
			<div class="col-sm-4">
				<span class="smallb">Division:</span><br>
				<select name="did" class="small" onChange="submit();">
					<option value="all"<cfif form.did EQ "all"> SELECTED</cfif>>All</option>
				<cfoutput query="getDivisions">
					<option value="#divid#"<cfif form.did EQ divid> SELECTED</cfif>>#gender# #divname#</option>
				</cfoutput>
				</select>
			</div>
			<cfif form.did NEQ "all">
			<div class="col-sm-4">
				<span class="smallb">Team: </span><br>
				<select name="tid" class="small" onChange="submit();">
					<option value="all"<cfif form.tid EQ "all"> SELECTED</cfif>>All</option>
				<cfoutput query="getTeams">
					<option value="#teamid#"<cfif form.tid EQ teamid> SELECTED</cfif>>#name#</option>
				</cfoutput>
				</select>
			</div>
			</cfif>
			<div class="col-sm-2">
				<span class="smallb">Game Date: </span><br>
				<select name="gdate" class="small" onChange="submit();">
					<option value="current"<cfif form.gdate EQ "current"> SELECTED</cfif>>Current</option>
					<option value="all"<cfif form.gdate EQ "all"> SELECTED</cfif>>All</option>
				<cfoutput query="getGameDates">
					<option value="#gamedate#"<cfif form.gdate EQ gamedate> SELECTED</cfif>>#DateFormat(gamedate, "mmm/dd/yyyy")#</option>
				</cfoutput>
				</select>
			</div>
			<div class="col-sm-2">
				<span class="smallb">Location: </span><br>
				<select name="u_locaid" class="small" onChange="submit();">
					<option value="all"<cfif form.u_locaid EQ "all"> SELECTED</cfif>>All</option>
				<cfoutput query="getLocations">
					<option value="#locationid#"<cfif form.u_locaid EQ locationid> selected</cfif>>#shortname#</option>
				</cfoutput>
				</select>
			</div>
			<cfif form.did EQ "all">
				<div class="col-sm-2"></div>
			</cfif>
		</td>
	</tr>
</cfif>
	</form>
<cfif form.did GT "">
	<tr>
		<td align="center">
			<cfoutput>
			<a href="schedprint.cfm?lid=#url.lid#&sid=#form.sid#&did=#form.did#&tid=#form.tid#&gdate=#form.gdate#&locaid=#form.u_locaid#" class="linksm"  target="_blank">Print Schedule</a>
			</cfoutput>
			<br><div class="small warning">*** Bold Games are Schedule Change Games ***</div>
		</td>
	</tr>
	<tr>
		<td valign="top" class="titlesub" align="center">
        	<div class="home-sched">
			<table class="table table-responsive table-hover table-bordered table-striped table-condensed">
			<thead>
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<th class="text-center titlesmw">Date</th>
					<th class="text-center titlesmw">Time</th>
				<cfif application.sl_leaguetype NEQ "League">
					<th class="text-center titlesmw">Type</th>
				</cfif>
					<th class="text-center titlesmw"><cfif application.sl_leaguetype EQ "League">Home Team<cfelse>Team</cfif></th>
					<th class="text-center titlesmw"><cfif application.sl_leaguetype EQ "League">Visitor Team<cfelse>Opponent</cfif></th>
					<th class="text-center titlesmw">Score</th>
					<th class="text-center titlesmw">Location</th>
				<cfif form.did EQ "all">
					<th class="text-center titlesmw">Division</th>
				</cfif>
				</tr>
				</thead>
				<cfset changeHold = "">
				<cfset gColor = "#application.sl_arcolor#">
				<tbody>
				<cfoutput query="getGames">
					<cfif form.did EQ "all">
						<cfset locacourt = "#locationname# - #courtname#">
					</cfif>
					<tr>
						<cfif schedchange GT 0 AND DateFormat(GameDate, "yyyymmdd") GTE DateFormat(Now(), "yyyymmdd")>
							<cfset schedClass = "small warning">
						<cfelseif status NEQ 1>
							<cfset schedClass = "small danger">
						<cfelse>
							<cfset schedClass = "small">
						</cfif>
						<td class="#schedClass# hidden-xs hidden-sm">#DateFormat(GameDate, "ddd mm/dd/yyyy")#</td>
						<td class="#schedClass# hidden-md hidden-lg">#DateFormat(GameDate, "mm/dd/yyyy")#</td>
						<td class="#schedClass#">#TimeFormat(GameTime, "h:mm tt")#<cfif EndTime GT "">-#TimeFormat(EndTime, "h:mm tt")#</cfif></td>
					<cfif application.sl_leaguetype NEQ "League">
						<td class="#schedClass#">
							<cfif status EQ 2>Cancelled<cfelseif status EQ 3>Postponed<cfelse>#GameType#</cfif>&nbsp;
						</td>
					</cfif>
						<td class=<cfif H_Points GT V_Points>"smallb"<cfelseif hteam EQ "Bye">"smallr"<cfelse>"#schedClass#"</cfif>>
							<cfif hlnbr GT "">#hlnbr#. </cfif>#hteam#
						</td>
						<td class=<cfif H_Points LT V_Points>"smallb"<cfelseif vteam EQ "Bye">"smallr"<cfelse>"#schedClass#"</cfif>>
							<cfif vlnbr GT "">#vlnbr#. </cfif>#vteam#&nbsp;
						</td>
						<td align="center" class="#schedClass#">
						<cfif H_Points GT "">
							 #H_Points# - #V_Points#
						<cfelse>
							&nbsp;
						</cfif>
						</td>
						<td class="#schedClass#">#shortname#<cfif courtname GT ""> - #courtname#</cfif></td>
					<cfif form.did EQ "all">
						<td class="small">#divname#</td>
					</cfif>
					</tr>
				</cfoutput>
				</tbody>
			</table>
            </div>
		</td>
	</tr>
<cfelse>
	<tr>
		<td class="titlesub" align="center">
			<br><br>There are no Divisions or Teams for this Season Yet.</td>
	</tr>
</cfif>
</table>
</center>
<cfinclude template="#rootdir#ssi/footer_ad.cfm">
</div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
