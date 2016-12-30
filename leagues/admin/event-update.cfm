<cfif isDefined("DeleteEvent")>
	<cfquery name="deleteEvent" datasource="#memberDSN#">
		DELETE FROM sl_calendar_event 
		WHERE eventID=#currentID#
	</cfquery>
<cfelse>
	<cfif starttime EQ 0>
		<cfset timeStart = "">
	<cfelseif startAMPM EQ "pm" AND starttime NEQ 12>
		<cfset starttime = #starttime# + 12>
		<cfset timeStart = "#startTime#:#startMin#">
	<cfelse>
		<cfset timeStart = "#NumberFormat(startTime, '00')#:#startMin#">
	</cfif>
	<cfif endtime EQ 0 OR starttime EQ 0>
		<cfset timeEnd = "">
	<cfelseif endAMPM EQ "pm" AND endtime NEQ 12>
		<cfset endtime = #endtime# + 12>
		<cfset timeEnd = "#endtime#:#endMin#">
	<cfelse>
		<cfset timeEnd = "#NumberFormat(endtime, '00')#:#endMin#">
	</cfif>

	<cfquery name="updateEvent" datasource="#memberDSN#">
		UPDATE sl_calendar_event 
			SET eventDate='#DateFormat(eventDate, "yyyy-mm-dd")#', 
				title='#eventTitle#', 
				description='#eventDesc#', 
				status=#eventStatus#,
				starttime=<cfif timeStart IS "">NULL<cfelse>'#timeStart#'</cfif>,
				endtime=<cfif timeEnd IS "">NULL<cfelse>'#timeEnd#'</cfif>,
				location=<cfif eventLoca IS "">NULL<cfelse>'#eventLoca#'</cfif>
			WHERE
				eventID=#currentID#
	</cfquery>
		
	<cfif repeat NEQ 'n'>
		<cfset repeatvalue = repeatvalue - 1>
		<cfif repeatvalue lt 0><cfset repeatvalue = 0></cfif>
		<cfloop from="1" to="#repeatvalue#" index="addindex">
			<cfset dateEvent = #DateFormat(DateAdd(#repeat#, #addindex#, #eventDate#),"mm/dd/yy")#>
			<cfoutput>#dateEvent# #addindex# #eventDate#</cfoutput>
			<cfquery name="insertInfo" datasource="#memberDSN#">
			INSERT INTO sl_calendar_event 
				( calendarID, eventDate, title, description, status, starttime, endtime, location)
				VALUES
				(#url.calid#, '#DateFormat(dateEvent, "yyyy-mm-dd")#', '#eventTitle#', '#eventDesc#', #eventStatus#,
				<cfif timeStart IS "">NULL<cfelse>'#timeStart#'</cfif>,
				<cfif timeEnd IS "">NULL<cfelse>'#timeEnd#'</cfif>,
				<cfif eventLoca IS "">NULL<cfelse>'#eventLoca#'</cfif>)
			</cfquery>
			
		</cfloop>
	</cfif>
</cfif>

<html>
<head>
	<title><cfoutput>#application.sl_name#</cfoutput> - Update Event</title>
	<script language="JavaScript">
	<!--
	function voidit(){};
	
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.document.forms(0).submit();
			window.close();
		  }
		}
	//-->
	</script>
</head>

<body onload="closeRefresh();">
</body>
</html>

