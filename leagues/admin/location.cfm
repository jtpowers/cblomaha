<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="menu" default="">
<cfparam name="action" default="">

<cfif isDefined("url.court")>
	<cfquery name="UpdateCourt" datasource="#application.memberDSN#">
		Update sl_court
		Set Status = <cfif fieldcond GT "">'#fieldcond#'<cfelse>NULL</cfif>,
				StatusDate = Sysdate()
		Where CourtID = #url.court#
	</cfquery>
</cfif>
<cfquery name="getLocations" datasource="#application.memberDSN#">
	Select l.locationid, l.locationname
	From sl_location l, sl_league_location ll
	Where ll.leagueid = #url.lid# and
			l.locationid = ll.locationid
	Order by LocationName
</cfquery>

<cfquery name="getFC" datasource="#application.memberDSN#">
	Select value_1, value_2 
	From sl_general_purpose 
	Where Name = 'FieldCondition'
	Order By Value_3
</cfquery>

<cfset pageTitle = "Location Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-sm-2 col-md-3 col-lg-4 col-xs-hidden"></div>
    <div class="col-sm-8 col-md-6 col-lg-4">
<table class="table table-condensed no-border">
	<tr>
		<td valign="top">
			<a href="javascript:fPopWindow('locationedit.cfm?lid=<cfoutput>#url.lid#</cfoutput>', 'custom','475','500','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Add New Location">Add Location</a>
			<table class="table table-condensed table-bordered">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" colspan="2">Location Name</td>
					<td class="titlesmw" align="center">Courts</td>
					<!--- <td class="titlesmw" align="center">Status</td>
					<td class="titlesmw" align="center">Status Date</td> --->
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfloop query="getLocations">
					<cfquery name="getCourts" datasource="#application.memberDSN#">
						Select courtid, courtname, locationid, status, value_2, statusdate
						From sl_court Left Join
							  (Select value_1, value_2 From sl_general_purpose Where Name = 'FieldCondition') fc On status = value_1
						Where locationid = #getLocations.locationid#
						Order by courtname
					</cfquery>
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="<cfoutput>#rColor#</cfoutput>">
						<cfoutput>
						<td class="small" valign="top" rowspan="#getCourts.RecordCount#">
							<a href="javascript:fPopWindow('locationedit.cfm?lid=#url.lid#&locaid=#Locationid#', 'custom','475','500','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Edit this Location">#Locationname#</a>
						</td>
						<td class="small" valign="top" align="right" rowspan="#getCourts.RecordCount#">
							<a href="javascript:fPopWindow('courtedit.cfm?lid=#url.lid#&locaid=#Locationid#', 'custom','350','250','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Add a Field to this Location">(Add Court)</a>
						</td>
						</cfoutput>
					<cfset cCount = 1>
					<cfloop query="getCourts">
						<cfif cCount GT 1><tr></cfif>
						<cfoutput>
						<td class="small" bgcolor="<cfoutput>#rColor#</cfoutput>"><a href="javascript:fPopWindow('courtedit.cfm?lid=#url.lid#&cid=#getCourts.courtid#', 'custom','350','250','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">#getCourts.courtname#</a>&nbsp;</td>
						</cfoutput>
						<cfset cCount = cCount + 1>
					</tr></cfloop>
					
				</cfloop>
			</table>
		</td>
	</tr>
</table>
    </div>
	<div class="clearfix col-sm-2 col-md-3 col-lg-4 col-xs-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
