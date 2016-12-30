<cfset rootDir = "../">
<cfparam name="url.lid" default="">

<cfquery name="getCalendars" datasource="#memberDSN#">
	Select *
	From sl_calendar
	Where <cfif url.lid GT "">
				leagueid = #url.lid#
			<cfelse>
				leagueid is null and associd = #application.aid#
			</cfif>
	ORDER BY calOrder
</cfquery>

<cfquery name="getCalOrder" datasource="#memberDSN#">
	Select Min(CalOrder) as minorder, Max(CalOrder) as maxorder
	From sl_calendar
	Where <cfif url.lid GT "">
				leagueid = #url.lid#
			<cfelse>
				leagueid is null and associd = #application.aid#
			</cfif>
</cfquery>

<cfset pageTitle = "#application.sl_name# - Calendar Edit">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#pageTitle#</cfoutput></title>
<cfinclude template="../ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="../ssi/header.htm">

<cfinclude template="sl_header.cfm">
<center>
<table>
	<tr>
		<td colspan="2" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td valign="top">
			<cfoutput>
			<a href="javascript:fPopWindow('caledit.cfm?lid=#url.lid#', 'custom','350','300','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Calendar">Add Calendar</a>
			</cfoutput>
			<table border="1" cellspacing="0" cellpadding="3">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw">Name</td>
					<td class="titlesmw">Order</td>
					<td class="titlesmw">&nbsp;</td>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getCalendars">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="#rColor#">
						<td class="small"><a href="javascript:fPopWindow('caledit.cfm?lid=#url.lid#&calid=#CalendarID#', 'custom','350','300','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Division">#CalName#</a></td>
						<td class="small" align="center">
						<cfif getCalOrder.minorder NEQ CalOrder>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&calid=#CalendarID#&dir=up&name=sl_calendar', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="../wsimages/up.gif" alt="Move Up" border="0"></a>
						<cfelse>
							<img src="../wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						<cfif getCalOrder.maxorder NEQ CalOrder>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&calid=#CalendarID#&dir=down&name=sl_calendar', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="../wsimages/down.gif" alt="Move Down" border="0"></a>
						<cfelse>
							<img src="../wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						</td>
						<td class="small"><a href="event.cfm?calid=#calendarid#" CLASS="linksm" title="View Teams">Events</a></td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
</center>
</td></TR>
</TABLE>
<br><br>

</body>
</html>
