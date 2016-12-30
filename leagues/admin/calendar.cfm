<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfparam name="url.lid" default="">

<cfquery name="getCalendars" datasource="#application.memberDSN#">
	Select *
	From sl_calendar
	Where <cfif url.lid GT "">
				leagueid = #url.lid#
			<cfelse>
				leagueid is null and associd = #application.aid#
			</cfif>
	ORDER BY calOrder
</cfquery>

<cfquery name="getCalOrder" datasource="#application.memberDSN#">
	Select Min(CalOrder) as minorder, Max(CalOrder) as maxorder
	From sl_calendar
	Where <cfif url.lid GT "">
				leagueid = #url.lid#
			<cfelse>
				leagueid is null and associd = #application.aid#
			</cfif>
</cfquery>

<cfset pageTitle = "Calendar Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-4 col-xs-hidden col-sm-hidden"></div>
    <div class="col-xs-12 col-md-4">
			<cfoutput>
			<a href="javascript:fPopWindow('caledit.cfm?lid=#url.lid#', 'custom','300','200','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Calendar">Add Calendar</a>
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
						<td class="small"><a href="javascript:fPopWindow('caledit.cfm?lid=#url.lid#&calid=#CalendarID#', 'custom','300','200','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Division">#CalName#</a></td>
						<td class="small" align="center">
						<cfif getCalOrder.minorder NEQ CalOrder>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&calid=#CalendarID#&dir=up&name=sl_calendar', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="#rootdir#wsimages/up.gif" alt="Move Up" border="0"></a>
						<cfelse>
							<img src="../wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						<cfif getCalOrder.maxorder NEQ CalOrder>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&calid=#CalendarID#&dir=down&name=sl_calendar', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="#rootdir#wsimages/down.gif" alt="Move Down" border="0"></a>
						<cfelse>
							<img src="../wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						</td>
						<td class="small"><a href="event.cfm?lid=#url.lid#&calid=#calendarid#" CLASS="linksm" title="View Teams">Events</a></td>
					</tr>
				</cfoutput>
			</table>
    </div>
	<div class="clearfix col-md-4 col-xs-hidden col-sm-hidden"></div>
</div></div>
<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
