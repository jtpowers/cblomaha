<cfif repeatvalue lt 0>
	<cfset repeatvalue = 0>
</cfif>

<cfset timeStart = "">
<cfset timeEnd = "">

<cfif starttime NEQ 0>
	<cfif startAMPM EQ "pm" AND starttime NEQ 12>
		<cfset starttime = #starttime# + 12>
	</cfif>
	<cfset timeStart = "#NumberFormat(startTime, '00')#:#startMin#">
</cfif>

<cfif endtime NEQ 0 AND starttime NEQ 0>
	<cfif endAMPM EQ "pm" AND endtime NEQ 12>
		<cfset endtime = #endtime# + 12>
	</cfif>
	<cfset timeEnd = "#NumberFormat(endtime, '00')#:#endMin#">
</cfif>

<cfif repeat EQ 'n'>
	<cfset dateEvent = #eventDate#>

	<cfquery name="insertInfo" datasource="#memberDSN#">
		INSERT INTO sl_calendar_event 
			( calendarID, eventDate, title, description, status, starttime, endtime, location)
			VALUES
			(#url.calid#, '#DateFormat(eventDate, "yyyy-mm-dd")#', '#eventTitle#', '#eventDesc#', #eventStatus#,
			<cfif timeStart IS "">NULL<cfelse>'#timeStart#'</cfif>,
			<cfif timeEnd IS "">NULL<cfelse>'#timeEnd#'</cfif>,
			<cfif eventLoca IS "">NULL<cfelse>'#eventLoca#'</cfif>)
	</cfquery>
<cfelse>
	<cfset repeatvalue = repeatvalue - 1>
	<cfif repeatvalue lt 0><cfset repeatvalue = 0></cfif>
	<cfloop from="0" to="#repeatvalue#" index="addindex">
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

<html>
<head>
	<title><cfoutput>#application.sl_name#</cfoutput> - Add Event</title>
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
