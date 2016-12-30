<center>
<!--- begin calendar --->
<table width="95%" border="1" cellspacing="0" cellpadding="3">
<cfoutput>
<TR bgcolor="#application.sl_tbcolor#" bordercolor="#application.sl_tbcolor#">
</cfoutput>
<CFOUTPUT> 
    <td colspan="7" align="CENTER" valign="TOP" class="titlesubw">
		#cName# - #MonthAsString(SelectedMonth)# #SelectedYear#
	</td>
</CFOUTPUT>
</tr>
<cfoutput>
<TR bgcolor="#application.sl_arcolor#" bordercolor="#application.sl_arcolor#">
</cfoutput>
 	<th width="14.3%" align="CENTER" class="smallb">Sunday</TH>
    <th width="14.3%" align="CENTER" class="smallb">Monday</TH>
	<th width="14.3%" align="CENTER" class="smallb">Tuesday</TH>
	<th width="14.3%" align="CENTER" class="smallb">Wednesday</TH>
	<th width="14.3%" align="CENTER" class="smallb">Thursday</TH>
	<th width="14.3%" align="CENTER" class="smallb">Friday</TH>
	<th width="14.3%" align="CENTER" class="smallb">Saturday</TH>
</TR>
<TR>
<cfset prevStartDay = daysinmonth(LAst_month) - first_nn + 1>
<CFLOOP FROM="#prevStartDay#" TO="#daysinmonth(LAst_month)#" INDEX="thisday">
	<cfset cellcolor = "C6D6FF">
	<td width="14.3%" height="60" valign="top" class="small" bgcolor="<cfoutput>#cellcolor#</cfoutput>">
		<CFSET innerdate = "#month(LAst_month)#/#thisday#/#year(LAst_month)#">
		<cfinclude template="calhtml-events.cfm">
	</td>
</CFLOOP>
<CFLOOP FROM="1" TO="#daysinmonth(firstday)#" INDEX="thisday">
	<CFIF THISDAY LT 10><cfset thisday = "0" & thisday></CFIF>
	<CFSET INNERDATE = "#month(firstday)#/#thisday#/#year(firstday)#">
	<cfset cellcolor = "FFFFFF">
	<td width="14.3%" height="60" valign="top" class="small" bgcolor="<cfoutput>#cellcolor#</cfoutput>">
		<cfinclude template="calhtml-events.cfm">
	</TD>
<CFIF #DAYOFWEEK(INNERDATE)# IS 7>
</TR>
<TR>
</CFIF>
</CFLOOP>
<CFLOOP FROM="1" TO="#last_nn#" INDEX="DayLoop">
	<cfset cellcolor = "C6D6FF">
	<td width="14.3%" height="60" valign="top" class="small" bgcolor="<cfoutput>#cellcolor#</cfoutput>">
		<CFSET innerdate = "#month(Next_month)#/#DayLoop#/#year(Next_month)#">
		<cfset thisday = DayLoop>
		<cfinclude template="calhtml-events.cfm">
	</td>
</CFLOOP>
</TR>
</TABLE>
<table align="center">
<tr><td><cfoutput><img src="#rootDir#images/#application.aid#/#application.sl_logo#" alt="#application.sl_name#" border="0"></cfoutput></td></tr>
</table>
</center>
<br><br>
