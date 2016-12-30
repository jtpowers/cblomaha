<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfif isDefined("url.tid")><cfset form.u_tid =  url.tid></cfif>

<cfparam name="url.game" default="0">
<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateplayer" and u_tid GT "">
	<cfquery name="UpdatePlayer" datasource="#application.memberDSN#">
		Update sl_player
		Set PlayerName = '#u_pname#',
			PhoneNbr = <cfif LEN(u_phone) GT 0>'#u_phone#'<cfelse>NULL</cfif>,
			Address = <cfif LEN(u_addr) GT 0>'#u_addr#'<cfelse>NULL</cfif>,
			Email = <cfif LEN(u_email) GT 0>'#u_email#'<cfelse>NULL</cfif>,
			Contacts = <cfif LEN(u_cname) GT 0>'#u_cname#'<cfelse>NULL</cfif>,
			ContactsPhone = <cfif LEN(u_cphone) GT 0>'#u_cphone#'<cfelse>NULL</cfif>,
			JerseyNbr = <cfif ISNumeric(u_jersey)>#u_jersey#<cfelse>999</cfif>,
			Alternate = <cfif isDefined("form.u_alt")>1<cfelse>0</cfif>,
			TeamID = #u_tid#
		Where PlayerID = #url.pid#
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "addplayer" and u_tid GT "">
	<cfquery name="AddMain" datasource="#application.memberDSN#">
		Insert Into sl_player (PlayerName, PhoneNbr, Address, Email, Contacts, ContactsPhone, JerseyNbr, TeamID, Alternate)
		Values('#u_pname#', 
				<cfif LEN(u_phone) GT 0>'#u_phone#'<cfelse>NULL</cfif>, 
				<cfif LEN(u_addr) GT 0>'#u_addr#'<cfelse>NULL</cfif>, 
				<cfif LEN(u_email) GT 0>'#u_email#'<cfelse>NULL</cfif>, 
				<cfif LEN(u_cname) GT 0>'#u_cname#'<cfelse>NULL</cfif>, 
				<cfif LEN(u_cphone) GT 0>'#u_cphone#'<cfelse>NULL</cfif>,
				<cfif ISNumeric(u_jersey)>#u_jersey#<cfelse>999</cfif>, 
				#u_tid#,
				<cfif isDefined("form.u_alt")>1<cfelse>0</cfif>)
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "deleteplayer">
	<cfquery name="DeleteMain" datasource="#application.memberDSN#">
		Delete From sl_player
		where  PlayerID = #url.pid#
	</cfquery>
	<cfset done = 1>
</cfif>

<cfif ParameterExists(url.pid) AND Not done>
	<cfquery name="GetPlayer" datasource="#application.memberDSN#">
		SELECT p.*, d.seasonid
		FROM sl_player p, sl_team t, sl_division d
		Where PlayerID = #url.pid# and
				t.teamid = p.teamid and
				d.divid = t.divid
	</cfquery>
	<cfset url.sid = GetPlayer.seasonid>
	<cfset form.u_pname = "#GetPlayer.PlayerName#">
	<cfset form.u_phone = "#GetPlayer.PhoneNbr#">
	<cfset form.u_addr = "#GetPlayer.Address#">
	<cfset form.u_email = "#GetPlayer.Email#">
	<cfset form.u_cname = "#GetPlayer.Contacts#">
	<cfset form.u_cphone = "#GetPlayer.ContactsPhone#">
	<cfset form.u_jersey = "#GetPlayer.JerseyNbr#">
	<cfset form.u_alt = "#GetPlayer.Alternate#">
	<cfset form.u_tid = "#GetPlayer.TeamID#">
	<cfset form.action = "updatePlayer">
<cfelse>
	<cfset form.u_pname = "">
	<cfset form.u_phone = "">
	<cfset form.u_addr = "">
	<cfset form.u_email = "">
	<cfset form.u_cname = "">
	<cfset form.u_cphone = "">
	<cfset form.u_jersey = "">
	<cfset form.u_alt = "0">
	<cfset form.action = "addPlayer">
	<cfset url.pid = "">
</cfif>

<cfset pageTitle = "Player Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Player?"))
			{
				document.forms[0].action.value = "deleteplayer";
				document.forms[0].submit();
			} 
			else
			{
			
			}
		}	
		
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
		  	<cfif url.game>
				window.opener.history.go(0);
			<cfelse>
				window.opener.document.forms[0].submit();
			</cfif>
			window.close();
		  }
		}
	</script>

<cfquery name="getTeams" datasource="#application.memberDSN#">
	Select t.Name, t.TeamID, t.Level, s.seasonname, t.leaguenbr, d.divname, d.divid
	From sl_team t, sl_division d, sl_season s
	Where d.seasonid = s.seasonid and
			t.divid = d.divid and
			s.seasonid = #cookie.lynxbbsid#
	Order by d.divorder, t.LeagueNbr, t.Name
</cfquery>

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfif ParameterExists(url.pid)>
		<cfset onloadattr = "document.forms[0].u_pname.focus();">
	<cfelse>
		<cfset onloadattr = "document.forms[0].u_pname.focus();">
	</cfif>
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<cfif Not done>
<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#<br>
		#application.sl_leaguename#</cfoutput><br>
		Edit Player
	</td>
</tr>
<tr><td align="center">
	<cfform action="playeredit.cfm?pid=#url.pid#&game=#url.game#&sid=#url.sid#" method="post">
	<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
	<table class="table table-condensed no-border">
		<tr><td valign="top" align="center">
			<table class="table table-condensed table-bordered">
				<tr><td>
				<table class="table table-condensed no-border">
				<cfoutput>
					<tr>
						<td class="smallb">*Player Name: </td>
						<td><cfinput name="u_pname" type="text" value="#form.u_pname#" size="35" required="yes" message="Player Name is required." class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Jersey Nbr: </td>
						<td><input type="text" name="u_jersey" size="3" value="<cfif  form.u_jersey LT 999>#form.u_jersey#</cfif>" class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Phone: </td>
						<td><input type="text" name="u_phone" value="#form.u_phone#" class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Address: </td>
						<td><input type="text" name="u_addr" size="35" value="#form.u_addr#" class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Email: </td>
						<td><input type="text" name="u_email" size="35" value="#form.u_email#" class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Contact: </td>
						<td><input type="text" name="u_cname" value="#form.u_cname#" class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Contact Phone: </td>
						<td><input type="text" name="u_cphone" value="#form.u_cphone#" class="small"></td>
					</tr>
				</cfoutput>
					<tr>
						<td class="smallb">Team: </td>
						<td>
							<select name="u_tid" class="small">
								<option value="">---- <cfoutput>#getTeams.divname#</cfoutput> ----</option>
								<cfset divHold = getTeams.divid>
							<cfoutput query="getTeams">
								<cfif divid NEQ divHold>
									<option value="">---- #getTeams.divname# ----</option>
									<cfset divHold = getTeams.divid>
								</cfif>
								<option value="#TeamID#"<cfif TeamID EQ form.u_tid> SELECTED</cfif>>#leaguenbr#. #Name#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="smallb">Alternate: </td>
						<td><input type="checkbox" name="u_alt" value="1" class="small"<cfif form.u_alt EQ 1> checked</cfif>></td>
					</tr>
				</table>
				</td></tr>
			</table>
		</td></tr>
		<tr><td align="center">
			<cfif form.action EQ "updatePlayer">
				<input type="submit" name="update" value="Update" class="small">
				<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
			<cfelse>
				<input type="submit" name="add" value="Add" class="small">
			</cfif>
			<input type="reset" class="small"><br>
			<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
		</td>	</tr>
		<tr> 
			<td class="small">* Required Field</td>
		</tr>
	</table>
	</cfform>
</td></tr>
</table>
</cfif>
</body>
</html>
