<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%">
<tr><td style="#small#">
<b>#thisday#</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</td></tr>
<tr><td style="#small#">
<cfloop query="Events">
<cfset #count# = 0>
<cfif #Events.eventDate# is #innerdate#>
	<cfset evTime = "">
	<cfset evPlace = "">
	<cfif status EQ 2>
		<cfset evTime = "CANCELLED<br>">
	<cfelse>
		<cfset sTime = #TimeFormat(startTime, 'h')#>
		<cfset sMin = #TimeFormat(startTime, 'mm')#>
		<cfset sAMPM = "#TimeFormat(startTime, 'tt')#">
		<cfset eTime = #TimeFormat(endTime, 'h')#>
		<cfset eMin = #TimeFormat(endTime, 'mm')#>
		<cfset eAMPM = "#TimeFormat(endTime, 'tt')#">
		<cfif startTime GT "">
			<cfset evTime = "#stime#:#sMin# #sAMPM#">
			<cfif endTime GT "">
				<cfset evTime = "#evTime#-#etime#:#eMin# #eAMPM#<br>">
			<cfelse>
				<cfset evTime = "#evTime#<br>">
			</cfif>
		<cfelse>
			<cfset evTime = "*">
		</cfif>
		<cfif location GT "">
			<cfset evPlace = "<br>@ #location#">
		</cfif>
		<cfif description GT "">
			<cfset evPlace = "#evPlace#<br>#description#">
		</cfif>
	</cfif>
	<table width="100%" border="1" cellspacing="0" cellpadding="2"><tr><td style="#small#" bgcolor="#cellcolor#">
	<b>#evTime#</b>#Events.title##evPlace#
	</td></tr></table>
	<cfset #count#= 1>
</cfif>
</cfloop>
</td></tr></table>
</cfoutput>