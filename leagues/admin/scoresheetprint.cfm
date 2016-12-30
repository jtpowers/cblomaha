<cfset rootDir = "../../">
<cfquery name="getSeasons" datasource="#memberDSN#">
	Select *
	From sl_season
	Where LeagueID = #url.lid#
	Order by StartDate desc, SeasonName
</cfquery>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfquery name="getDivs" datasource="#memberDSN#">
	Select divname, gender, seasonid, divid
	From sl_division
	Where seasonid = #form.sid#
	Order by divname
</cfquery>
<cfquery name="getGameDates" datasource="#memberDSN#">
	Select g.gamedate
	From sl_game g, sl_team t, sl_division d
	Where t.teamid = g.H_Teamid and
			d.divid = t.divid and
			d.seasonid = #form.sid#
	Group by gamedate
	Order by gamedate
</cfquery>

<cfset pageTitle = "Sports League - Scoresheets">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput> - Administration</title>
<cfinclude template="#rootDir#ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="#rootDir#ssi/header.htm">
<cfinclude template="sl_header.cfm">
<table>
	<tr>
		<td class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<form action="scoresheetprint.cfm" method="post">
	<tr>
		<td>
			<table>
				<tr>
					<td class="smallb">Season:</td>
					<td>
						<select name="sid" class="small" onChange="document.forms(0).submit();">
						<cfoutput query="getSeasons">
							<option value="#seasonid#"<cfif seasonid EQ form.sid> selected</cfif>>#seasonname#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</form>
	<form action="print.cfm" target="_blank" method="post">
	<input type="hidden" name="sid" value="<cfoutput>#form.sid#</cfoutput>">
	<tr>
		<td valign="top" class="titlesub">Print Scoresheets:
			<table border="1" cellspacing="0" cellpadding="3">
			<tr><td>
				<table>
				<tr>
					<td class="smallb">Division:</td>
					<td>
						<select name="did" class="small">
							<option value="all">All</option>
						<cfoutput query="getDivs">
							<option value="#divid#">#gender# #divname#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">Game Date:</td>
					<td>
						<cfset selectNotDone = 1>
						<select name="gDate" class="small">
						<cfoutput query="getGameDates">
							<cfif DateFormat(gamedate, 'yyyymmdd') GTE DateFormat(now(), 'yyyymmdd') 
									AND selectNotDone>
								<cfset selectNotDone = 0>
								<cfset isSelected = " selected">
							<cfelse>
								<cfset isSelected = "">
							</cfif>
							<option value="#DateFormat(gamedate, 'yyyy-mm-dd')#"#isSelected#>#DateFormat(gamedate, 'ddd, mm/dd/yyyy')#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">Sort By:</td>
					<td>
						<select name="sortby" class="small">
							<option value="c.courtname, g.gametime">Court & Game Time</option>
							<option value="d.divid">Division</option>
							<option value="g.gametime">Game Time</option>
						</select>
					</td>
				</tr>
				<tr><td colspan="2">
					<div align="center">
						<input type="submit" name="formathtml" value="Print" class="small"> 
						<input type="submit" name="formatpdf" value="Print to PDF" class="small"> 
					</div>
				</td></tr>
			</table>
		</td>
	</tr>
	</form>
</table>
</td></tr></table>
</body>
</html>
