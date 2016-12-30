<cfparam name="P1Userid" default="joe">

<cfif ParameterExists(P1Userid)>
	<cfquery datasource="#memberDSN#" dbtype="ODBC" name="getInfo">
		SELECT firstName, lastname, password, email FROM Member WHERE memberID = '#P1Userid#'
	</cfquery>
</cfif>

<cfif isDefined("url.year")>
	<cfset currentdate = "#dateformat('#url.year#-#url.month#-01')#">
</cfif>
<!--- set parameters --->
	<CFPARAM NAME="url.format" DEFAULT="html">
	<CFPARAM NAME="cityid" DEFAULT="597">
	<CFPARAM NAME="currentdate" DEFAULT="#dateformat(now())#">
	<CFPARAM NAME="currentMonth" DEFAULT="#month(now())#">
	<CFPARAM NAME="currentYear" DEFAULT="#year(now())#">
	<CFPARAM NAME="detail" DEFAULT="0">
	<CFPARAM NAME="FormDate" DEFAULT="#currentdate#">
	<CFPARAM NAME="ThisDate" DEFAULT="#FormDate#">
	<CFPARAM NAME="SelectedMonth" DEFAULT="#month(ThisDate)#">
	<CFPARAM NAME="SelectedYear" DEFAULT="#year(ThisDate)#">
	<CFSET FIRSTDAY= SelectedMonth & "/1/" & SelectedYear>
	<CFSET LASTDAY= SelectedMonth & "/" & #DAYSINMONTH(FIRSTDAY)# & "/" & SelectedYear >
	<CFSET FIRST_NN = #DAYOFWEEK(FIRSTDAY)# - 1>
	<CFSET LAST_NN = 7 - #DAYOFWEEK(LASTDAY)# >
	<CFSET Next_month = #dateformat(DateAdd("m",1,"#currentdate#"))#>
	<CFSET LAst_month = #dateformat(DateAdd("m",-1,"#currentdate#"))#>
<!--- end parameters --->

<!-- BEGIN DATA WINDOW -->
<cfquery name="Events" datasource="#memberDSN#" dbtype="ODBC">
SELECT *
FROM Event
WHERE <cfif ParameterExists(P1Userid)>
				((memberID='#P1Userid#') OR (publicview IN (1, 2, 3)))
			<cfelse>
				publicview IN (2, 3)
			</cfif>
			AND eventDate > '#DateFormat(LAst_month, "YYYY-MM")#-21'
ORDER BY eventDate, starttime
</cfquery>

<cfset #HolidayOutlook# = #DayOfYear(DateAdd('M', 2, Now()))#>

<cfquery name="Holidays" datasource="#memberDSN#" dbtype="ODBC">
SELECT 
	Name, holidayDate
FROM Holiday
ORDER BY holidayDate 
</cfquery>
<cfquery name="Birthdays" datasource="#memberDSN#" dbtype="ODBC">
SELECT CONCAT(firstName, ' ' , LEFT(lastname, 1), '.') as firstName, birthday
FROM Member
WHERE birthday is not NULL
	AND shareInfo = 1
ORDER BY birthday 
</cfquery>

<cfset pageTitle = "#MonthAsString(SelectedMonth)# #SelectedYear#">
<html>
<head>
<cfinclude template="../webscript.htm">
<title>Powersone.com - <cfoutput>#pageTitle#</cfoutput></title>
</head>

<body topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">

<center>
<cfoutput>
<font class="titlemain"><br>#pageTitle#<br></font>
</cfoutput>
<!--- begin calendar --->
<table width="100%" border="1" cellspacing="0" cellpadding="3">
<TR bgcolor="#d7d7d7" bordercolor="#d7d7d7">
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
		<cfinclude template="caldesktop-events.cfm">
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
		<cfinclude template="caldesktop-events.cfm">
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
		<cfinclude template="caldesktop-events.cfm">
	</td>
</CFLOOP>
</TR>
</TABLE>
</center>

</body>
</html>