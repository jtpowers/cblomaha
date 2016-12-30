<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="form.action" default="">

<cfquery name="getSeasons" datasource="#application.memberDSN#">
	Select seasonid, seasonname
	From sl_season
	Order by startdate desc, seasonname
</cfquery>

<cfquery name="getTeam" datasource="#application.memberDSN#">
	Select t.Name, t.TeamID, t.Level, s.seasonname, d.divname
	From sl_team t, sl_division d, sl_season s
	Where s.seasonid = d.seasonid and
			d.divid = t.divid and
			t.teamid = #url.tid#
</cfquery>

<cfset done = 0>

<cfif form.action EQ "addplayer">
	<cfloop from="1" to="15" index="gIndex">
		<cfset tJerseyEval = "form.tJersey#gIndex#">
		<cfset tJersey = Evaluate(tJerseyEval)>
		<cfset tNameEval = "form.tName#gIndex#">
		<cfset tName = Evaluate(tNameEval)>
		<cfset tAltEval = "form.tAlt#gIndex#">
		<cfset tAlt = Evaluate(tAltEval)>

		<cfif LEN(tName) GT 0>
			<cfquery name="AddPlayer" datasource="#application.memberDSN#">
				Insert Into sl_player (PlayerName, JerseyNbr, TeamID, Alternate)
				Values('#tName#', 
						<cfif ISNumeric(tJersey)>#tJersey#<cfelse>999</cfif>, 
						#url.tid#,
						#tAlt#)
			</cfquery>
		</cfif>
	</cfloop>
	<cfset done = 1>
</cfif>

<cfset pageTitle = "Add Players">
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

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfset onloadattr = "document.forms[0].tName1.focus();">
</cfif>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<cfif Not done>
<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>
		#application.sl_name#<br>
		#getTeam.seasonname# - #getTeam.divname#<br>
		Add Players To #getTeam.Name#
		</cfoutput>
	</td>
</tr>
<tr><td align="center">
	<table>
		<tr><td valign="top" align="center">
			<form action="playeradds.cfm?tid=<cfoutput>#url.tid#</cfoutput>" method="post">
			<input type="hidden" name="action" value="addplayer">
			<table class="table table-condensed no-border">
				<tr><td>
					<table class="table table-condensed table-bordered">
						<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
							<td class="titlesmw" align="center">&nbsp;</td>
							<td class="titlesmw" align="center">Player Name</td>
							<td class="titlesmw" align="center">Nbr</td>
							<td class="titlesmw" align="center">Alternate</td>
						</tr>
						<cfloop from="1" to="15" index="gIndex">
							<cfoutput>
							<tr class="small">
								<td align="center" class="smallb">
									#gIndex#
								</td>
								<td>
									<input type="text" name="tName#gIndex#" value="" size="30" class="small">
								</td>
								<td align="center">
									<input type="text" name="tJersey#gIndex#" value="" size="3" class="small">
								</td>
								<td align="center" class="small">
									<input name="tAlt#gIndex#" type="radio" class="small" value="0" checked>No
									<input type="radio" name="tAlt#gIndex#" value="1" class="small">Yes
								</td>
							</tr>
							</cfoutput>
						</cfloop>
					</table>
				</td></tr>
				<tr><td align="center">
					<input type="submit" name="add" value="Add Players" class="small">
					<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
				</td></tr>
			</table>
		</form>
		</td>	</tr>
	</table>
</td></tr>
</table>
</cfif>
</body>
</html>
