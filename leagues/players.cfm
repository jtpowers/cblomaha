<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfset errmsg = "">
<cfset rootdir = "../">
<cfparam name="url.lid" default="1">

<cfif isDefined("url.did")><cfset form.did = url.did></cfif>
<cfif isDefined("url.tid")><cfset form.tid = url.tid></cfif>

<cfset getSeasons = leagueObj.getSeasons(#url.lid#)>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfset getDivisions = leagueObj.getDivisions(#url.lid#, #form.sid#)>

<cfif form.sid NEQ sidCookie>
	<cfset form.did = getDivisions.divid[1]>
</cfif>
<cfparam name="form.did" default="#getDivisions.divid[1]#">

<cfset getTeams = leagueObj.getTeams(#form.did#)>
<cfif isDefined("form.didold") AND form.didold NEQ form.did><cfset form.tid = getTeams.teamid[1]></cfif>
<cfparam name="form.tid" default="#getTeams.teamid[1]#">

<cfset getPlayers = leagueObj.getPlayers(#form.tid#)>
<cfset getTeamInfo = leagueObj.getTeam(#form.tid#)>

<cfset pageTitle = "Players">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<cfinclude template="#rootdir#ssi/header_scores.cfm">
<div class="row">
	<div class="col-xs-12 text-center titlemain">
		<cfoutput>#pageTitle#</cfoutput><br><br>
	</div>
	<form action="players.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
	<input type="hidden" name="didold" value="<cfoutput>#form.did#</cfoutput>">
	<div class="col-xs-12 text-center">
    	<div class="form-group">
			<label class="smallb">Season:</label>
			<select name="sid" class="small" onChange="submit();">
				<cfoutput query="getSeasons">
                    <option value="#SeasonID#"<cfif SeasonID EQ form.sid> SELECTED</cfif>>#SeasonName#</option>
                </cfoutput>
            </select>
        </div>
    </div>
	<div class="col-xs-12 col-sm-6 text-center">
    	<div class="form-group">
			<label class="smallb">Division:</label>
			<select name="did" class="small" onChange="submit();">
				<cfoutput query="getDivisions">
					<option value="#divid#"<cfif form.did EQ divid> SELECTED</cfif>>#gender# #divname#</option>
				</cfoutput>
			</select>
        </div>
    </div>
	<div class="col-xs-12 col-sm-6 text-center">
    	<div class="form-group">
			<label class="smallb">Team: </label>
			<select name="tid" class="small" onChange="submit();">
				<cfoutput query="getTeams">
					<option value="#teamid#"<cfif form.tid EQ teamid> SELECTED</cfif>><cfif leaguenbr GT "">#leaguenbr#. </cfif>#name#</option>
				</cfoutput>
			</select>
        </div>
    </div>
	</form>
	<div class="col-xs-12 text-center titlesub">
		<cfoutput>#getTeamInfo.name#</cfoutput> Players
	</div>
    <div class="clearfix hidden-xs hidden-sm col-md-2"></div>
	<div class="col-xs-12 col-md-8">
        <table class="table table-responsive table-hover table-bordered table-striped table-condensed">
          <thead>
            <tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
                <th class="text-center titlesmw" rowspan="2">#</th>
                <th class="text-center titlesmw" rowspan="2">Name</th>
            </tr>
          </thead>
          <tbody>
            <tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
            </tr>
            <cfset colColor = "C6D6FF">
            <cfset h_alt = 0>
            <cfoutput query="getPlayers">
                <cfset totpoints = 0>
                <cfset totgames = 0>
                <cfset pointsavg = 0>
                <cfif colColor EQ "C6D6FF">
                    <cfset colColor = "FFFFFF">
                <cfelse>
                    <cfset colColor = "C6D6FF">
                </cfif>
                <cfif alternate EQ 1 AND h_alt EQ 0>
                    <tr bgcolor="#colColor#">
                    <td class="smallb" colspan="5" align="center">Alternates</td>
                    </tr>
                    <cfset h_alt = 1>
                </cfif>
                <tr>
                    <td class="text-center small"><cfif  jerseynbr LT 999>#jerseynbr#<cfelse>&nbsp;</cfif></td>
                    <td class="small">#playername#</td>
                </tr>
            </cfoutput>
          </tbody>
        </table>
	</div>
    <div class="clearfix hidden-xs hidden-sm col-md-2"></div>
	<cfif getTeamInfo.TeamInfo GT "">
		<div class="col-xs-12">
			<BR><cfoutput>#getTeamInfo.TeamInfo#</cfoutput><BR><BR></td>
		</div>				
	</cfif>
</div>

<cfinclude template="#rootdir#ssi/footer_ad.cfm">
</div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
