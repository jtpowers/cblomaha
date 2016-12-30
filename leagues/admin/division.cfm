<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="action" default="">

<cfset getSeasons = leagueObj.getSeasons(#url.lid#)>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfset getDivisions = leagueObj.getDivisions(#url.lid#,#form.sid#)>

<cfquery name="getDivOrder" datasource="#application.memberDSN#">
	Select Min(DivOrder) as minorder, Max(DivOrder) as maxorder
	From sl_division
	Where seasonID = #form.sid#
</cfquery>

<cfset pageTitle = "Division Edit">

<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
    <div class="col-md-8">
<table class="table table-condensed no-border">
	<form action="division.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post">
	<tr>
		<td align="center" class="smallb">
			Season:
			<select name="sid" onChange="document.forms[0].submit();" class="small">
			<cfoutput query="getSeasons">
				<option value="#SeasonID#"<cfif SeasonID EQ form.sid> SELECTED</cfif>>#SeasonName#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
	</form>
	<tr>
		<td valign="top">
			<cfoutput>
			<a href="javascript:fPopWindow('divisionedit.cfm?lid=#url.lid#&sid=#form.sid#', 'custom','800','500','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Division">Add Division</a>
			</cfoutput>
			<table class="table table-responsive table-bordered table-striped table-condensed">
			<thead>
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<th class="text-center titlesmw">Name</th>
					<th class="text-center titlesmw">Season</th>
					<th class="text-center titlesmw hidden-xs">Gender</th>
					<th class="text-center titlesmw">Order</th>
					<th class="text-center titlesmw">&nbsp;</th>
					<th class="text-center titlesmw">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getDivisions">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="#rColor#">
						<td class="small"><a href="javascript:fPopWindow('divisionedit.cfm?lid=#url.lid#&sid=#form.sid#&did=#DivID#', 'custom','800','500','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Division">#DivName#</a></td>
						<td class="small">#SeasonName#</td>
						<td class="small hidden-xs">#Gender#</td>
						<td class="small" align="center">
						<cfif getDivOrder.minorder NEQ DivOrder>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&did=#DivID#&dir=up&name=sl_division', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="#rootdir#wsimages/up.gif" alt="Move Up" border="0"></a>
						<cfelse>
							<img src="#rootdir#wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						<cfif getDivOrder.maxorder NEQ DivOrder>
							<a href="javascript:fPopWindow('changeorder.cfm?lid=#url.lid#&did=#DivID#&dir=down&name=sl_division', 'custom','5','5','toolbar: 0','status: 0','location: 0','menubar: 0','scrollbars: 0')"><img src="#rootdir#wsimages/down.gif" alt="Move Down" border="0"></a>
						<cfelse>
							<img src="#rootdir#wsimages/space.gif" width="18" height="1" border="0">
						</cfif>
						</td>
						<td class="small"><a href="team.cfm?lid=#url.lid#&did=#divid#" CLASS="linksm" title="View Teams">Teams</a></td>
						<td class="small"><a href="game.cfm?lid=#url.lid#&did=#divid#" CLASS="linksm" title="View Games">Games</a></td>
					</tr>
				</cfoutput>
			</tbody>
			</table>
		</td>
	</tr>
</table>
    </div>
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
