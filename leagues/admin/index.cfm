<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfif isDefined("cookie.lynxbbsid") AND cookie.lynxbbsid GT "">
	<cfset checkSeason = leagueObj.getSeason(#url.lid#,#cookie.lynxbbsid#)>
	<cfif checkSeason.RecordCount EQ 0>
		<cfset getSeasonLast = leagueObj.getSeason(#url.lid#)>
		<cfcookie name="lynxbbsid" value="#getSeasonLast.seasonid#" expires="never">
	</cfif>
</cfif>

<cfset pageTitle = "League Manager">

<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-3 col-xs-hidden col-sm-hidden"></div>
    <div class="col-md-6">
<cfset leagueicon = "#rootDir#wsimages/#application.sl_leaguesport#_icon.gif">
<table class="table table-condensed no-border">
<tr valign="top">
	<td valign="top">
		<table class="table table-condensed no-border">
	<cfif useraccesslevel GTE 5>
		<tr><td bgcolor="#000000" class="titlesubw">Messaging</td></tr>
		<tr><td bgcolor="#C6D6FF">
		<cfoutput>
		<!--- <img src="#leagueicon#" width="17" height="17">
		<a href="league.cfm?lid=#url.lid#" CLASS="link">League Settings</a><br> --->
		<img src="#leagueicon#" width="17" height="17">
		<a href="alert.cfm?lid=#url.lid#" CLASS="link">Alerts</a>
		<img src="#rootdir#wsimages/desc.gif" border="0" onMouseover="ddrivetip('To Add/Update Alerts. Alerts should only be displayed for 1 to 3 days.','yellow','150');" onMouseout="hideddrivetip();"><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="msgboard.cfm?lid=#url.lid#" CLASS="link">Message Board</a>
		<img src="#rootdir#wsimages/desc.gif" border="0" onMouseover="ddrivetip('To Add/Update Message Board messages.','yellow','150');" onMouseout="hideddrivetip();"><br>

		</cfoutput>
		</td></tr>
	</cfif>
	<cfif useraccesslevel GTE 3>
		<tr><td bgcolor="#000000" class="titlesubw">Content Management</td></tr>
		<tr><td bgcolor="#C6D6FF">
		<cfoutput>
		<img src="#leagueicon#" width="17" height="17">
		<a href="fileupload.cfm?lid=#url.lid#" CLASS="link">Upload Files</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="sections.cfm?lid=#url.lid#" CLASS="link">Menu Sections</a><br>
		</cfoutput>
		<cfoutput query="getSectionsHDR">
			<img src="#rootDir#wsimages/space.gif" width="25" height="17">
			<img src="#leagueicon#" width="17" height="17">
			<a href="sectionitems.cfm?lid=#url.lid#&cat=#value_1#" CLASS="link">#value_2#</a><br>
		</cfoutput>
		</td></tr>
	</cfif>
		<tr><td bgcolor="#000000" class="titlesubw">Scheduling</td></tr>
		<tr><td bgcolor="#C6D6FF">
	<cfif useraccesslevel GTE 7>
		<cfoutput>
		<img src="#leagueicon#" width="17" height="17">
		<a href="season.cfm?lid=#url.lid#" CLASS="link">Seasons</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="division.cfm?lid=#url.lid#" CLASS="link">Divisions</a><br>
		</cfoutput>
	</cfif>
	<cfif useraccesslevel GTE 5>
		<cfoutput>
		<img src="#leagueicon#" width="17" height="17">
		<a href="team.cfm?lid=#url.lid#" CLASS="link">Teams</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="player.cfm?lid=#url.lid#" CLASS="link">Players</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="location.cfm?lid=#url.lid#" CLASS="link">Locations</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="game.cfm?lid=#url.lid#" CLASS="link">Games</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="scorebook.cfm?lid=#url.lid#" CLASS="link">Scorebook</a><br>
		<cfif useraccesslevel GTE 7>
		<img src="#leagueicon#" width="17" height="17">
		<a href="calendar.cfm?lid=#url.lid#" CLASS="link">Calendars</a><br>
		</cfif>
		<img src="#leagueicon#" width="17" height="17">
		<a href="event.cfm?lid=#url.lid#" CLASS="link">Calendar Events</a><br>
		</cfoutput>
	</cfif>
	<!--- <cfif useraccesslevel GTE 7>
		<tr><td bgcolor="#000000" class="titlesubw">Officials</td></tr>
		<tr><td bgcolor="#C6D6FF">
		<cfoutput>
		<img src="#leagueicon#" width="17" height="17">
		<a href="officials.cfm?lid=#url.lid#" CLASS="link">Edit Officials</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="officials_sched.cfm?lid=#url.lid#" CLASS="link">Officials Schedule</a><br>
		</cfoutput>
	</cfif> --->
&nbsp;
		</td></tr>
		</table>
	</td>

</td></tr></table>

    </div>
	<div class="clearfix col-md-3 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
