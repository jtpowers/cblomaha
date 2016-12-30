<TR>
<cfset prevStartDay = daysinmonth(LAst_month) - first_nn + 1>
<CFLOOP FROM="#prevStartDay#" TO="#daysinmonth(LAst_month)#" INDEX="thisday">
	<cfset cellcolor = "CCCCCC">
	<td width="14.3%" height="60" valign="top" class="small" bgcolor="#cccccc">
		<CFSET innerdate = "#month(LAst_month)#/#thisday#/#year(LAst_month)#">
		<!--- <cfinclude template="dayEvents.cfm"> --->
		<cfinclude template="calhtml-events.cfm">
	</td>
</CFLOOP>
<CFLOOP FROM="1" TO="#daysinmonth(firstday)#" INDEX="thisday">
	<CFIF THISDAY LT 10><cfset thisday = "0" & thisday></CFIF>
	<CFSET INNERDATE = "#month(firstday)#/#thisday#/#year(firstday)#">
	<cfif innerdate is DateFormat(now(),"d-mmm-yyy")>
		<cfset cellcolor="FFFF80">
	<cfelse>
		<cfset cellcolor = "FFFFFF">
	</cfif>
	<td width="14.3%" height="60" valign="top" class="small" bgcolor="<cfoutput>#cellcolor#</cfoutput>">
		<!--- <cfinclude template="dayEvents.cfm"> --->
		<cfinclude template="calhtml-events.cfm">
	</td>
	<CFIF #DAYOFWEEK(INNERDATE)# IS 7>
	</TR>
	<TR>
	</CFIF>
</CFLOOP>
<CFLOOP FROM="1" TO="#last_nn#" INDEX="DayLoop">
	<cfset cellcolor = "CCCCCC">
	<td width="14.3%" height="60" valign="top" class="small" bgcolor="#cccccc">
		<CFSET innerdate = "#month(Next_month)#/#DayLoop#/#year(Next_month)#">
		<cfset thisday = DayLoop>
		<!--- <cfinclude template="dayEvents.cfm"> --->
		<cfinclude template="calhtml-events.cfm">
	</td>
</CFLOOP>
</TR>