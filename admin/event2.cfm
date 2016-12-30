<cfset rootDir = "../">
<cfparam name="url.lid" default="">

<cfif isDefined("form.delete")>
	<cfif LEN(form.selectedID) GT 0>
		<cfquery name="deleteEvents" datasource="#memberDSN#">
			Delete FROM sl_calendar_event
			Where eventid in (#form.selectedID#)
		</cfquery>
	</cfif>
</cfif>
<!-- BEGIN DATA WINDOW -->
<cfquery name="getCalendars" datasource="#memberDSN#" dbtype="ODBC">
SELECT *
FROM sl_calendar
WHERE 	<cfif url.lid GT "">
				leagueid = #url.lid#
			<cfelse>
				leagueid is null and associd = #application.aid#
			</cfif>
ORDER BY calOrder
</cfquery>
<cfif isDefined("form.jt_calID")><cfelse><cfset form.jt_calID = getCalendars.calendarID[1]></cfif>
<cfoutput>
SELECT *
FROM sl_calendar_event 
WHERE 	calendarID = #form.jt_calID#
		<cfif isDefined("form.futureOnly")>
			AND eventDate >= '#DateFormat(Now(), "YYYY-MM-DD")#'
		</cfif>
ORDER BY eventDate, starttime
</cfoutput>
<cfquery name="Events" datasource="#memberDSN#" dbtype="ODBC">
SELECT *
FROM sl_calendar_event 
WHERE 	calendarID = #form.jt_calID#
		<cfif isDefined("form.futureOnly")>
			AND eventDate >= '#DateFormat(Now(), "YYYY-MM-DD")#'
		</cfif>
ORDER BY eventDate, starttime
</cfquery>

<cfset pageTitle = "#application.sl_name# - Calendar Events">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#pageTitle#</cfoutput></title>
<cfinclude template="#rootdir#ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="#rootDir#ssi/header.htm">

<cfinclude template="sl_header.cfm">

<center>
<!--- begin calendar --->
<font class="titlemain">Event List</font>
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
		<input type="checkbox" name="futureOnly" value="1" class="small"<cfif isDefined("form.futureOnly")> checked</cfif>> Future Only
		<input type="submit" name="Jump" value="Go!" class="small">
		</form>
	</td>
</tr>
</table>
<cfoutput>
<form action="event.cfm?lid=#url.lid#" method="post">
</cfoutput>
<cfoutput>
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
<input type="submit" name="delete" value="Delete Selected Events">

</form>
</center>
<br><br>
</td></TR>
</TABLE>
<br><br>
</body>
</html>