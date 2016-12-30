<cfset rootDir = "../">

<cfif #action# eq 'Add'>
	<cfset evTitle = "">
	<cfset evdate = #Now()#>
	<cfset evLoca = "">
	<cfset evDesc = "">
	<cfset evPublic = 1>
	<cfset evStatus = 1>
	<cfset eventID = 0>
	<cfset sTime = "0">
	<cfset sMin = "00">
	<cfset sAMPM = "PM">
	<cfset eTime = "0">
	<cfset eMin = "00">
	<cfset eAMPM = "PM">
<cfelse>
	<cfquery name="getEventInfo" datasource="#memberDSN#">
		SELECT *
		FROM sl_calendar_event 
		WHERE eventID = #url.eventid#
	</cfquery>

	<cfoutput query="getEventInfo">
		<cfset evdate = #eventDate#>
		<cfset evTitle = #title#>
		<cfset evLoca = #location#>
		<cfset evDesc = #description#>
		<cfset evStatus = #status#>
		<cfset sTime = #TimeFormat(startTime, 'h')#>
		<cfset sMin = #TimeFormat(startTime, 'mm')#>
		<cfset sAMPM = "#TimeFormat(startTime, 'tt')#">
		<cfset eTime = #TimeFormat(endTime, 'h')#>
		<cfset eMin = #TimeFormat(endTime, 'mm')#>
		<cfset eAMPM = "#TimeFormat(endTime, 'tt')#">
	</cfoutput>
</cfif>

<cfset pageTitle = "#application.sl_name# - Division Edit">

<html>
<head>
	<cfinclude template="#rootDir#ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Event?"))
			{
				document.forms(0).action.value = "deleteEvent";
				document.forms(0).submit();
			} 
			else
			{
			
			}
		}	
		
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.document.forms(0).submit();
			window.close();
		  }
		}
	</script>
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<center>

<cfform action="event-#action#.cfm?lid=#url.lid#&calid=#url.calid#" method="post">
	<input type="hidden" name="currentID" value="<cfoutput>#eventID#</cfoutput>">
	<table border="0" cellpadding="5" bordercolorlight="black" bordercolordark="white" cellspacing="0" width="100%">
		<tr> 
			<td colspan="2" align="center"class="titlemain" bgcolor="#000000">
				<font color="#ffff00"><cfoutput>#action#</cfoutput> Event.</font>
			</td>
	    </tr>
		<tr> 
			<td valign="TOP" class="small">*<b>Date:</b></td>
	      	<td valign="TOP">
				<cfinput name="eventDate" type="text" value="#DateFormat(evdate, "mm/dd/yyyy")#" size="10" required="yes" message="Event Date is required and should be in this format, mm/dd/yyyy." validate="date" class="small">
	      	</td>
	    </tr>
		<tr> 
			<td valign="TOP" class="small"><b>Start Time:</b></td>
	      	<td valign="TOP">
				<select name="startTime" class="small">
					<option value="0"<cfif sTime EQ 0> selected</cfif>>N/A</option>
					<option value="1"<cfif sTime EQ 1> selected</cfif>>1</option>
					<option value="2"<cfif sTime EQ 2> selected</cfif>>2</option>
					<option value="3"<cfif sTime EQ 3> selected</cfif>>3</option>
					<option value="4"<cfif sTime EQ 4> selected</cfif>>4</option>
					<option value="5"<cfif sTime EQ 5> selected</cfif>>5</option>
					<option value="6"<cfif sTime EQ 6> selected</cfif>>6</option>
					<option value="7"<cfif sTime EQ 7> selected</cfif>>7</option>
					<option value="8"<cfif sTime EQ 8> selected</cfif>>8</option>
					<option value="9"<cfif sTime EQ 9> selected</cfif>>9</option>
					<option value="10"<cfif sTime EQ 10> selected</cfif>>10</option>
					<option value="11"<cfif sTime EQ 11> selected</cfif>>11</option>
					<option value="12"<cfif sTime EQ 12> selected</cfif>>12</option>
				</select>:
				<select name="startMin" class="small">
					<option value="00"<cfif sMin EQ "00"> selected</cfif>>00</option>
					<option value="15"<cfif sMin EQ "15"> selected</cfif>>15</option>
					<option value="30"<cfif sMin EQ "30"> selected</cfif>>30</option>
					<option value="45"<cfif sMin EQ "45"> selected</cfif>>45</option>
				</select>
				<select name="startAMPM" class="small">
					<option value="am"<cfif sAMPM EQ "am"> selected</cfif>>am</option>
					<option value="pm"<cfif sAMPM EQ "pm"> selected</cfif>>pm</option>
				</select>
			</td>
		</tr>
		<tr> 
			<td valign="TOP" class="small"><b>End Time:</b></td>
	      	<td valign="TOP">
				<select name="endTime" class="small">
					<option value="0"<cfif eTime EQ 0> selected</cfif>>N/A</option>
					<option value="1"<cfif eTime EQ 1> selected</cfif>>1</option>
					<option value="2"<cfif eTime EQ 2> selected</cfif>>2</option>
					<option value="3"<cfif eTime EQ 3> selected</cfif>>3</option>
					<option value="4"<cfif eTime EQ 4> selected</cfif>>4</option>
					<option value="5"<cfif eTime EQ 5> selected</cfif>>5</option>
					<option value="6"<cfif eTime EQ 6> selected</cfif>>6</option>
					<option value="7"<cfif eTime EQ 7> selected</cfif>>7</option>
					<option value="8"<cfif eTime EQ 8> selected</cfif>>8</option>
					<option value="9"<cfif eTime EQ 9> selected</cfif>>9</option>
					<option value="10"<cfif eTime EQ 10> selected</cfif>>10</option>
					<option value="11"<cfif eTime EQ 11> selected</cfif>>11</option>
					<option value="12"<cfif eTime EQ 12> selected</cfif>>12</option>
				</select>:
				<select name="endMin" class="small">
					<option value="00"<cfif eMin EQ "00"> selected</cfif>>00</option>
					<option value="15"<cfif eMin EQ "15"> selected</cfif>>15</option>
					<option value="30"<cfif eMin EQ "30"> selected</cfif>>30</option>
					<option value="45"<cfif eMin EQ "45"> selected</cfif>>45</option>
				</select>
				<select name="endAMPM" class="small">
					<option value="am"<cfif eAMPM EQ "am"> selected</cfif>>am</option>
					<option value="pm"<cfif eAMPM EQ "pm"> selected</cfif>>pm</option>
				</select>
			</td>
		</tr>
	    <tr> 
			<td valign="TOP" class="small">*<b>Title:</b></td>
			<td valign="TOP"> 
				<cfinput name="eventTitle" type="text" value="#evTitle#" size="35" required="yes" message="Must enter a Title." class="small">
			</td>
		</tr>
		<tr> 
			<td valign="TOP" class="small">	<b>Location:</b></td>
			<td valign="TOP"> 
				<input type="text" name="eventLoca" value="<cfoutput>#evLoca#</cfoutput>" size="35" class="small">
			</td>
		</tr>
		<tr> 
			<td valign="TOP" class="small">	<b>Description:</b></td>
			<td valign="TOP"> 
				<textarea cols="30" rows="5" name="eventDesc" class="small"><cfoutput>#evDesc#</cfoutput></textarea>
			</td>
		</tr>
	    <tr> 
			<td valign="TOP" class="small"><b>Repeat:</b></td>
			<td valign="TOP" class="small"> 
				<input type="radio" name="repeat" value="n" checked>None
				<input type="radio" name="repeat" value="d">Daily
				<input type="radio" name="repeat" value="ww">Weekly
				<input type="radio" name="repeat" value="m">Monthly<br>
				For how long: <input type="text" name="repeatvalue" size="2" maxlength="2">
			</td>
		</tr>
		<tr> 
			<td valign="TOP" class="small"><b>Status:</b></td>
			<td valign="TOP"> 
				<select name="eventStatus" class="small">
					<option value="0"<cfif evStatus eq 0> SELECTED</cfif>>Deactive</option>
					<option value="1"<cfif evStatus eq 1> SELECTED</cfif>>Active</option>
					<option value="2"<cfif evStatus eq 2> SELECTED</cfif>>Cancelled</option>
					<option value="3"<cfif evStatus eq 3> SELECTED</cfif>>Postponed</option>
				</select>
			</td>
		</tr>
		<tr> 
			<td colspan="2">
				<center>
				<input type="submit" name="submit" value="<cfoutput>#action#</cfoutput> Event" class="small"> 
				<input type="button" value="Close Window" onClick="window.close();" class="small">
				<cfif #action# eq 'Update'>
				<input type="submit" name="DeleteEvent" value="Delete Event" class="small">
				</cfif>
				</center>
			</td>
		</tr>
		<tr> 
			<td colspan="2" class="small">* Required Field</td>
		</tr>
	</table>
	</cfform>

</center>

</body>
</html>