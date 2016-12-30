<cfparam name="menu" default="">
<cfparam name="action" default="">

<cfif isDefined("form.update")>
	<cfquery name="updateLeague" datasource="#memberDSN#">
		Update sl_league
		Set leaguename = '#form.u_lname#',
			Description = '#u_desc#',
			Keywords = '#u_keywords#',
			LeagueLogo = '#u_logo#',
			HeaderColor = '#u_hcolor#',
			HeaderMenuColor = '#u_hmcolor#',
			TableHeaderColor = '#u_thcolor#',
			AltRowColor = '#u_arcolor#',
			InterDivPlay = #u_divplay#
		Where LeagueID = #url.lid#
	</cfquery>
</cfif>

<cfquery name="GetLeague" datasource="#memberDSN#">
	SELECT * 
	FROM sl_league
	Where LeagueID = #url.lid#
</cfquery>

<cfset rootDir = "../">

<cfdirectory action="list" directory="#leagueDir#images" name="imagelist">

<cfset pageTitle = "#application.sl_name# - League Settings">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#pageTitle#</cfoutput></title>
<cfinclude template="../ssi/webscript.htm">
<script src="302pop.js" type="text/javascript"></script>
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="../ssi/header.htm">
<cfinclude template="sl_header.cfm">
<form action="league.cfm?lid=#url.lid#" method="post">
<table>
	<tr>
		<td colspan="2" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td valign="top">
			<table cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td class="smallb">League Name: </td>
					<td><input type="text" name="u_lname" size="50" maxlength="100" value="<cfoutput>#GetLeague.leaguename#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb" valign="top">Description: </td>
					<td><input type="text" name="u_desc" size="50" maxlength="100" value="<cfoutput>#GetLeague.Description#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb" valign="top">Keywords: </td>
					<td><input type="text" name="u_keywords" size="50" maxlength="255" value="<cfoutput>#GetLeague.Keywords#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb" valign="top">Inter-Division Play: </td>
					<td>
						<select name="u_divplay" class="small">
							<option value="0"<cfif #GetLeague.InterDivPlay# EQ "0"> selected</cfif>>No</option>
							<option value="1"<cfif #GetLeague.InterDivPlay# EQ "1"> selected</cfif>>Yes</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">Logo: </td>
					<td>
						<select name="u_logo" class="small">
							<option value=""<cfif #GetLeague.LeagueLogo# EQ ""> selected</cfif>>None</option>
						<cfoutput query="imagelist">
							<option value="#imagelist.name#"<cfif #GetLeague.LeagueLogo# EQ #imagelist.name#> selected</cfif>>#imagelist.name#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
			<cfif #GetLeague.LeagueLogo# NEQ "">
				<tr>
					<td class="smallb">&nbsp;</td>
					<td bgcolor="<cfoutput>#GetLeague.HeaderColor#</cfoutput>">
						<cfoutput><img src="#rootDir#images/#GetLeague.LeagueLogo#"></cfoutput>
					</td>
				</tr>
			</cfif>
				<tr>
					<td class="smallb">Header Color: </td>
					<td>
						<table border="1" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<input type="text" name="u_hcolor" size="9" maxlength="7" value="<cfoutput>#GetLeague.HeaderColor#</cfoutput>" class="small" ID="hcolor">&nbsp;
								<input type="text" ID="hcolor_sample" size="1" value="" class="small" readonly style="background-color:<cfoutput>#GetLeague.HeaderColor#</cfoutput>">
								<input type="button" onclick="pickerPopup302('hcolor','hcolor_sample');" value="Pick Color" class="small">
							</td>
						</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="smallb">Header Menu Color: </td>
					<td>
						<table border="1" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<input type="text" name="u_hmcolor" size="9" maxlength="7" value="<cfoutput>#GetLeague.HeaderMenuColor#</cfoutput>" class="small" ID="hmcolor">&nbsp;
								<input type="text" ID="hmcolor_sample" size="1" value="" class="small" readonly style="background-color:<cfoutput>#GetLeague.HeaderMenuColor#</cfoutput>">
								<input type="button" onclick="pickerPopup302('hmcolor','hmcolor_sample');" value="Pick Color" class="small">
							</td>
						</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="smallb">Table Header Color: </td>
					<td>
						<table border="1" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<input type="text" name="u_thcolor" size="9" maxlength="7" value="<cfoutput>#GetLeague.TableHeaderColor#</cfoutput>" class="small" ID="thcolor">&nbsp;
								<input type="text" ID="thcolor_sample" size="1" value="" class="small" readonly style="background-color:<cfoutput>#GetLeague.TableHeaderColor#</cfoutput>">
								<input type="button" onclick="pickerPopup302('thcolor','thcolor_sample');" value="Pick Color" class="small">
							</td>
						</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="smallb">Alt. Table Row Color: </td>
					<td>
						<table border="1" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<input type="text" name="u_arcolor" size="9" maxlength="7" value="<cfoutput>#GetLeague.AltRowColor#</cfoutput>" class="small" ID="arcolor">&nbsp;
								<input type="text" ID="arcolor_sample" size="1" value="" class="small" readonly style="background-color:<cfoutput>#GetLeague.AltRowColor#</cfoutput>">
								<input type="button" onclick="pickerPopup302('arcolor','arcolor_sample');" value="Pick Color" class="small">
							</td>
						</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="small">
					<div align="center">
						<input type="submit" name="update" value="Update" class="small">
						<input type="reset" class="small">
					</div>
				</td></tr>
			</table>
		</td>
	</tr>
</table>
</form>
</td></TR>
</TABLE>
<br><br>

</body>
</html>
