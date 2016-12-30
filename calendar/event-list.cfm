<cfinclude template="../member.cfm">
<cfparam name="url.export" default="n">

<cfif isDefined("form.delete")>
	<cfif LEN(form.selectedID) GT 0>
		<cfquery name="deleteEvents" datasource="#memberDSN#" dbtype="ODBC">
			Delete FROM Event
			Where eventid in (#form.selectedID#)
		</cfquery>
	</cfif>
</cfif>
<!-- BEGIN DATA WINDOW -->
<cfquery name="Events" datasource="#memberDSN#" dbtype="ODBC">
SELECT *
FROM Event
ORDER BY eventDate desc, starttime desc
</cfquery>

<cfset pageTitle = "Event List">
<cfinclude template="../top.htm">
<cfif url.export IS "n">
<center>
<!--- begin calendar --->
<font class="titlemain">Event List</font>
<form action="event-list.cfm" method="post">
<a href="event-list.cfm?export=y">Export</a>
<table border="1" cellpadding="2" cellspacing="0">
<tr bgcolor="024BB9">
	<td>&nbsp;</td>
	<td class="titlesubw">Date</td>
	<td class="titlesubw">Start</td>
	<td class="titlesubw">End</td>
	<td class="titlesubw">Title</td>
	<td class="titlesubw">Location</td>
	<td class="titlesubw">Description</td>
	<td class="titlesubw">Member</td>
	<td class="titlesubw">View</td>
	<td class="titlesubw">Status</td>
</tr>
<cfset count = 0>
<cfoutput query="Events">
<cfset count=count+1>
<tr <cfif count mod 2 EQ 0>bgcolor="C6D6FF"<cfelse>bgcolor="FFFFFF"</cfif>>
	<td class="small"><input type="checkbox" name="selectedID" value="#eventid#" class="small"></td>
	<td class="small" nowrap>#DateFormat(eventdate, "mm/dd/yyyy")#&nbsp;</td>
	<td class="small" nowrap>#TimeFormat(starttime, "hh:mm tt")#&nbsp;</td>
	<td class="small" nowrap>#TimeFormat(endtime, "hh:mm tt")#&nbsp;</td>
	<td class="small" nowrap>#title#&nbsp;</td>
	<td class="small">#location#&nbsp;</td>
	<td class="small">#description#&nbsp;</td>
	<td class="small" nowrap>#memberid#</td>
	<td class="small" nowrap>#publicview#</td>
	<td class="small" nowrap>#status#</td>
</tr>
</cfoutput>
</table>
<br>
<input type="submit" name="delete" value="Delete">

</form>
</center>
<cfelse>
<br><a href="event-list.cfm?export=n">Back to Event List</a><br><br>
<cfoutput query="Events">
"#DateFormat(eventdate, "mm/dd/yyyy")#","#TimeFormat(starttime, "hh:mm tt")#","#TimeFormat(endtime, "hh:mm tt")#","#title#","#location#","#description#"<br>
</cfoutput>
</cfif>
<br><br>
<cfinclude template="../bottom.htm">
</body>
</html>