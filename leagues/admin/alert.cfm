<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfset getAlerts = adminObj.getAlerts(#url.lid#)>

<cfset pageTitle = "Edit Alerts">

<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-4 col-xs-hidden col-sm-hidden"></div>
    <div class="col-md-4">
		<a href="javascript:fPopWindow('alertedit.cfm?lid=<cfoutput>#url.lid#</cfoutput>', 'custom','500','400','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Alert">Add Alert</a>
    	<table class="table table-hover table-bordered table-striped table-condensed">
        <thead>
			<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
                <th class="text-center titlesmw">Name</th>
                <th class="text-center titlesmw">Start Date</th>
                <th class="text-center titlesmw">End Date</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="getAlerts">
            <tr>
                <td><a href="javascript:fPopWindow('alertedit.cfm?lid=#url.lid#&alertid=#alertid#', 'custom','500','400','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Alert">#AlertTitle#</a></td>
                <td class="text-center small">#DateFormat(StartDate, "mm/dd/yyyy")#&nbsp;</td>
                <td class="text-center small">#DateFormat(EndDate, "mm/dd/yyyy")#&nbsp;</td>
            </tr>
            </cfoutput>
		</tbody>
		</table>
    </div>
	<div class="clearfix col-md-4 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
