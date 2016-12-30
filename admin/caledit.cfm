<cfset rootDir = "../">
<cfparam name="action" default="">
<cfparam name="url.lid" default="">
<cfset done = 0>

<cfif action EQ "updateCalendar">
	<cfquery name="UpdateCalendar" datasource="#memberDSN#">
		Update sl_calendar
		Set calName = '#u_calname#'
		Where CalendarID = #url.calid#
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "addCalendar">
	<!--- Get Last Division Order and Add 1 --->
	<cfquery name="GetOrder" datasource="#memberDSN#" maxrows="1">
		Select Max(CalOrder) as lastorder
		From sl_calendar
		Where 
			<cfif url.lid GT "">
				leagueid = #url.lid#
			<cfelse>
				leagueid is null and associd = #application.aid#
			</cfif>
	</cfquery>
	<cfif IsNumeric(GetOrder.lastorder)>
		<cfset nextOrder = #GetOrder.lastorder# + 1>
	<cfelse>
		<cfset nextOrder = 1>
	</cfif>
	<cfquery name="AddCalendar" datasource="#memberDSN#">
		Insert Into sl_calendar (CalName, AssocID, LeagueID, CalOrder)
		Values('#u_calname#', #application.aid#,
			<cfif url.lid GT "">#url.lid#<cfelse>NULL</cfif>,
			#nextOrder#)
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "deleteCalendar">
	<cfquery name="DeleteCalendar" datasource="#memberDSN#">
		Delete From sl_calendar
		where  CalendarID = #url.calid#
	</cfquery>
	<cfset done = 1>
</cfif>
	
<cfif ParameterExists(url.calid) AND Not done>
	<cfquery name="GetCalendar" datasource="#memberDSN#">
		SELECT *
		FROM sl_calendar
		Where CalendarID = #url.calid#
	</cfquery>
	<!--- Check if Calendar has any Future Events.  If so, you can't delete --->
	<cfquery name="CheckEvents" datasource="#memberDSN#">
		Select eventid
		From sl_calendar_event
		Where calendarid = #url.calid# and eventDate >= '#DateFormat(Now(), "YYYY-MM-DD")#'
	</cfquery>
	<cfset form.u_calname = "#GetCalendar.CalName#">
	<cfset form.action = "updateCalendar">
<cfelse>
	<cfset form.u_calname = "">
	<cfset form.action = "addCalendar">
	<cfset url.calid = "">
</cfif>

<cfset pageTitle = "#application.sl_name# - Calendar Edit">

<html>
<head>
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Calendar?"))
			{
				document.forms(0).action.value = "deleteCalendar";
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
	<cfinclude template="#rootdir#ssi/webscript.htm">
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0"<cfif done> onload="closeRefresh();"</cfif>>
<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_Name#</cfoutput><br>
		Edit Calendar
	</td>
</tr>
<tr><td align="center">
	<cfoutput>
	<form action="caledit.cfm?lid=#url.lid#&calid=#url.calid#" method="post">
	<input type="hidden" name="action" value="#form.action#">
	</cfoutput>
	<table><tr><td valign="top" align="center">
		<table border="1" cellspacing="0" cellpadding="3">
			<tr><td>
			<table cellpadding="2" cellspacing="0">
				<tr>
					<td class="smallb">Calendar Name: </td>
					<td><input type="text" name="u_calname" value="<cfoutput>#form.u_calname#</cfoutput>" class="small"></td>
				</tr>
			</table>
			</td></tr>
		</table>
	</td></tr>
	<tr><td colspan="2" align="center">
		<cfif form.action EQ "updateCalendar">
			<input type="submit" name="update" value="Update" class="small">
			<cfif CheckEvents.RecordCount EQ 0>
			<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
			</cfif>
		<cfelse>
			<input type="submit" name="add" value="Add" class="small">
		</cfif>
			<input type="reset" class="small"><br>
			<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
		</div>
	</td></tr>
	</table>
	</form>
</td></tr>
</table>
</body>
</html>
