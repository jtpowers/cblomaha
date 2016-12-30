<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="url.lid" default="">
<cfparam name="form.futureonly" default="1">

<cfif isDefined("form.delete")>
	<cfif LEN(form.selectedID) GT 0>
		<cfquery name="deleteEvents" datasource="#application.memberDSN#">
			Delete FROM sl_calendar_event
			Where eventid in (#form.selectedID#)
		</cfquery>
	</cfif>
</cfif>
<!-- BEGIN DATA WINDOW -->
<cfquery name="getCalendars" datasource="#application.memberDSN#">
SELECT *
FROM sl_calendar
WHERE 	<cfif url.lid GT "">
				leagueid = #url.lid#
			<cfelse>
				leagueid is null and associd = #application.aid#
			</cfif>
ORDER BY calOrder
</cfquery>
<cfif getCalendars.RecordCount GT 0>
	<cfif isDefined("form.jt_calID")><cfelse><cfset form.jt_calID = getCalendars.calendarID[1]></cfif>
	
	<cfquery name="Events" datasource="#application.memberDSN#">
	SELECT *
	FROM sl_calendar_event 
	WHERE 	calendarID = #form.jt_calID#
			<cfif form.futureonly>
				AND eventDate >= '#DateFormat(Now(), "YYYY-MM-DD")#'
			</cfif>
	ORDER BY eventDate, starttime, title
	</cfquery>
</cfif>
<cfset pageTitle = "Calendar Events">

<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-4 col-xs-hidden col-sm-hidden"></div>
    <div class="col-xs-12 col-md-4">
<cfif getCalendars.RecordCount GT 0>
<!--- begin calendar --->
<table>
<tr>
	<td valign="top" align="center">
		<table border="0" cellspacing="0" cellpadding="3">
		<tr>
			<td align="center" valign="top" class="smallb">
				<cfoutput>
				<form action="event.cfm?lid=#url.lid#" method="post">
				</cfoutput>
				Calendar:
				<select name="jt_calID" class="small">
					<cfoutput query="getCalendars">
						<option value="#calendarID#"<cfif jt_calID eq #calendarID#> SELECTED</cfif>>#calName#</option>
					</cfoutput>
				</select>
				<select name="futureonly" class="small">
						<option value="1"<cfif futureonly eq 1> SELECTED</cfif>>Current Events</option>
						<option value="0"<cfif futureonly eq 0> SELECTED</cfif>>All Events</option>
				</select>
				<input type="submit" name="Jump" value="Go!" class="small">
				</form>
			</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td valign="top">
		<cfoutput>
		<form action="event.cfm?lid=#url.lid#" method="post">
		<a href="javascript:fPopWindow('eventedit.cfm?lid=#url.lid#&action=Add&calid=#form.jt_calID#', 'custom','400','450','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Event">Add Event</a>
		</cfoutput>
		<table border="1" cellpadding="2" cellspacing="0">
		<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
			<td>&nbsp;</td>
			<td class="titlesubw">Date</td>
			<td class="titlesubw">Start</td>
			<td class="titlesubw">End</td>
			<td class="titlesubw">Title</td>
			<td class="titlesubw">Location</td>
			<td class="titlesubw">Description</td>
		</tr>
		<cfset count = 0>
		<cfoutput query="Events">
		<cfset count=count+1>
		<tr <cfif count mod 2 EQ 0>bgcolor="C6D6FF"<cfelse>bgcolor="FFFFFF"</cfif>>
			<td class="small"><input type="checkbox" name="selectedID" value="#eventid#" class="small"></td>
			<td class="small" nowrap>#DateFormat(eventdate, "mm/dd/yyyy")#&nbsp;</td>
			<td class="small" nowrap>#TimeFormat(starttime, "hh:mm tt")#&nbsp;</td>
			<td class="small" nowrap>#TimeFormat(endtime, "hh:mm tt")#&nbsp;</td>
			<td class="small" nowrap><a href="javascript:fPopWindow('eventedit.cfm?lid=#url.lid#&eventid=#eventid#&action=Update&calid=#form.jt_calID#', 'custom','400','450','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Update Event">#title#</a></td>
			<td class="small">#location#&nbsp;</td>
			<td class="small">#description#&nbsp;</td>
		</tr>
		</cfoutput>
		</table>
		<br>
		<input type="submit" name="delete" value="Delete">
		</form>
	</td>
</tr>
</table>
<cfelse>
	<br><br>
	<span class="titlemain">You must first create a Calendar before entering a Calendar Event.</span>
</cfif>
    </div>
	<div class="clearfix col-md-4 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
