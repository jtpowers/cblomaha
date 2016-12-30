<cfinclude template="security.cfm">
<cf_securityaccess userid="#cookie.Lynx_UserID#" aid="#application.aid#" lid="#url.lid#"dsn="#application.memberDSN#">

<cfset getSectionsHDR = adminObj.getSectionsHeader(#url.lid#)>

<cfset leagueicon = "#rootDir#wsimages/#application.sl_leaguesport#_icon.gif">
<table border="0" width="100%">
<tr valign="top">
	<td width="200" valign="top">
		<table width="200" border="0" cellpadding="3" cellspacing="0" class="hideme">
		<tr><td bgcolor="#C6D6FF">
		<cfoutput>
		<a href="#rootdir#admin/index.cfm" CLASS="link">Website Admin</a><br>
		<a href="index.cfm?lid=#url.lid#" CLASS="link">#application.sl_leaguename# Admin</a><br>
		</cfoutput>
		</td></tr>
	<cfif useraccesslevel GTE 5>
		<tr><td bgcolor="#000000" class="titlesubw">Website Setup</td></tr>
		<tr><td bgcolor="#C6D6FF">
		<cfoutput>
		<!--- <img src="#leagueicon#" width="17" height="17">
		<a href="league.cfm?lid=#url.lid#" CLASS="link">League Settings</a><br> --->
		<img src="#leagueicon#" width="17" height="17">
		<a href="fileupload.cfm?lid=#url.lid#" CLASS="link">Upload Files</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="msgboard.cfm?lid=#url.lid#" CLASS="link">Message Board</a>
		<img src="#rootdir#wsimages/desc.gif" border="0" onMouseover="ddrivetip('To Add/Update Message Board messages.','yellow','150');" onMouseout="hideddrivetip();"><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="alert.cfm?lid=#url.lid#" CLASS="link">Alerts</a>
		<img src="#rootdir#wsimages/desc.gif" border="0" onMouseover="ddrivetip('To Add/Update Alerts. Alerts should only be displayed for 1 to 3 days.','yellow','150');" onMouseout="hideddrivetip();"><br>

		</cfoutput>
		</td></tr>
	</cfif>
	<cfif useraccesslevel GTE 3>
		<tr><td bgcolor="#000000" class="titlesubw">Menu Setup</td></tr>
		<tr><td bgcolor="#C6D6FF">
		<cfoutput>
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
	<cfif useraccesslevel GTE 5>
		<tr><td bgcolor="#000000" class="titlesubw">Calendar Events</td></tr>
		<tr><td bgcolor="#C6D6FF">
		<cfoutput>
		<cfif useraccesslevel GTE 7>
		<img src="#leagueicon#" width="17" height="17">
		<a href="calendar.cfm?lid=#url.lid#" CLASS="link">Calendars</a><br>
		</cfif>
		<img src="#leagueicon#" width="17" height="17">
		<a href="game.cfm?lid=#url.lid#" CLASS="link">Games</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="event.cfm?lid=#url.lid#" CLASS="link">Other Events</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="scorebook.cfm?lid=#url.lid#" CLASS="link">Scorebook</a><br>
		</cfoutput>
		</td></tr>
	</cfif>
		<tr><td bgcolor="#000000" class="titlesubw">League Setup</td></tr>
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
		</cfoutput>
	</cfif>
	<cfif useraccesslevel GTE 7>
		<tr><td bgcolor="#000000" class="titlesubw">Officials</td></tr>
		<tr><td bgcolor="#C6D6FF">
		<cfoutput>
		<img src="#leagueicon#" width="17" height="17">
		<a href="officials.cfm?lid=#url.lid#" CLASS="link">Edit Officials</a><br>
		<img src="#leagueicon#" width="17" height="17">
		<a href="officials_sched.cfm?lid=#url.lid#" CLASS="link">Officials Schedule</a><br>
		</cfoutput>
	</cfif>
&nbsp;
		</td></tr>
		</table>
	</td>
	<td valign="top">
