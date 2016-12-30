<cfset rootdir = "../">
<cfparam name="url.lid" default="">

	<cfquery name="getEventInfo" datasource="#memberDSN#">
		SELECT * FROM sl_calendar_event 
		WHERE eventID = #eventid#
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

<cfset pageTitle = "View Event">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta http-equiv="Content-Language" content="en-us">
<meta name="description" content="Web developers personal web site with Web Development Help and Powers Family and Friends Private web site.">
<meta name="keywords" content="powers,powers family,internet,web development,HTML,Cold Fusion,ColdFusion,Java,Javascript,powersone,powersone.com">
<title><cfoutput>#application.sl_name# - #pageTitle#</cfoutput></title>
<cfinclude template="#rootdir#ssi/webscript.htm">
</head>

<body topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" bgcolor="#9999FF">
<center>

	<table border="0" bgcolor="9999FF" cellpadding="6" bordercolorlight="black" bordercolordark="white" cellspacing="0" width="100%">
		<tr> 
			<td colspan="2" align="center"class="titlemain" bgcolor="#000000">
				<font color="#ffff00">View Event.</font>
			</td>
	    </tr>
		<tr> 
			<td valign="TOP"><b>Date</b></td>
	      	<td valign="TOP"><cfoutput>#DateFormat(evdate, "mm/dd/yy")#</cfoutput></td>
	    </tr>
		<tr> 
			<td valign="TOP"><b>Start Time:</b></td>
	      	<td valign="TOP">
				<cfif sTime EQ 0 OR LEN(sTime) EQ 0>
					None
				<cfelse>
					<cfoutput>#sTime#:#sMin# #sAMPM#</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr> 
			<td valign="TOP"><b>End Time:</b></td>
	      	<td valign="TOP">
				<cfif eTime EQ 0 OR LEN(eTime) EQ 0>
					None
				<cfelse>
					<cfoutput>#eTime#:#eMin# #eAMPM#</cfoutput>
				</cfif>
			</td>
		</tr>
	    <tr> 
			<td valign="TOP"><b>Title</b></td>
			<td valign="TOP"><cfoutput>#evTitle#</cfoutput></td>
		</tr>
		<tr> 
			<td valign="TOP">	<b>Location:</b></td>
			<td valign="TOP"> 
				<cfoutput>#evLoca#</cfoutput>
			</td>
		</tr>
		<tr> 
			<td valign="TOP"><b>Description</b></td>
			<td valign="TOP">
				<textarea cols="30" rows="5" name="eventDesc" readonly class="small"><cfoutput>#evDesc#</cfoutput></textarea>
			</td>
		</tr>
		<tr> 
			<td colspan="2">
				<br><br>
			</td>
		</tr>
		<tr> 
			<td colspan="2" align="center">
				<input type="button" value="Close Window" onClick="window.close();">
			</td>
		</tr>
		<tr> 
			<td colspan="2">
				<br><br>
			</td>
		</tr>
	</table>
</center>

</body>
</html>