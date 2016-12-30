<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfquery name="getSeasons" datasource="#application.memberDSN#">
	Select *
	From sl_season
	Where LeagueID = #url.lid#
	Order by StartDate desc, SeasonName
</cfquery>

<cfif isDefined("form.sid")>
<cfelse>
	<cfset form.sid = "#getSeasons.seasonid[1]#">
</cfif>

<cfquery name="getDivs" datasource="#application.memberDSN#">
	Select divname, gender, seasonid, divid
	From sl_division
	Where seasonid = #form.sid#
	Order by divname
</cfquery>

<cfquery name="getGameDates" datasource="#application.memberDSN#">
	Select g.gamedate
	From sl_game g, sl_team t, sl_division d
	Where t.teamid = g.H_Teamid and
			d.divid = t.divid and
			d.seasonid = #form.sid#
	Group by gamedate
	Order by gamedate
</cfquery>

<cfcookie name="cblsid" value="#form.sid#" expires="never">

<cfset pageTitle = "Scorebook">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-4 col-xs-hidden col-sm-hidden"></div>
    <div class="col-md-4">

<table class="table table-condensed no-border">
	<form action="scorebook.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
	<tr>
		<td>
			<table class="table table-condensed no-border">
				<tr>
					<td class="smallb">Season:</td>
					<td>
						<select name="sid" class="small" onChange="document.forms[0].submit();">
						<cfoutput query="getSeasons">
							<option value="#seasonid#"<cfif seasonid EQ form.sid> selected</cfif>>#seasonname#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</form>
	<form action="print.cfm?lid=<cfoutput>#url.lid#</cfoutput>" target="_blank" method="post">
	<input type="hidden" name="sid" value="<cfoutput>#form.sid#</cfoutput>">
	<tr>
		<td valign="top" class="titlesub">Print Scoresheets:
			<table class="table table-condensed table-bordered">
			<tr><td>
				<table class="table table-condensed no-border">
				<tr>
					<td class="smallb">Division:</td>
					<td>
						<select name="did" class="small">
							<option value="all">All</option>
						<cfoutput query="getDivs">
							<option value="#divid#">#gender# #divname#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">Game Date:</td>
					<td>
						<cfset selectNotDone = 1>
						<select name="gDate" class="small">
						<cfoutput query="getGameDates">
							<cfif DateFormat(gamedate, 'yyyymmdd') GTE DateFormat(now(), 'yyyymmdd') 
									AND selectNotDone>
								<cfset selectNotDone = 0>
								<cfset isSelected = " selected">
							<cfelse>
								<cfset isSelected = "">
							</cfif>
							<option value="#DateFormat(gamedate, 'yyyy-mm-dd')#"#isSelected#>#DateFormat(gamedate, 'ddd, mm/dd/yyyy')#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">Sort By:</td>
					<td>
						<select name="sortby" class="small">
							<option value="loca.shortname, c.courtname, g.gametime">Court & Game Time</option>
							<option value="d.divid">Division</option>
							<option value="g.gametime">Game Time</option>
						</select>
					</td>
				</tr>
				<tr><td colspan="2">
					<div align="center">
						<input type="submit" name="formathtml" value="Print" class="small"> 
						<!---<input type="submit" name="formatpdf" value="Print to PDF" class="small">---> 
					</div>
				</td></tr>
				</table>
			</td></tr></table>
		</td>
	</tr>
	</form>
</table>
    </div>
	<div class="clearfix col-md-4 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
