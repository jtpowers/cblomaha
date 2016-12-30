<cfparam name="url.lid" default="0">
<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateleague">
	<cfif isDefined("form.delete")>
		<cfquery name="DeleteMain" datasource="#memberDSN#">
			Delete From sl_league
			where  LeagueID = #url.lid#
		</cfquery>
	<cfelse>
		<cfquery name="UpdateLeague" datasource="#memberDSN#">
			Update sl_league
			Set LeagueName = '#u_lname#',
				Info = '#u_info#'
			Where LeagueID = #url.lid#
		</cfquery>
	</cfif>
	<cfset done = 1>
<cfelseif action EQ "addleague">
	<cfquery name="AddMain" datasource="#memberDSN#">
		Insert Into sl_league (LeagueName, Info)
		Values('#a_lname#', '#a_info#')
	</cfquery>
	<cfset done = 1>
</cfif>

<cfif url.lid GT 0>
	<cfquery name="GetLeague" datasource="#memberDSN#">
		SELECT * FROM sl_league
		Where LeagueID = #url.lid#
	</cfquery>
	<cfquery name="GetSeasons" datasource="#memberDSN#">
		SELECT seasonid
		FROM sl_season
		Where LeagueID = #url.lid#
	</cfquery>
	<cfset form.action = "updateleague">
	<cfset rootDir = "../../">
<cfset pageTitle = "Edit League - #GetLeague.LeagueName#">
<cfelse>
	<cfset form.action = "addleague">
	<cfset rootDir = "../../">
<cfset pageTitle = "Add League">
</cfif>


<html>
<head>
	<cfinclude template="#rootDir#ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete is League?"))
			{
				document.forms(0).action.value = "deleteleague";
				document.forms(0).submit();
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
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0"<cfif done> onload="closeRefresh();"</cfif>>
<table cellpadding="5" cellspacing="0" width="100%">
	<tr bgcolor="#0033FF"><td class="titlesubw" align="center"><cfoutput>#pageTitle#</cfoutput></td></tr>
 	<form action="leagueedit.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
	<tr>
		<td valign="top" align="center">
			<table border="1" cellspacing="0" cellpadding="3">
				<tr><td>
				<cfif form.action EQ "updateleague">
					<input type="hidden" name="action" value="updateleague">
					<table cellpadding="2" cellspacing="0">
						<tr>
							<td class="smallb">League Name: </td>
							<td><input type="text" name="u_lname" size="35" value="<cfoutput>#GetLeague.leaguename#</cfoutput>" class="small"></td>
						</tr>
						<tr>
							<td class="smallb">Infomation: </td>
							<td><textarea name="u_info" cols="30" rows="3" class="small"><cfoutput>#GetLeague.info#</cfoutput></textarea></td>
						</tr>
						<tr>
							<td colspan="2" class="small">
							<div align="center">
								<input type="submit" name="update" value="Update" class="small">
								<cfif GetSeasons.RecordCount EQ 0>
								<input type="submit" name="delete" value="Delete" class="small">
								</cfif>
								<input type="reset" class="small">
							</div>
						</td></tr>
					</table>
				<cfelse>
					<input type="hidden" name="action" value="addleague">
					<table cellpadding="2" cellspacing="0">
						<tr>
							<td class="smallb">League Name: </td>
							<td class="small"><input type="text" name="a_lname" value="" size="35" class="small"></td>
						</tr>
						<tr>
							<td class="smallb">Infomation: </td>
							<td class="small"><textarea name="a_info" cols="30" rows="3" class="small"></textarea></td>
						</tr>
						<tr>
							<td colspan="2" class="small">
								<div align="center"><input type="submit" name="add" value="Add" class="small"></div>
							</td>
						</tr>
					</table>
				</cfif>
				</td></tr>
			</table>
		</td>
	</tr>
	</form>
	<tr><td align="center"><a href="javascript: window.close();">Close Window</a></td></tr>
</table>
</body>
</html>
