<cfset rootDir = "../../">
<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="action" default="">
<cfset done = 0>

<cfif isDefined("form.copy") AND isDefined("form.fromtid")>
	<cftransaction>
	<!--- Get Teams --->
	<cfquery name="getSelectedTeams" datasource="#application.memberDSN#">
		Select *
		From sl_team
		Where teamid IN (#form.fromtid#)
	</cfquery>
	<cfloop query="getSelectedTeams">
		<!--- Insert Team into New Division --->
		<cfquery name="InsertTeam" datasource="#application.memberDSN#">
			Insert Into sl_team (Name, Phone, CoachName, Email, DivID, LeagueNbr)
			Values('#Name#',
						<cfif LEN(Phone) GT 0>'#Phone#'<cfelse>NULL</cfif>,
						<cfif LEN(CoachName) GT 0>'#CoachName#'<cfelse>NULL</cfif>,
						<cfif LEN(Email) GT 0>'#Email#'<cfelse>NULL</cfif>,
						#url.todid#,
						NULL)
		</cfquery>
		<!--- Get New TeamID --->
		<cfquery name="GetLastTeam" datasource="#application.memberDSN#">
			Select Max(teamid) as lastteamid
			From sl_team
		</cfquery>
		<cfset newtid = GetLastTeam.lastteamid>
		<!--- Get Team Players --->
		<cfquery name="getPlayers" datasource="#application.memberDSN#">
			Select *
			From sl_player
			Where teamid = #getSelectedTeams.TeamID#
		</cfquery>
		<cfloop query="getPlayers">
			<cfquery name="AddMain" datasource="#application.memberDSN#">
				Insert Into sl_player (PlayerName, PhoneNbr, Address, Email, Birth_Date, Contacts, ContactsPhone, JerseyNbr, TeamID, Alternate)
				Values('#getPlayers.PlayerName#',
						<cfif LEN(getPlayers.PhoneNbr) GT 0>'#getPlayers.PhoneNbr#'<cfelse>NULL</cfif>,
						<cfif LEN(getPlayers.Address) GT 0>'#getPlayers.Address#'<cfelse>NULL</cfif>,
						<cfif LEN(getPlayers.Email) GT 0>'#getPlayers.Email#'<cfelse>NULL</cfif>,
						<cfif LEN(getPlayers.Birth_Date) GT 0>'#getPlayers.Birth_Date#'<cfelse>NULL</cfif>,
						<cfif LEN(getPlayers.Contacts) GT 0>'#getPlayers.Contacts#'<cfelse>NULL</cfif>,
						<cfif LEN(getPlayers.ContactsPhone) GT 0>'#getPlayers.ContactsPhone#'<cfelse>NULL</cfif>,
						<cfif ISNumeric(getPlayers.JerseyNbr)>#getPlayers.JerseyNbr#<cfelse>999</cfif>,
						#newtid#,
						#Alternate#)
			</cfquery>
		</cfloop>
	</cfloop>
	</cftransaction>
</cfif>

<cfquery name="getToSeason" datasource="#application.memberDSN#">
	Select s.seasonname, s.startdate, s.seasonid, d.divname, d.gender, d.divid
	From sl_season s, sl_division d
	Where d.seasonID = s.seasonID and d.divid = #url.todid#
</cfquery>

<cfquery name="getToTeams" datasource="#application.memberDSN#">
	Select t.*
	From sl_team t
	Where t.divid = #url.todid#
	Order by t.leaguenbr, t.Name
</cfquery>

<cfquery name="getSeasons" datasource="#application.memberDSN#">
	Select s.seasonname, s.startdate, s.seasonid, d.divname, d.gender, d.divid
	From sl_season s, sl_division d
	Where d.seasonID = s.seasonID and
			s.leagueid = #url.lid# and s.seasonid <> #getToSeason.seasonid#
	Order by s.startdate desc, seasonname, d.divname
</cfquery>
<cfparam name="form.fromdid" default="#getSeasons.divid[1]#">

<cfif getSeasons.RecordCount GT 0>
	<cfquery name="getFromTeams" datasource="#application.memberDSN#">
		Select t.*
		From sl_team t
		Where t.divid = #form.fromdid#
		Order by t.leaguenbr, t.Name
	</cfquery>
</cfif>

<cfset pageTitle = "Copy Team/Players">
<cfinclude template="#rootdir#ssi/header.cfm">
	<script language="javascript">
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.document.forms[0].submit();
			window.close();
		  }
		}
	</script>

<form action="teamcopy.cfm?lid=<cfoutput>#url.lid#&todid=#url.todid#</cfoutput>" method="post">
<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#<br>
		#application.sl_leaguename#</cfoutput><br>
		Copy Team/Players From One Season to Another Season
	</td>
</tr>
<tr><td align="center">
<cfif getSeasons.RecordCount GT 0>
	<table class="table table-condensed no-border">
	<tr>
		<td valign="top" align="center">
			<table class="table table-condensed table-bordered">
				<tr><td align="center" class="titlesub">
				Copy From
				<table class="table table-condensed no-border">
					<tr>
						<td class="smallb">Division:</td>
						<td>
							<select name="fromdid" class="small" onChange="document.forms(0).submit();">
							<cfoutput query="getSeasons">
								<option value="#divid#"<cfif getSeasons.divid EQ form.fromdid> selected</cfif>>#seasonname# - #gender# #divname#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="smallb" valign="top">Teams:</td>
						<td>
							<select name="fromtid" size="10" multiple class="small">
							<cfoutput query="getFromTeams">
								<option value="#teamid#">#name#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
				</table>
				</td></tr>
			</table>
		</td>
		<td>
			<input type="submit" name="copy" value="Copy -->" class="small">
		</td>
		<td valign="top" align="center">
			<table class="table table-condensed table-bordered">
				<tr><td align="center" class="titlesub">
				Copy To
				<table class="table table-condensed no-border">
					<tr>
						<td class="smallb">Division:</td>
						<td class="small">
							<cfoutput>
							#getToSeason.seasonname# - #getToSeason.gender# #getToSeason.divname#
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td class="smallb" valign="top">Teams:</td>
						<td>
							<select name="totid" size="10" multiple class="small">
							<cfoutput query="getToTeams">
								<option value="#teamid#">#name#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
				</table>
				</td></tr>
			</table>
		</td>
	</tr>
	<tr><td align="center" colspan="3">
		<input type="button" name="close" value="Close Window" onClick="window.close();" class="small">
	</td></tr>
	</table>
</cfif>
</td></tr></table>
</form>
</body>
</html>
