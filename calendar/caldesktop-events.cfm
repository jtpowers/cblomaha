<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%">
<tr><td class="smallb" bgcolor="C6D6FF">#thisday#</td></tr>
<tr><td class="small">
<cfloop query="Events">
<cfset #count# = 0>
<cfif #Events.eventDate# is #innerdate#>
	<cfset evTime = "">
	<cfset evPlace = "">
	<cfif status EQ 2>
		<cfset evTime = "CANCELLED<br>">
	<cfelseif status EQ 3>
		<cfset evTime = "POSTONED<br>">
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
	</cfif>
	<cfif location GT "">
		<cfset evPlace = "<br>@ #location#">
	</cfif>
	<table width="100%" border="1" cellspacing="0" cellpadding="1">
	<tr><td class="small" bgcolor="#cellcolor#">
	<b>#evTime#</b>#Events.title##evPlace#
	</td></tr></table>
	<cfset #count#= 1>
</cfif>
</cfloop>
<cfloop query="Birthdays">
<cfif #MONTH(birthday)# is #MONTH(innerdate)# AND #DAY(birthday)# is #DAY(innerdate)#>
	<br><b>#firstName# Birthday</b><br>
</cfif>
</cfloop>
<cfloop query="Holidays">
<cfif #MONTH(holidayDate)# is #MONTH(innerdate)# AND #DAY(holidayDate)# is #DAY(innerdate)#>
	<br><b>#name#</b><br>
</cfif>
</cfloop>
</td></tr></table>
</cfoutput>