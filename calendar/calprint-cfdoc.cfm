<!--- Bring in Style Sheet Elements --->
<cfinclude template="../css/docStyles.cfm">

<!--- begin calendar --->
<cfdocument format="#url.format#" backgroundvisible="yes" orientation="landscape" margintop=".25" marginbottom=".25" unit="in" marginleft=".25" marginright=".25">

<center>

<table width="100%" border="1" cellspacing="0" cellpadding="3">
<TR bgcolor="#8080FF" bordercolor="#8080FF">
<CFOUTPUT> 
    <td colspan="7" align="CENTER" valign="TOP" style="#titlesub#">
		#getCal.calName# - #MonthAsString(SelectedMonth)# #SelectedYear#
	</td>
</CFOUTPUT>
</tr>
<cfoutput>
<TR bgcolor="#application.sl_arcolor#" bordercolor="#application.sl_arcolor#">
</cfoutput>
<cfoutput>
 	<th align="CENTER" style="#smallb#">Sunday</TH>
    <th align="CENTER" style="#smallb#">Monday</TH>
	<th align="CENTER" style="#smallb#">Tuesday</TH>
	<th align="CENTER" style="#smallb#">Wednesday</TH>
	<th align="CENTER" style="#smallb#">Thursday</TH>
	<th align="CENTER" style="#smallb#">Friday</TH>
	<th align="CENTER" style="#smallb#">Saturday</TH>
</cfoutput>
</TR>
<TR>
<cfset prevStartDay = daysinmonth(LAst_month) - first_nn + 1>
<CFLOOP FROM="#prevStartDay#" TO="#daysinmonth(LAst_month)#" INDEX="thisday">
	<cfset cellcolor = "C6D6FF">
	<cfoutput>
	<td height="60" valign="top" style="#small#" bgcolor="#cellcolor#">
		<CFSET innerdate = "#month(LAst_month)#/#thisday#/#year(LAst_month)#">
		<cfinclude template="caldoc-events.cfm">
	</td>
	</cfoutput>
</CFLOOP>
<CFLOOP FROM="1" TO="#daysinmonth(firstday)#" INDEX="thisday">
	<cfoutput>
	<CFIF THISDAY LT 10><cfset thisday = "0" & thisday></CFIF>
	<CFSET INNERDATE = "#month(firstday)#/#thisday#/#year(firstday)#">
	<cfset cellcolor = "FFFFFF">
<td height="60" valign="top" style="#small#" bgcolor="#cellcolor#">
	<cfinclude template="caldoc-events.cfm">
</TD>
	<CFIF #DAYOFWEEK(INNERDATE)# IS 7>
</TR>
<TR>
	</CFIF>
</CFOUTPUT>
</CFLOOP>
<CFLOOP FROM="1" TO="#last_nn#" INDEX="DayLoop">
	<cfset cellcolor = "C6D6FF">
	<cfoutput>
	<td height="60" valign="top" style="#small#" bgcolor="#cellcolor#">
		<CFSET innerdate = "#month(Next_month)#/#DayLoop#/#year(Next_month)#">
		<cfset thisday = DayLoop>
		<cfinclude template="caldoc-events.cfm">
	</td>
	</cfoutput>
</CFLOOP>
</TR>
</TABLE>
<table align="center">
<tr><td><cfoutput><img src="#rootDir#images/#application.sl_logo#" alt="#application.sl_name#" border="0"></cfoutput></td></tr>
</table>
</center>
</cfdocument>
