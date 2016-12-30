<cfparam name="menu" default="">
<cfparam name="action" default="">

<cfif isDefined("form.update")>
	<cfquery name="updateLeague" datasource="#memberDSN#">
		Update sl_association
		Set Assocname = '#form.u_lname#',
			Description = '#u_desc#',
			Keywords = '#u_keywords#',
			AssocLogo = '#u_logo#',
			HeaderImageCenter = '#u_logo#',
			HeaderImageLeft = <cfif u_hdleft GT "">'#u_hdleft#'<cfelse>NULL</cfif>,
			HeaderImageRight = <cfif u_hdright GT "">'#u_hdright#'<cfelse>NULL</cfif>,
			HeaderColor = '#u_hcolor#',
			HeaderMenuColor = '#u_hmcolor#',
			TableHeaderColor = '#u_thcolor#',
			AltRowColor = '#u_arcolor#'
		Where AssocID = #application.aid#
	</cfquery>
</cfif>

<cfquery name="GetLeague" datasource="#memberDSN#">
	SELECT * 
	FROM sl_association
	Where AssocID = #application.aid#
</cfquery>

<cfset rootDir = "../">

<cfif isDefined("url.lid")>
	<cfdirectory action="list" directory="#leagueDir#\images\#application.aid#\#url.lid#" name="imagelist">
<cfelse>
	<cfdirectory action="list" directory="#leagueDir#\images\#application.aid#" name="imagelist">
</cfif>

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
<form action="site.cfm" method="post">
<table>
	<tr>
		<td colspan="2" class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
	</tr>
	<tr>
		<td valign="top">
			<table cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td class="smallb">Site Name: </td>
					<td><input type="text" name="u_lname" size="50" maxlength="100" value="<cfoutput>#GetLeague.assocname#</cfoutput>" class="small"></td>
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
					<td class="smallb">Logo: </td>
					<td>
						<select name="u_logo" class="small">
							<option value=""<cfif #GetLeague.assocLogo# EQ ""> selected</cfif>>None</option>
						<cfoutput query="imagelist">
							<cfif imagelist.type EQ "File">
							<option value="#imagelist.name#"<cfif #GetLeague.assocLogo# EQ #imagelist.name#> selected</cfif>>#imagelist.name#</option>
							</cfif>
						</cfoutput>
						</select>
					</td>
				</tr>
			<cfif #GetLeague.assocLogo# NEQ "">
				<tr>
				<cfoutput>
					<td colspan="2">
						<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
							<td colspan="2" bgcolor="#GetLeague.HeaderColor#"<cfif application.sl_hdbkgimage GT "">  background="#rootDir#wsimages/#application.sl_hdbkgimage#" height="#application.sl_hdbkgheight#"</cfif>>
								<img src="#rootDir#images/#application.aid#/#GetLeague.assocLogo#">
							</td>
						</tr></table>
					</td>
				</cfoutput>
				</tr>
			</cfif>
				<tr>
					<td class="smallb" valign="top">Header Left Image: </td>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
						<td valign="top">
						<select name="u_hdleft" class="small">
							<option value=""<cfif #GetLeague.HeaderImageLeft# EQ ""> selected</cfif>>None</option>
						<cfoutput query="imagelist">
							<cfif imagelist.type EQ "File">
							<option value="#imagelist.name#"<cfif #GetLeague.HeaderImageLeft# EQ #imagelist.name#> selected</cfif>>#imagelist.name#</option>
							</cfif>
						</cfoutput>
						</select>
						</td>
						<cfoutput>
						<cfif #GetLeague.HeaderImageLeft# NEQ "">
							<td bgcolor="#GetLeague.HeaderColor#"<cfif application.sl_hdbkgimage GT "">  background="#rootDir#wsimages/#application.sl_hdbkgimage#" height="#application.sl_hdbkgheight#"</cfif>>
								<img src="#rootDir#images/#application.aid#/#GetLeague.HeaderImageLeft#">
							</td>
						</cfif>
						</cfoutput>
						</tr></table>
					</td>
				</tr>
				<tr>
					<td class="smallb" valign="top">Header Right Image: </td>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
						<td valign="top">
						<select name="u_hdright" class="small">
							<option value=""<cfif #GetLeague.HeaderImageRight# EQ ""> selected</cfif>>None</option>
						<cfoutput query="imagelist">
							<cfif imagelist.type EQ "File">
							<option value="#imagelist.name#"<cfif #GetLeague.HeaderImageRight# EQ #imagelist.name#> selected</cfif>>#imagelist.name#</option>
							</cfif>
						</cfoutput>
						</select>
						</td>
						<cfoutput>
						<cfif #GetLeague.HeaderImageRight# NEQ "">
							<td align="right" bgcolor="#GetLeague.HeaderColor#"<cfif application.sl_hdbkgimage GT "">  background="#rootDir#wsimages/#application.sl_hdbkgimage#" height="#application.sl_hdbkgheight#"</cfif>>
								<img src="#rootDir#images/#application.aid#/#GetLeague.HeaderImageRight#">
							</td>
						</cfif>
						</cfoutput>
						</tr></table>
					</td>
				</tr>
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
