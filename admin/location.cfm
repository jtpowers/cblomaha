<cfset rootDir = "../">
<cfparam name="menu" default="">
<cfparam name="action" default="">
	
<cfquery name="getLocations" datasource="#memberDSN#">
	Select l.locationid, l.locationname
	From sl_location l, sl_league_location ll
	Where ll.leagueid = #application.lid# and
			l.locationid = ll.locationid
	Order by LocationName
</cfquery>

<cfset rootDir = "../">
<cfset pageTitle = "#application.sl_name# - Location Edit">
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
<table>
	<tr>
		<td colspan="2" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td valign="top">
			<a href="javascript:fPopWindow('locationedit.cfm', 'custom','400','375','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Add New Location">Add Location</a>
			<table border="1" cellspacing="0" cellpadding="3">
				<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesmw" colspan="2">Location Name</td>
					<td class="titlesmw">Courts</td>
				</tr>
				<cfset rColor = "#application.sl_arcolor#">
				<cfloop query="getLocations">
					<cfquery name="getCourts" datasource="#memberDSN#">
						Select courtid, courtname, locationid
						From sl_court 
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
							<a href="javascript:fPopWindow('locationedit.cfm?locaid=#Locationid#', 'custom','400','375','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Edit this Location">#Locationname#</a>
						</td>
						<td class="small" valign="top" align="right" rowspan="#getCourts.RecordCount#">
							<a href="javascript:fPopWindow('courtedit.cfm?locaid=#Locationid#', 'custom','350','200','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Add a Court to this Location">(Add Court)</a>
						</td>
						</cfoutput>
					<cfset cCount = 1>
					<cfloop query="getCourts">
						<cfif cCount GT 1><tr></cfif>
						<cfoutput>
						<td class="small" bgcolor="<cfoutput>#rColor#</cfoutput>"><a href="javascript:fPopWindow('courtedit.cfm?cid=#getCourts.courtid#', 'custom','350','200','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">#getCourts.courtname#</a>&nbsp;</td>
						</cfoutput>
						<cfset cCount = cCount + 1>
					</cfloop>
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
