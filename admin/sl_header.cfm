<cfinclude template="security.cfm">
<cf_securityaccess userid="#cookie.Lynx_UserID#" aid="#application.aid#" dsn="#memberDSN#">

<cfquery name="getSectionsHDR" datasource="#memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'MenuSection' and AssocID = #application.aid# and LeagueID is NULL
	Order by Value_4
</cfquery>

<cfquery name="getLeaguesAdminHD" datasource="#memberDSN#">
	Select *
	From sl_league
	Where associd = #application.aid#
</cfquery>
<cfset leagueicon = "#rootDir#wsimages/menubullet.gif">
<table border="0" width="100%">
<tr valign="top">
	<td width="200" valign="top">
		<table width="200" border="0" cellpadding="3" cellspacing="0" class="hideme">
		<tr><td bgcolor="#C6D6FF">
		<a href="index.cfm" CLASS="link">Admin Home</a><br>
		</td></tr>
		<tr><td bgcolor="#000000" class="titlesubw">Website Setup</td></tr>
		<tr><td bgcolor="#C6D6FF">
		<cfoutput>
	<cfif useraccesslevel GTE 9>
		<img src="#leagueicon#" width="17" height="17">
		<a href="site.cfm" CLASS="link">Site Settings</a><br>
	</cfif>
		<img src="#leagueicon#" width="17" height="17">
		<a href="staff.cfm" CLASS="link">Admin User Setup</a><br>
	<cfif useraccesslevel GTE 9>
		<img src="#leagueicon#" width="17" height="17">
		<a href="member.cfm" CLASS="link">Notification Members</a><br>
	</cfif>
	<cfif useraccesslevel GTE 5>
		<img src="#leagueicon#" width="17" height="17">
		<a href="fileupload.cfm" CLASS="link">Upload Files</a><br>
		<!--- <img src="#leagueicon#" width="17" height="17">
		<a href="ads.cfm" CLASS="link">Advertisers</a><br> --->
		<cfif cookie.Lynx_UserID EQ 5>
			<img src="#leagueicon#" width="17" height="17">
			<a href="alert.cfm" CLASS="link">Alerts</a><br>
		</cfif>
	</cfif>
		</cfoutput>
		</td></tr>
	<cfif getLeaguesAdminHD.RecordCount GT 1>
		<cfif useraccesslevel GTE 5>
			<tr><td bgcolor="#000000" class="titlesubw">Menu Setup</td></tr>
			<tr><td bgcolor="#C6D6FF">
			<cfoutput>
			<img src="#leagueicon#" width="17" height="17">
			</cfoutput>
			<a href="sections.cfm" CLASS="link">Menu Sections</a><br>
			<cfoutput query="getSectionsHDR">
				<img src="../wsimages/space.gif" width="25" height="17">
				<a href="sectionitems.cfm?cat=#value_1#" CLASS="link">#value_3#</a><br>
			</cfoutput>
			</td></tr>
			<tr><td bgcolor="#000000" class="titlesubw">Calendar Events</td></tr>
			<tr><td bgcolor="#C6D6FF">
			<cfoutput>
			<img src="#leagueicon#" width="17" height="17">
			<a href="calendar.cfm" CLASS="link">Calendars</a><br>
			<img src="#leagueicon#" width="17" height="17">
			<a href="event.cfm" CLASS="link">Calendar Events</a><br>
			</cfoutput>
			</td></tr>
		</cfif>
	</cfif>
		<tr><td bgcolor="#000000" class="titlesubw">Leagues</td></tr>
		<tr><td bgcolor="#C6D6FF">
		<cfoutput query="getLeaguesAdminHD">
			<img src="#leagueicon#" width="17" height="17">
			<a href="#rootDir#leagues/admin/index.cfm?lid=#leagueid#" CLASS="link">#leaguename# Admin</a><br>
		</cfoutput>
		</td></tr>
		<tr><td bgcolor="#000000" class="titlesubw">Sports Events</td></tr>
		<tr><td bgcolor="#C6D6FF">
			<cfoutput>
			<img src="#leagueicon#" width="17" height="17">
			<a href="javascript:fPopWindow('sportevent.cfm?siteid=#application.sl_siteid#', 'custom','800','600','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')" class="link" title="Tournaments, Camps & Tryouts">Edit Events</a>
			</cfoutput>
		</td></tr>
		</table>&nbsp;
	</td>
	<td valign="top">
