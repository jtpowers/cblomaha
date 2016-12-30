<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="form.lid" default="1">
<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateSeason">
	<cfquery name="UpdateSeason" datasource="#application.memberDSN#">
		Update sl_season
		Set SeasonName = '#u_sname#',
			StartDate = <cfif isDate(#u_sdate#)>'#DateFormat(u_sdate, "yyyy-mm-dd")#'<cfelse>NULL</cfif>,
			DeadlineDate = <cfif isDate(#u_deadline#)>'#DateFormat(u_deadline, "yyyy-mm-dd")#'<cfelse>NULL</cfif>,
			LeagueID = #url.lid#
		Where SeasonID = #url.sid#
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "addSeason">
	<cfquery name="AddMain" datasource="#application.memberDSN#">
		Insert Into sl_season (SeasonName, StartDate, DeadlineDate, LeagueID)
		Values('#u_sname#', 
				<cfif isDate(#u_sdate#)>'#DateFormat(u_sdate, "yyyy-mm-dd")#'<cfelse>NULL</cfif>,
				<cfif isDate(#u_deadline#)>'#DateFormat(u_deadline, "yyyy-mm-dd")#'<cfelse>NULL</cfif>, 
				#url.lid#)
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "deleteSeason">
	<cfquery name="DeleteMain" datasource="#application.memberDSN#">
		Delete From sl_season
		where  SeasonID = #url.sid#
	</cfquery>
	<cfset done = 1>
</cfif>
	
<cfif ParameterExists(sid) AND Not done>
	<cfquery name="GetSeason" datasource="#application.memberDSN#">
		SELECT *
		FROM sl_season
		Where SeasonID = #url.sid#
	</cfquery>
	<!--- Check if season has any Divisions.  If so, you can't delete --->
	<cfquery name="CheckDivs" datasource="#application.memberDSN#">
		Select divid
		From sl_division
		Where seasonid = #url.sid#
	</cfquery>
	<cfset form.u_sname = "#GetSeason.SeasonName#">
	<cfset form.u_sdate = "#DateFormat(GetSeason.StartDate, "mm/dd/yyyy")#">
	<cfset form.u_deadline = "#DateFormat(GetSeason.DeadlineDate, "mm/dd/yyyy")#">
	<cfset form.action = "updateSeason">
<cfelse>
	<cfset form.u_sname = "">
	<cfset form.u_sdate = "">
	<cfset form.u_deadline = "">
	<cfset form.action = "addSeason">
	<cfset url.sid = "">
</cfif>

<cfset pageTitle = "Season Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Season?"))
			{
				document.forms[0].action.value = "deleteSeason";
				document.forms[0].submit();
			} 
			else
			{
			
			}
		}	
		
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.history.go(0);
			window.close();
		  }
		}
	</script>

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfif ParameterExists(url.sid)>
		<cfset onloadattr = "document.forms[0].u_sname.focus();">
	<cfelse>
		<cfset onloadattr = "document.forms[0].a_sname.focus();">
	</cfif>
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<table class="table table-responsive no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#<br>
		#application.sl_leaguename#</cfoutput><br>
		Edit Season
	</td>
</tr>
<tr><td align="center">
	<cfform action="seasonedit.cfm?lid=#url.lid#&sid=#url.sid#" method="post">
	<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
	<table class="table table-responsive no-border">
	<tr><td valign="top" align="center">
		<table class="table table-responsive">
			<tr><td>
			<table cellpadding="2" cellspacing="0">
				<tr>
					<td class="smallb">Season Name: </td>
					<td><cfinput name="u_sname" type="text" value="#form.u_sname#" required="yes" message="Season Name is required." class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Start Date: </td>
					<td><input type="text" name="u_sdate" value="<cfoutput>#form.u_sdate#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Deadline: </td>
					<td><input type="text" name="u_deadline" value="<cfoutput>#form.u_deadline#</cfoutput>" class="small"></td>
				</tr>
			</table>
			</td></tr>
		</table>
	</td></tr>
	<tr><td align="center">
		<cfif form.action EQ "updateSeason">
			<input type="submit" name="update" value="Update" class="small">
			<cfif CheckDivs.RecordCount EQ 0>
			<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
			</cfif>
		<cfelse>
			<input type="submit" name="Add" value="Add" class="small">
		</cfif>
			<input type="reset" class="small"><br>
			<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
	</td></tr>
	<tr> 
		<td class="small">* Required Field</td>
	</tr>
	</table>
	</cfform>
</td></TR>
</TABLE>

</body>
</html>
