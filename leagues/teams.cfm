<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfset errmsg = "">
<cfset rootdir = "../">
<cfparam name="url.lid" default="1">

<cfset getSeasons = leagueObj.getSeasons(#url.lid#)>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfif isDefined("url.did")><cfset form.did = url.did></cfif>

<cfset getDivisions = leagueObj.getDivisions(#url.lid#, #form.sid#)>

<cfif form.sid NEQ sidCookie>
	<cfset form.did = getDivisions.divid[1]>
</cfif>

<cfparam name="form.did" default="#getDivisions.divid#">

<cfif form.did GT "">
	<cfset getTeams = leagueObj.getTeams(#form.did#)>
	<cfset getDivInfo = leagueObj.getDivision(#form.did#)>
</cfif>

<cfset pageTitle = "Teams">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<cfinclude template="#rootdir#ssi/header_scores.cfm">

<div class="row">
	<div class="col-xs-12 text-center titlemain">
		<cfoutput>#pageTitle#</cfoutput><br><br>
	</div>
	<form action="teams.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
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
	<cfif form.did GT "" AND application.sl_leaguetype EQ "League">
        <div class="col-xs-12 text-center">
            <div class="form-group">
                <label class="smallb">Division:</label>
                <select name="did" class="small" onChange="submit();">
                    <cfoutput query="getDivisions">
                        <option value="#divid#"<cfif form.did EQ divid> SELECTED</cfif>>#divname#</option>
                    </cfoutput>
                </select>
            </div>
        </div>
    </cfif>
	</form>
	<cfif form.did GT "">
    	<div class="col-xs-12 text-center titlesub">
			<cfoutput>#getDivInfo.divname# 
			<cfif getDivInfo.director GT "">League Director: 
				<cfif getDivInfo.diremail GT ""><a href="mailto:#getDivInfo.diremail#" class="link">#getDivInfo.director#</a><cfelse>#getDivInfo.director#</cfif>
				<cfif getDivInfo.dirphone GT "">at #getDivInfo.dirphone#</cfif>
            </cfif>
			</cfoutput>
		</div>
		<cfif getDivInfo.Rules GT "">
			<div class="col-xs-12 text-center">
				<cfoutput><a href="rules.cfm?did=#getDivInfo.divid#" class="link" target="_blank">Rules</a></cfoutput>
            </div>
		</cfif>
	    <div class="col-xs-12">
            <table class="table table-responsive table-hover table-bordered table-striped table-condensed">
              <thead>
                <tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
                <cfif application.sl_leaguetype EQ "League">
                    <th class="text-center hidden-xs titlesmw">#</th>
                </cfif>
                    <th class="text-center titlesmw">Name</th>
                    <th class="text-center hidden-xs titlesmw">Coach</th>
                    <th class="text-center hidden-xs titlesmw">Phone</th>
                    <th class="text-center hidden-xs titlesmw">Email</th>
                <cfif application.sl_ShowPlayers>
                    <th class="text-center titlesmw">&nbsp;</th>
                </cfif>
                    <th class="text-center titlesmw">&nbsp;</th>
                </tr>
              </thead>
              <tbody>
            <cfoutput query="getTeams">
            <cfif name NEQ "All Teams">
                <tr>
                <cfif application.sl_leaguetype EQ "League">
                    <td class="small hidden-xs">#leaguenbr#</td>
                </cfif>
                    <td class="small">#name#</td>
                    <td class="small hidden-xs">#coachname#&nbsp;</td>
                    <td class="small hidden-xs">#phone#&nbsp;</td>
                    <td class="small hidden-xs">
                        <cfif LEN(email) GT 0>
                            <a href="mailto::#email#" class="linksm">#email#</a>
                        <cfelse>
                            &nbsp;
                        </cfif>
                    </td>
                <cfif application.sl_ShowPlayers>
                    <td><a href="players.cfm?lid=#url.lid#&tid=#Teamid#&did=#Divid#" class="linksm">Players</a></td>
                </cfif>
                	<td><a href="schedules.cfm?lid=#url.lid#&tid=#Teamid#&did=#Divid#" class="linksm">Games</a></td>
                </tr>
            </cfif>
            </cfoutput>
            </tbody>
        	</table>
    	</div>
	<cfelse>
		<div class="col-xs-12 text-center titlesub">
			<br><br>There are no Divisions or Teams for this Season Yet.</td>
		</div>
	</cfif>
</div>

<cfinclude template="#rootdir#ssi/footer_ad.cfm">
</div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
