<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="action" default="">
<cfparam name="url.sid" default="">
<cfparam name="form.u_dorder" default="0">
<cfparam name="form.a_dorder" default="0">
<cfset done = 0>

<cfif action EQ "updateDivision">
	<cfquery name="UpdateDivision" datasource="#application.memberDSN#">
		Update sl_division
		Set DivName = '#u_dname#',
			Gender = '#u_gender#',
			SeasonID = #u_sid#,
			Director = <cfif LEN(u_dir) GT 0>'#u_dir#'<cfelse>NULL</cfif>,
			DirPhone = <cfif LEN(u_dirphone) GT 0>'#u_dirphone#'<cfelse>NULL</cfif>,
			DirEmail = <cfif LEN(u_diremail) GT 0>'#u_diremail#'<cfelse>NULL</cfif>,
			Rules = <cfif LEN(body) GT 0>'#body#'<cfelse>NULL</cfif>,
			GamePeriods = <cfif isNumeric(u_periods)>#u_periods#<cfelse>0</cfif>,
			GameTOs = <cfif isNumeric(u_gameTO)>#u_gameTO#<cfelse>0</cfif>,
			Game30TOs = <cfif isNumeric(u_game30TO)>#u_game30TO#<cfelse>0</cfif>,
			PeriodTOs = <cfif isNumeric(u_periodTO)>#u_periodTO#<cfelse>0</cfif>,
			Period30TOs = <cfif isNumeric(u_period30TO)>#u_period30TO#<cfelse>0</cfif>,
			OvertimeTOs = <cfif isNumeric(u_overtimeTO)>#u_overtimeTO#<cfelse>0</cfif>
		Where DivID = #url.did#
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "addDivision">
	<!--- Get Last Division Order and Add 1 --->
	<cfquery name="GetOrder" datasource="#application.memberDSN#" maxrows="1">
		Select Max(DivOrder) as lastorder
		From sl_division
		Where seasonID = #form.u_sid#
	</cfquery>
	<cfif IsNumeric(GetOrder.lastorder)>
		<cfset nextOrder = #GetOrder.lastorder# + 1>
	<cfelse>
		<cfset nextOrder = 1>
	</cfif>
	<cfquery name="AddDivision" datasource="#application.memberDSN#">
		Insert Into sl_division (DivName, Gender, SeasonID, DivOrder, Director, DirPhone, DirEmail, Rules, GamePeriods, GameTOs, Game30TOs, PeriodTOs, Period30TOs, OvertimeTOs)
		Values('#u_dname#', '#u_gender#', #u_sid#, #nextOrder#,
					<cfif LEN(u_dir) GT 0>'#u_dir#'<cfelse>NULL</cfif>,
					<cfif LEN(u_dirphone) GT 0>'#u_dirphone#'<cfelse>NULL</cfif>,
					<cfif LEN(u_diremail) GT 0>'#u_diremail#'<cfelse>NULL</cfif>,
					<cfif LEN(body) GT 0>'#body#'<cfelse>NULL</cfif>,
					<cfif isNumeric(u_periods)>#u_periods#<cfelse>0</cfif>,
					<cfif isNumeric(u_gameTO)>#u_gameTO#<cfelse>0</cfif>,
					<cfif isNumeric(u_game30TO)>#u_game30TO#<cfelse>0</cfif>,
					<cfif isNumeric(u_periodTO)>#u_periodTO#<cfelse>0</cfif>,
					<cfif isNumeric(u_period30TO)>#u_period30TO#<cfelse>0</cfif>,
					<cfif isNumeric(u_overtimeTO)>#u_overtimeTO#<cfelse>0</cfif>)
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "deleteDivision">
	<cfquery name="DeleteDivision" datasource="#application.memberDSN#">
		Delete From sl_division
		where  DivID = #url.did#
	</cfquery>
	<cfset done = 1>
</cfif>
	
<cfquery name="getSeasons" datasource="#application.memberDSN#">
	Select *
	From sl_season
	Where LeagueID = #url.lid#
	Order by StartDate desc, SeasonName
</cfquery>

<cfif ParameterExists(url.did) AND Not done>
	<cfquery name="GetDivision" datasource="#application.memberDSN#">
		SELECT *
		FROM sl_division
		Where DivID = #url.did#
	</cfquery>
	<!--- Check if Divsion has any Teams.  If so, you can't delete --->
	<cfquery name="CheckTeams" datasource="#application.memberDSN#">
		Select teamid
		From sl_team
		Where divid = #url.did#
	</cfquery>
	<cfset form.u_dname = "#GetDivision.DivName#">
	<cfset form.u_gender = "#GetDivision.Gender#">
	<cfset form.u_sid = "#GetDivision.SeasonID#">
	<cfset form.u_dir = "#GetDivision.Director#">
	<cfset form.u_dirphone = "#GetDivision.DirPhone#">
	<cfset form.u_diremail = "#GetDivision.DirEmail#">
	<cfset form.body = "#GetDivision.Rules#">
	<cfset form.u_periods = "#GetDivision.GamePeriods#">
	<cfset form.u_gameTO = "#GetDivision.GameTOs#">
	<cfset form.u_game30TO = "#GetDivision.Game30TOs#">
	<cfset form.u_periodTO = "#GetDivision.PeriodTOs#">
	<cfset form.u_period30TO = "#GetDivision.Period30TOs#">
	<cfset form.u_overtimeTO = "#GetDivision.OvertimeTOs#">
	<cfset form.action = "updateDivision">
<cfelse>
	<cfset form.u_dname = "">
	<cfset form.u_gender = "">
	<cfset form.u_sid = "#url.sid#">
	<cfset form.u_dir = "">
	<cfset form.u_dirphone = "">
	<cfset form.u_diremail = "">
	<cfset form.body = "">
	<cfset form.u_periods = "2">
	<cfset form.u_gameTO = "2">
	<cfset form.u_game30TO = "1">
	<cfset form.u_periodTO = "0">
	<cfset form.u_period30TO = "0">
	<cfset form.u_overtimeTO = "1">
	<cfset form.action = "addDivision">
	<cfset url.did = "">
</cfif>

<cfset pageTitle = "Division Edit">
<cfinclude template="#rootdir#ssi/header.cfm">

	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Division?"))
			{
				document.forms[0].action.value = "deleteDivision";
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

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0"<cfif done> onload="closeRefresh();"</cfif>>
<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_Name#<br>
		#application.sl_leaguename#</cfoutput><br>
		Edit Division
	</td>
</tr>
<tr><td align="center">
	<cfform action="divisionedit.cfm?lid=#url.lid#&did=#url.did#" method="post">
	<cfoutput>
	<input type="hidden" name="action" value="#form.action#">
	</cfoutput>
	<table class="table table-condensed no-border"><tr><td valign="top" align="center">
		<table class="table table-condensed table=bordered">
			<tr><td>
			<table class="table table-condensed no-border">
				<tr>
					<td class="smallb">*Divsion Name: </td>
					<td><cfinput name="u_dname" type="text" value="#form.u_dname#" required="yes" message="Division Name is required." class="small"></td>
					<td class="smallb">*Season: </td>
					<td>
						<select name="u_sid" class="small">
							<cfoutput query="getSeasons">
								<option value="#SeasonID#"<cfif SeasonID EQ form.u_sid> selected</cfif>>#SeasonName#</option>
							</cfoutput>
						</select>
					</td>
					<td class="smallb">Gender: </td>
					<td>
						<select name="u_gender" class="small">
							<option value="Girls"<cfif form.u_gender EQ "Girls"> selected</cfif>>Girls</option>
							<option value="Boys"<cfif form.u_gender EQ "Boys"> selected</cfif>>Boys</option>
							<option value="Coed"<cfif form.u_gender EQ "Coed"> selected</cfif>>Coed</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">Director Name: </td>
					<td><input type="text" name="u_dir" value="<cfoutput>#form.u_dir#</cfoutput>" class="small"></td>
					<td class="smallb">Director Phone: </td>
					<td colspan="3"><input type="text" name="u_dirphone" value="<cfoutput>#form.u_dirphone#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Director Email: </td>
					<td colspan="5"><input type="text" name="u_diremail" value="<cfoutput>#form.u_diremail#</cfoutput>" class="small" size="40"></td>
				</tr>
				<tr>
					<td class="smallb">Game Periods: </td>
					<td colspan="5"><input type="text" name="u_periods" size="2" value="<cfoutput>#form.u_periods#</cfoutput>" class="small">
					<span class="smallb">Game TOs: </span>
					<span class="small">Full: </span><input type="text" name="u_gameTO" size="2" value="<cfoutput>#form.u_gameTO#</cfoutput>" class="small">
					<span class="small">30 sec: </span><input type="text" name="u_game30TO" size="2" value="<cfoutput>#form.u_game30TO#</cfoutput>" class="small">
					<span class="smallb">Per Period TOs: </span>
					<span class="small">Full: </span><input type="text" name="u_periodTO" size="2" value="<cfoutput>#form.u_periodTO#</cfoutput>" class="small">
					<span class="small">30 sec: </span><input type="text" name="u_period30TO" size="2" value="<cfoutput>#form.u_period30TO#</cfoutput>" class="small">
					<span class="smallb">Overtime TOs: </span>
						<input type="text" name="u_overtimeTO" size="2" value="<cfoutput>#form.u_overtimeTO#</cfoutput>" class="small">
					</td>
				</tr>
				<tr>
					<td colspan="6" class="smallb">Rules:</td>
				</tr>
				<tr>
					<td colspan="6">
					<cfset prBody = "#form.body#">
					<cfinclude template="#rootdir#ssi/editor2.cfm">
					</td>
				</tr>
			</table>
			</td></tr>
		</table>
	</td></tr>
	<tr><td colspan="2" align="center">
		<cfif form.action EQ "updateDivision">
			<input type="submit" name="update" value="Update" class="small">
			<cfif CheckTeams.RecordCount EQ 0>
			<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
			</cfif>
		<cfelse>
			<input type="submit" name="add" value="Add" class="small">
		</cfif>
			<input type="reset" class="small"><br>
			<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
		</div>
	</td></tr>
	<tr> 
		<td colspan="2" class="small">* Required Field</td>
	</tr>
	</table>
	</cfform>
</td></tr>
</table>
</body>
</html>
