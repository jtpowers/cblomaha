<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfset errmsg = "">
<cfset rootdir = "../">
<cfparam name="url.lid" default="1">

<cfset getSeasons = leagueObj.getSeasons(#url.lid#)>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfset getDivisions = leagueObj.getDivisions(#url.lid#, #form.sid#)>

<cfif form.sid NEQ sidCookie>
	<cfset form.did = getDivisions.divid[1]>
</cfif>
<cfparam name="form.did" default="#getDivisions.divid#">
<cfif form.did GT "">
	<cfset getStandings = leagueObj.getStandings(#form.did#)>
    
    <cfset getDivision = leagueObj.getDivision(#form.did#)>
</cfif>

<cfset pageTitle = "Standings">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<cfinclude template="#rootdir#ssi/header_scores.cfm">
<center>
<table class="table table-condensed table-responsive table-noborders" style="width: 100%">
	<tr>
		<td colspan="3" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<form action="standings.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
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
		<cfif form.did GT "">
			<tr>
				<td class="smallb">Division:</td>
				<td>
					<select name="did" class="small" onChange="submit();">
					<cfoutput query="getDivisions">
						<option value="#divid#"<cfif form.did EQ divid> SELECTED</cfif>>#gender# #divname#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
	</cfif>
			</table>
		</td>
	</tr>
	</form>
	<tr>
		<td>&nbsp;</td>
	</tr>
<cfif form.did GT "">
	<tr>
		<td>
			<cfoutput>#getDivision.seasonname# - #getDivision.gender# #getDivision.divname#</cfoutput> Standings
			<table class="table table-responsive table-hover table-bordered table-striped table-condensed">
              <thead>
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<th class="text-center titlesmw">Name</th>
					<th class="text-center titlesmw">Won</th>
					<th class="text-center titlesmw">Lost</th>
					<th class="text-center titlesmw">Tied</th>
					<th class="text-center titlesmw">Pct.</th>
					<th class="text-center titlesmw">PF</th>
					<th class="text-center titlesmw">PA</th>
				</tr>
              </thead>
              <tbody>
				<cfset colColor = "#application.sl_arcolor#">
				<cfoutput query="getStandings">
					<cfif colColor EQ "#application.sl_arcolor#">
						<cfset colColor = "FFFFFF">
					<cfelse>
						<cfset colColor = "#application.sl_arcolor#">
					</cfif>
					<TR bgcolor="#colColor#">
						<td class="small">#name#</td>
						<td class="small" align="center">#wins#</td>
						<td class="small" align="center">#losses#</td>
						<td class="small" align="center">#ties#</td>
						<td class="small" align="center">#NumberFormat(winpct, "9.999")#</td>
						<td class="small" align="center"><cfif isNumeric(pointsfor)>#pointsfor#<cfelse>0</cfif></td>
						<td class="small" align="center"><cfif isNumeric(pointsagainst)>#pointsagainst#<cfelse>0</cfif></td>
					</tr>
				</cfoutput>
              </tbody>
			</table>
		</td>
	</tr>
<cfelse>
	<tr>
		<td colspan="3" class="titlesub" align="center">
			<br><br>There are no Divisions or Teams for this Season Yet.</td>
	</tr>
</cfif>
</table>
</center>
<cfinclude template="#rootdir#ssi/footer_ad.cfm">
</div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
