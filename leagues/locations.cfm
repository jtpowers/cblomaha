<cfset rootDir = "../">
<cfobject component="cfc.league" name="leagueObj">
<cfset errmsg = "">
<cfparam name="url.lid" default="1">


<cfset getTopLocation = leagueObj.getTopLocation(#url.lid#)>
<cfobject component="cfc.association" name="assocObj">

<cfparam name="url.locaid" default="#getTopLocation.locationid#">
<cfif getTopLocation.RecordCount GT 0>
	<cfset getLocation = leagueObj.getLocation(#url.locaid#)>
</cfif>
<cfset pageTitle = "Locations">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<cfif getTopLocation.RecordCount GT 0>
<cfset getLocationsList = leagueObj.getLocationsList(#url.lid#)>
<table class="table table-condensed">
	<tr>
		<td width="210" valign="top" align="center" class="hidden-xs hidden-sm">
            <table class="hideme" cellpadding="0" cellspacing="0">
            <tr><td class="titlesub" align="center">
			<div class="panel panel-primary">
				<div class="panel-heading">
					Locations
				</div>
				<div class="panel-body panel-body-smpad">
                <table border="0" cellpadding="2" cellspacing="0" width="100%">
                <cfoutput query="getLocationsList">
                <tr class="danger">
                    <td valign="top" width="19">
                        <cfif isDefined("url.lid")>
                            <img src="#rootdir#wsimages/#application.sl_leaguesport#_icon.gif" width="17" height="17">
                        <cfelse>
                            <img src="#rootdir#wsimages/basketball_icon.gif" width="17" height="17" border="0">
                        </cfif>
                    </td>
                    <td>
                        <a href="locations.cfm?lid=#url.lid#&locaid=#locationid#" class="link">#locationname#</a>
                    </td>
                </tr>
                </cfoutput>
                </table>
				</div>
			</div>
            </td></tr></table>
		</td>
	<td valign="top">

		<cfoutput>
        <table width="100%">
            <tr>
                <td class="titlemain" align="center">#getLocation.LocationName#</td>
            </tr>
            <tr><td class="titlesub">Address:</td></tr>
            <tr><td>#getLocation.Address#&nbsp;</td></tr>
            <tr><td>#getLocation.City#, #getLocation.State# #getLocation.ZipCode#&nbsp;</td></tr>
            <cfif LEN(getLocation.MapURL) GT 0>
                <tr><td><a href="#getLocation.MapURL#" target="_blank" class="link">Click Here for Map</a></td></tr>
            </cfif>
            <tr><td>#getLocation.Phone#&nbsp;</td></tr>
            <tr><td class="titlesub">#getLocation.Directions#&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr>
            <cfif LEN(getLocation.MapImage) GT 0>
                <tr><td><img src="#rootdir#images/#application.aid#/#url.lid#/#getLocation.MapImage#" border="0"></td></tr>
            </cfif>
        </table>
        </cfoutput>
</cfif>
<cfinclude template="#rootdir#ssi/footer_ad.cfm">
</div>
<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
