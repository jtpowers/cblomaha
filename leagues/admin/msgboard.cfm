<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="action" default="">

<cfquery name="getMessages" datasource="#application.memberDSN#">
	Select *
	From sl_messageboard
	Where leagueid = #url.lid#
	Order by ExpirationDate, Posteddate desc
</cfquery>
<cfset rootDir = "../../">

<cfset pageTitle = "Message Board Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
    <div class="col-md-8">

<table class="table table-condensed no-border">
	<tr>
		<td valign="top">
			<a href="javascript:fPopWindow('msgboardedit.cfm?lid=<cfoutput>#url.lid#</cfoutput>', 'custom','500','400','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Message">Add Message</a>
			<table class="table table-condensed table-bordered">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center">Title</td>
					<td class="titlesmw" align="center">Posted Date</td>
					<td class="titlesmw" align="center">Exiration Date</td>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfoutput query="getMessages">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="#rColor#">
						<td class="small"><a href="javascript:fPopWindow('msgboardedit.cfm?lid=#url.lid#&msgid=#messageid#', 'custom','500','400','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Message">#Title#</a></td>
						<td class="small" align="center">#DateFormat(PostedDate, "mm/dd/yyyy")#&nbsp;</td>
						<td class="small" align="center">#DateFormat(ExpirationDate, "mm/dd/yyyy")#&nbsp;</td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
    </div>
	<div class="clearfix col-md-2 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
