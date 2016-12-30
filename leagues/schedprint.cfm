<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfset errmsg = "">
<cfset rootdir = "../">
<cfparam name="url.did" default="all">
<cfparam name="url.tid" default="all">
<cfparam name="url.gDate" default="all">
<cfparam name="url.locaid" default="all">

<cfif isDefined("url.sid")>
	<cfif url.did NEQ "all">
		<cfset sortby = "g.gamedate, g.gametime">
	<cfelse>
		<cfset sortby = "loca.locationname, c.courtname, g.gamedate, g.gametime">
	</cfif>
	
	<cfset getGames = leagueObj.getGameSchedule(#url.sid#,#url.did#,#url.tid#,#url.gDate#,#url.locaid#)>
</cfif>
<cfset pageTitle = "Schedule">
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
	<meta NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
	<meta name="verify-v1" content="G1jFD9V6EqBwrDRjylXS/eMxOL8NePpVLiOLn+gZLV0=" />
	
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  	<cfoutput>
  	<link rel="stylesheet" href="../css/styles.css">
  	</cfoutput>

  	<title><cfoutput>#application.sl_name#</cfoutput></title>
</head>
<body>

<center>
<cfif isDefined("url.sid")>
<table>
	<cfif application.sl_logo GT "">
		<tr>
			<td colspan="3" align="center">
				<cfoutput>
				<img src="#rootDir#images/#application.aid#/#url.lid#/#application.sl_leaguelogo#" alt="#application.sl_name#"><br>
				</cfoutput>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td colspan="3" class="titlemain" align="center"><cfoutput>#application.sl_name#</cfoutput><br><br></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="3" class="titlemain" align="center">
			<cfoutput>#application.sl_leaguename#</cfoutput>
		</td>
	</tr>
	<tr>
		<td colspan="3" class="titlemain" align="center">
			<cfif url.tid EQ "all">Game Schedule<cfelse>Team Schedule</cfif>
		</td>
	</tr>
	<tr>
		<td colspan="3" class="titlesub" align="center">
			<cfoutput>#getGames.seasonname#
			<cfif url.did NEQ "all">
				- #getGames.divname#
			</cfif>
			</cfoutput>
		</td>
	</tr>
	<cfif url.gdate EQ "all">
	<cfelseif url..gDate EQ "current">
		<tr>
			<td colspan="3" class="titlesub" align="center">
				<cfoutput>
				Current Schedule From #DateFormat(Now(), "mm/dd/yyyy")#
				</cfoutput>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td colspan="3" class="titlesub" align="center">
				<cfoutput>
				Schedule for #DateFormat(url.gdate, "mm/dd/yyyy")#
				</cfoutput>
			</td>
		</tr>
	</cfif>
	<cfif url.tid NEQ "all">
		<cfquery name="getTeam" datasource="#application.memberDSN#">
			Select name, leaguenbr, level, coachname
			From sl_team
			Where teamid = #url.tid#
		</cfquery>
		<tr>
			<td colspan="3" class="titlesub" align="center">&nbsp;
				
			</td>
		</tr>
		<tr>
			<td colspan="3" class="titlemain" align="center">
				<cfoutput>
				#getTeam.name#<br>
				<span class="titlesub">#getTeam.coachname#</span>
				</cfoutput>
			</td>
		</tr>
	</cfif>
	<tr>
		<td colspan="3" class="titlesub" align="center">&nbsp;
			
		</td>
	</tr>
	<tr>
		<td valign="top" class="titlesub" align="center">
			<table class="table table-condensed">
				<cfif url.did EQ "all">
				<cfelse>
				<tr bgcolor="#<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesubw" align="center">Date</td>
					<td class="titlesubw" align="center">Time</td>
					<!--- <td class="titlesubw" align="center">Game #</td> --->
					<td class="titlesubw" align="center">Home Team</td>
					<td class="titlesubw" align="center">Visitor Team</td>
					<td class="titlesubw" align="center">Score</td>
					<td class="titlesubw" align="center">Location</td>
				</tr>
				</cfif>
				<cfset changeHold = "">
				<cfset changeLoca = "#getGames.locationname[1]#">
				<cfset gColor = "C6D6FF">
				<cfoutput query="getGames">
					<cfif url.did EQ "all">
						<cfset locacourt = "#locationname# - #courtname#">
						<cfif locacourt NEQ changeHold>
							<cfif locationname NEQ changeLoca>
								<cfset PrintHeader()>
								<cfset changeLoca = locationname>
							</cfif>
							<tr bgcolor="FFFFF">
								<td class="small" align="center" colspan="5">&nbsp;</td>
							</tr>
							<tr bgcolor="#application.sl_tbcolor#">
								<td class="titlesubw" align="center" colspan="5">#locationname# - #courtname#</td>
							</tr>
							<tr bgcolor="#application.sl_tbcolor#">
								<td class="titlesubw" align="center">Date</td>
								<td class="titlesubw" align="center">Time</td>
								<!--- <td class="titlesubw" align="center">Game ##</td> --->
								<td class="titlesubw" align="center">Home Team</td>
								<td class="titlesubw" align="center">Visitor Team</td>
								<td class="titlesubw" align="center">Division</td>
							</tr>
							<cfset changeHold = locacourt>
							<cfset gColor = "C6D6FF">
						</cfif>
						<cfif gColor EQ "FFFFFF">
							<cfset gColor = "C6D6FF">
						<cfelse>
							<cfset gColor = "FFFFFF">
						</cfif>
					<cfelse>
						<cfif GameDate NEQ changeHold>
							<cfif gColor EQ "FFFFFF">
								<cfset gColor = "C6D6FF">
							<cfelse>
								<cfset gColor = "FFFFFF">
							</cfif>
							<cfset changeHold = GameDate>
						</cfif>
					</cfif>
					<tr bgcolor="#gColor#">
						<td class="small">#DateFormat(GameDate, "mm/dd/yyyy")#</td>
						<td class="small">#TimeFormat(GameTime, "h:mm tt")#</td>
						<!--- <td class="small">#GameNbr#&nbsp;</td> --->
						<td<cfif H_Points GT V_Points> class="smallb"<cfelse> class="small"</cfif>>
							<cfif hlnbr GT "">#hlnbr#. </cfif>#hteam#
						</td>
						<td<cfif H_Points LT V_Points> class="smallb"<cfelse> class="small"</cfif>>
							<cfif vlnbr GT "">#vlnbr#. </cfif>#vteam#
						</td>
					<cfif url.did EQ "all">
						<td class="small">#divname#</td>
					<cfelse>
						<td align="center" class="small">
						<cfif H_Points GT "">
							 #H_Points# - #V_Points#
						<cfelse>
							&nbsp;
						</cfif>
						</td>
						<td class="small">#shortname#<cfif courtname GT ""> - #courtname#</cfif></td>
					</cfif>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
<cfelse>
	Not enough information as passed.
</cfif>
</center>

<!--- =========================================Header Function=================================== --->

<!--- Function Name: PrintHeader
This function will print a header if the lineNum = totalNum --->

<cffunction name="PrintHeader">
			</table>
		</td>
	</tr>
</table>
<table style="page-break-before: always">
	<cfif application.sl_logo GT "">
		<tr>
			<td colspan="3" align="center">
				<cfoutput>
				<img src="#rootDir#images/#application.aid#/#url.lid#/#application.sl_leaguelogo#" alt="#application.sl_name#"><br>
				</cfoutput>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td colspan="3" class="titlemain" align="center"><cfoutput>#application.sl_name#</cfoutput><br><br></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="3" class="titlemain" align="center">
			<cfif url.tid EQ "all">Game Schedule<cfelse>Team Schedule</cfif>
		</td>
	</tr>
	<tr>
		<td colspan="3" class="titlesub" align="center">
			<cfoutput>#getGames.seasonname#
			<cfif url.did NEQ "all">
				- #getGames.divname#
			</cfif>
			</cfoutput>
		</td>
	</tr>
	<cfif url.gdate NEQ "all">
		<tr>
			<td colspan="3" class="titlesub" align="center">
				<cfoutput>
				Games Scheduled for #DateFormat(url.gdate, "mm/dd/yyyy")#
				</cfoutput>
			</td>
		</tr>
	</cfif>
	<cfif url.tid NEQ "all">
		<cfquery name="getTeam" datasource="#application.memberDSN#">
			Select name, leaguenbr, level, coachname
			From sl_team
			Where teamid = #url.tid#
		</cfquery>
		<tr>
			<td colspan="3" class="titlesub" align="center">&nbsp;
				
			</td>
		</tr>
		<tr>
			<td colspan="3" class="titlemain" align="center">
				<cfoutput>
				#getTeam.name# (#getTeam.level#)<br>
				<span class="titlesub">#getTeam.coachname#</span>
				</cfoutput>
			</td>
		</tr>
	</cfif>
	<tr>
		<td colspan="3" class="titlesub" align="center">&nbsp;
			
		</td>
	</tr>
	<tr>
		<td valign="top" class="titlesub" align="center">
			<table border="0" cellspacing="0" cellpadding="3">
				<cfif url.did EQ "all">
				<cfelse>
				<tr bgcolor="#<cfoutput>#application.sl_tbcolor#</cfoutput>">
					<td class="titlesubw" align="center">Date</td>
					<td class="titlesubw" align="center">Time</td>
					<td class="titlesubw" align="center">Home Team</td>
					<td class="titlesubw" align="center">Visitor Team</td>
					<td class="titlesubw" align="center">Score</td>
					<td class="titlesubw" align="center">Location</td>
				</tr>
				</cfif>
</cffunction>

</body>
</html>
