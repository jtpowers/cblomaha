<CFSET NewLine = Chr(10)>
<CFSET CrgRtn = Chr(13)>

<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%">
<tr><td class="smallb">
	#thisday#
</td></tr>
<tr><td class="small">
<cfloop query="Events">
<cfset #count# = 0>
<cfif #Events.eventDate# is #innerdate#>
	<cfset timeplace = "<b>#Events.title#</b><br>">
	<cfif status EQ 2>
		<cfset timeplace = "#timeplace# *** CANCELLED ***">
		<cfset detailclass = "onheresm">
	<cfelseif status EQ 3>
		<cfset timeplace = "#timeplace# *** POSTPONED ***">
		<cfset detailclass = "onheresm">
	<cfelse>
		<cfset sTime = #TimeFormat(startTime, 'h')#>
		<cfset sMin = #TimeFormat(startTime, 'mm')#>
		<cfset sAMPM = "#TimeFormat(startTime, 'tt')#">
		<cfset eTime = #TimeFormat(endTime, 'h')#>
		<cfset eMin = #TimeFormat(endTime, 'mm')#>
		<cfset eAMPM = "#TimeFormat(endTime, 'tt')#">
		<cfif startTime GT "">
			<cfset timeplace = "#timeplace# #stime#:#sMin# #sAMPM#">
			<cfif endTime GT "">
				<cfset timeplace = "#timeplace# - #etime#:#eMin# #eAMPM#">
			</cfif>
		</cfif>
		<cfset detailclass = "linksm">
	</cfif>
	<cfif location GT "">
		<cfset timeplace = "#timeplace#<br>@ #location#">
	</cfif>
	<cfif description GT "">
		<cfset fulltext = Replace(description, NewLine, '', 'All')>
		<cfset fulltext = Replace(fulltext, CrgRtn, '<br>', 'All')>
		<cfset timeplace = "#timeplace#<br>#fulltext#">
	</cfif>
	<cfset detailaction = "View">
		<cfset newTimePlace = "#REPLACE(timeplace, "'", "")#">
		<a href="javascript:fPopWindow('event.cfm?eventid=#Events.eventid#&action=#detailaction#', 'custom','400','470','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="#detailclass#" onMouseover="ddrivetip('#newTimePlace#','aqua');" onMouseout="hideddrivetip();">#Events.title#</a>
	<br><br>
	<cfset #count#= 1>
</cfif>
</cfloop>
<!--- <cfloop query="Holidays">
<cfif #MONTH(holidayDate)# is #MONTH(innerdate)# AND #DAY(holidayDate)# is #DAY(innerdate)#>
	<b>#name#</b><br>
</cfif>
</cfloop> --->
</td></tr></table>
</cfoutput>
