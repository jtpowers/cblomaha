<cfset rootDir = "../">
<cfparam name="menu" default="">
<cfparam name="action" default="">

<cfquery name="getAds" datasource="#memberDSN#">
	Select AdID, AdName, AdLink, AdImage, AdPriority, AdCount
	From sl_advertiser
	Order by AdName
</cfquery>

<cfquery name="getLeagues" datasource="#memberDSN#">
	Select leagueid, leaguename
	From sl_league
	Where associd = #application.aid#
</cfquery>

<cfset pageTitle = "#application.sl_name# - Advertisers">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput> - Administration</title>
<cfinclude template="../ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="../ssi/header.htm">

<cfinclude template="sl_header.cfm">
<table>
	<tr>
		<td colspan="2" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td valign="top">
			<cfoutput>
			<a href="javascript:fPopWindow('adedit.cfm', 'custom','600','330','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Add Advertiser">Add Advertiser</a>
			</cfoutput>
			<table border="1" cellspacing="0" cellpadding="3">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center" rowspan="2">Advertiser</td>
					<td class="titlesmw" align="center" rowspan="2">Link</td>
					<td class="titlesmw" align="center" rowspan="2">Banner</td>
					<td class="titlesmw" align="center">MAA</td>
				<cfoutput query="getLeagues">
					<td class="titlesmw" align="center">#leaguename#</td>
				</cfoutput>
				</tr>
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" align="center">Priority</td>
				<cfoutput query="getLeagues">
					<td class="titlesmw" align="center">Priority</td>
				</cfoutput>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfloop query="getAds">
					<cfif rColor EQ "FFFFFF">
						<cfset rColor = "#application.sl_arcolor#">
					<cfelse>
						<cfset rColor = "FFFFFF">
					</cfif>
					<tr bgcolor="<cfoutput>#rColor#</cfoutput>">
						<td class="small" valign="top">
						<cfoutput>
							<a href="javascript:fPopWindow('adedit.cfm?adid=#AdID#', 'custom','600','330','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" CLASS="linksm" title="Edit Advertiser">
							#AdName#
							</a>
						</cfoutput>
						</td>
						<td class="small" valign="top"><cfoutput>#AdLink#</cfoutput>&nbsp;</td>
						<td class="small" valign="top">
							<cfif AdImage GT "">
							<cfoutput>
								<img src="#rootdir#ads/#AdImage#" alt="#AdName#">
							</cfoutput>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td class="small" align="center" valign="top">
							<cfif getAds.AdPriority GT ""><cfoutput>#getAds.AdPriority#</cfoutput><cfelse>0</cfif>
						</td>
						<cfset adidHold = #getAds.AdID#>
						<cfoutput query="getLeagues">
							<cfquery name="getAdLeague" datasource="#memberDSN#">
								Select AdPriority, AdCount
								From sl_advertiser_league
								Where AdID = #adidHold# and LeagueID = #getLeagues.leagueid#
							</cfquery>
						<td class="small" align="center" valign="top">
							<cfif getAdLeague.AdPriority GT "">#getAdLeague.AdPriority#<cfelse>0</cfif>
						</td>
						</cfoutput>
					</tr>
				</cfloop>
			</table>
		</td>
	</tr>
</table>
</td></TR>
</TABLE>
<br><br>

</body>
</html>
