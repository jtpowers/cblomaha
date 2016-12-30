<cfset rootDir = "../../">
<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateTeam">
	<cfquery name="UpdateTeam" datasource="#application.memberDSN#">
		Update sl_team
		Set Name = '#u_tname#',
			Phone = <cfif LEN(u_phone) GT 0>'#u_phone#'<cfelse>NULL</cfif>,
			AsstPhone = <cfif LEN(u_aphone) GT 0>'#u_aphone#'<cfelse>NULL</cfif>,
			CoachName = <cfif LEN(u_coach) GT 0>'#u_coach#'<cfelse>NULL</cfif>,
			AsstCoach = <cfif LEN(u_asstcoach) GT 0>'#u_asstcoach#'<cfelse>NULL</cfif>,
			Email = <cfif LEN(u_aemail) GT 0>'#u_email#'<cfelse>NULL</cfif>,
			AsstEmail = <cfif LEN(u_email) GT 0>'#u_aemail#'<cfelse>NULL</cfif>,
			DivID = #u_divid#,
			LeagueNbr =  <cfif LEN(u_lnbr) GT 0>#u_lnbr#<cfelse>NULL</cfif>,
			TeamInfo =  <cfif LEN(body) GT 0>'#body#'<cfelse>NULL</cfif>
		Where TeamID = #url.tid#
	</cfquery>
	<cfset url.did = "#u_divid#">
	<cfset done = 1>
<cfelseif action EQ "addTeam">
	<cfquery name="AddMain" datasource="#application.memberDSN#">
		Insert Into sl_team (Name, Phone, AsstPhone, CoachName, AsstCoach, Email, AsstEmail, DivID, LeagueNbr, TeamInfo)
		Values('#u_tname#', 
					<cfif LEN(u_phone) GT 0>'#u_phone#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_aphone) GT 0>'#u_aphone#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_coach) GT 0>'#u_coach#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_asstcoach) GT 0>'#u_asstcoach#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_email) GT 0>'#u_email#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_aemail) GT 0>'#u_aemail#'<cfelse>NULL</cfif>, 
					#u_divid#, 
					<cfif LEN(u_lnbr) GT 0>#u_lnbr#<cfelse>NULL</cfif>,
					<cfif LEN(body) GT 0>'#body#'<cfelse>NULL</cfif>)
	</cfquery>
	<cfset url.did = "#u_divid#">
	<cfset done = 1>
<cfelseif action EQ "deleteTeam">
	<cftransaction>
	<cfquery name="DeletePlayers" datasource="#application.memberDSN#">
		Delete From sl_player
		where  TeamID = #url.tid#
	</cfquery>
	<cfquery name="DeleteTeam" datasource="#application.memberDSN#">
		Delete From sl_team
		where  TeamID = #url.tid#
	</cfquery>
	</cftransaction>
	<cfset url.did = "">
	<cfset done = 1>
</cfif>
	
<cfquery name="getLeagues" datasource="#application.memberDSN#">
	Select l.leagueid, l.leaguename, s.seasonname, s.startdate, s.seasonid, d.divname, d.gender, d.divid
	From sl_league l, sl_season s, sl_division d
	Where s.leagueid = l.leagueid and 
				d.seasonID = s.seasonID and
				l.leagueid = #url.lid#
	Order by s.startdate, LeagueName, divorder
</cfquery>

<cfif ParameterExists(url.tid) AND Not done>
	<cfquery name="GetTeam" datasource="#application.memberDSN#">
		SELECT t.*
		FROM sl_team t
		Where t.TeamID = #url.tid#
	</cfquery>
	<!--- Check if team has any games.  If so, you can't delete --->
	<cfquery name="CheckGames" datasource="#application.memberDSN#">
		Select gameid
		From sl_game
		Where H_teamid = #url.tid# OR V_teamid = #url.tid#
	</cfquery>
	<cfset form.u_tname = "#GetTeam.Name#">
	<cfset form.u_phone = "#GetTeam.Phone#">
	<cfset form.u_aphone = "#GetTeam.AsstPhone#">
	<cfset form.u_coach = "#GetTeam.CoachName#">
	<cfset form.u_asstcoach = "#GetTeam.AsstCoach#">
	<cfset form.u_email = "#GetTeam.Email#">
	<cfset form.u_aemail = "#GetTeam.AsstEmail#">
	<cfset form.u_divid = "#GetTeam.DivID#">
	<cfset form.u_lnbr = "#GetTeam.LeagueNbr#">
	<cfset form.u_teaminfo = "#GetTeam.TeamInfo#">
	<cfset form.action = "updateTeam">
<cfelse>
	<cfset form.u_tname = "">
	<cfset form.u_phone = "">
	<cfset form.u_aphone = "">
	<cfset form.u_coach = "">
	<cfset form.u_asstcoach = "">
	<cfset form.u_email = "">
	<cfset form.u_aemail = "">
	<cfset form.u_divid = "#url.did#">
	<cfset form.u_lnbr = "">
	<cfset form.u_teaminfo = "">
	<cfset form.action = "addTeam">
	<cfset url.tid = "">
</cfif>

<cfset pageTitle = "Team Edit">
<cfinclude template="#rootdir#ssi/header.cfm">

	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Team?"))
			{
				document.forms[0].action.value = "deleteTeam";
				document.forms[0].submit();
			} 
			else
			{
			
			}
		}	
		
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.document.forms[0].submit();
			window.close();
		  }
		}
	</script>

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfset onloadattr = "document.forms[0].u_lnbr.focus();">
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<cfif NOT done>
<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#<br>
		#application.sl_leaguename#</cfoutput><br>
		Edit Team
	</td>
</tr>
<tr><td align="center">
	<cfform action="teamedit.cfm?lid=#url.lid#&tid=#url.tid#" method="post">
	<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
	<table class="table table-condensed no-border"><tr><td valign="top" align="center">
			<table class="table table-condensed table-bordered">
				<tr><td>
				<table class="table table-condensed no-border">
					<tr>
						<td class="smallb">*Team Name: </td>
						<td><cfinput name="u_tname" type="text" value="#form.u_tname#" required="yes" message="You must enter a Team Name." class="small"></td>
						<td class="smallb">Team Number: </td>
						<td><input type="text" name="u_lnbr" value="<cfoutput>#form.u_lnbr#</cfoutput>" class="small" size="3"></td>
					</tr>
					<tr>
						<td class="smallb">Coach: </td>
						<td><input type="text" name="u_coach" value="<cfoutput>#form.u_coach#</cfoutput>" class="small"></td>
						<td class="smallb">Asst. Coach: </td>
						<td><input type="text" name="u_asstcoach" value="<cfoutput>#form.u_asstcoach#</cfoutput>" class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Phone: </td>
						<td><input type="text" name="u_phone" value="<cfoutput>#form.u_phone#</cfoutput>" class="small"></td>
						<td class="smallb">Asst. Phone: </td>
						<td><input type="text" name="u_aphone" value="<cfoutput>#form.u_aphone#</cfoutput>" class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Email: </td>
						<td><input type="text" name="u_email" value="<cfoutput>#form.u_email#</cfoutput>" class="small" size="40"></td>
						<td class="smallb">Asst. Email: </td>
						<td><input type="text" name="u_aemail" value="<cfoutput>#form.u_aemail#</cfoutput>" class="small" size="40"></td>
					</tr>
					<tr>
					</tr>
					<tr>
						<td class="smallb">Season/Division:</td>
						<td colspan="3">
							<select name="u_divid" class="small">
							<cfoutput query="getLeagues">
								<option value="#divid#"<cfif getLeagues.divid EQ form.u_divid> selected</cfif>>#seasonname# - #gender# #divname#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="smallb" valign="top" colspan="4">Team Info: </td>
					</tr>
					<tr>
						<td colspan="4">
						<cfset prBody = "#form.u_teaminfo#">
						<cfinclude template="#rootdir#ssi/editor2.cfm">
						</td>
					</tr>
				</table>
				</td></tr>
			</table>
		</td></tr>
		<tr><td align="center">
			<cfif form.action EQ "updateTeam">
				<input type="submit" name="update" value="Update" class="small">
				<cfif CheckGames.RecordCount EQ 0>
				<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
				</cfif>
			<cfelse>
				<input type="submit" name="add" value="Add" class="small">
			</cfif>
			<input type="reset" class="small"><br>
			<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
	</td></tr>
	<tr> 
		<td class="small">* Required Field</td>
	</tr>
	</table>
	</cfform>
</td></tr></table>
</cfif>
</body>
</html>
