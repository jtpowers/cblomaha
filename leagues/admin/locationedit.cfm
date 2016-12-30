<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="menu" default="">
<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateLocation">
	<cfquery name="UpdateLocation" datasource="#application.memberDSN#">
		Update sl_location
		Set LocationName = '#u_lname#',
			ShortName = <cfif LEN(u_sname) GT 0>'#u_sname#'<cfelse>NULL</cfif>,
			Address = <cfif LEN(u_addr) GT 0>'#u_addr#'<cfelse>NULL</cfif>,
			City = <cfif LEN(u_city) GT 0>'#u_city#'<cfelse>NULL</cfif>,
			State = <cfif LEN(u_state) GT 0>'#u_state#'<cfelse>NULL</cfif>,
			ZipCode = <cfif LEN(u_zip) GT 0>'#u_zip#'<cfelse>NULL</cfif>,
			Phone = <cfif LEN(u_phone) GT 0>'#u_phone#'<cfelse>NULL</cfif>,
			MapURL =<cfif LEN(u_mapurl) GT 0> '#u_mapurl#'<cfelse>NULL</cfif>,
			MapImage = <cfif LEN(u_mapimage) GT 0> '#u_mapimage#'<cfelse>NULL</cfif>,
			Directions = <cfif LEN(u_directions) GT 0> '#u_directions#'<cfelse>NULL</cfif>
		Where LocationID = #url.locaid#
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "addLocation">
	<!--- Insert Location --->
	<cfquery name="AddLocation" datasource="#application.memberDSN#">
		Insert Into sl_location (LocationName, ShortName, Address, City, State, ZipCode, Phone, MapURL, MapImage, Directions)
		Values('#u_lname#', 
					<cfif LEN(u_sname) GT 0>'#u_sname#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_addr) GT 0>'#u_addr#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_city) GT 0>'#u_city#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_state) GT 0>'#u_state#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_zip) GT 0>'#u_zip#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_phone) GT 0>'#u_phone#'<cfelse>NULL</cfif>,
					<cfif LEN(u_mapurl) GT 0> '#u_mapurl#'<cfelse>NULL</cfif>,
					<cfif LEN(u_mapimage) GT 0> '#u_mapimage#'<cfelse>NULL</cfif>,
					<cfif LEN(u_directions) GT 0> '#u_directions#'<cfelse>NULL</cfif>)
	</cfquery>
	<!--- Get Location ID just added --->
	<cfquery name="GetLastLocation" datasource="#application.memberDSN#">
		SELECT Max(LocationID) as LastLocaID
		FROM sl_location
	</cfquery>
	<!--- Insert League Location --->
	<cfquery name="AddleagueLocation" datasource="#application.memberDSN#">
		Insert Into sl_league_location (LeagueID, LocationID)
		Values(#url.lid#, #GetLastLocation.LastLocaID#)
	</cfquery>
	<cfquery name="AddCourt" datasource="#application.memberDSN#">
		Insert Into sl_court (CourtName, LocationID)
		Values(NULL, #GetLastLocation.LastLocaID#)
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "deleteLocation">
	<cfquery name="DeleteLeagueLoca" datasource="#application.memberDSN#">
		Delete From sl_league_location
		where  LocationID = #url.locaid#
	</cfquery>
	<cfquery name="DeleteCourt" datasource="#application.memberDSN#">
		Delete From sl_court
		where  LocationID = #url.locaid#
	</cfquery>
	<cfquery name="DeleteLocation" datasource="#application.memberDSN#">
		Delete From sl_location
		where  LocationID = #url.locaid#
	</cfquery>
	<cfset done = 1>
</cfif>
	
<cfdirectory action="list" directory="#application.leagueDir#\images\#application.aid#\#url.lid#" name="imagelist">

<cfif ParameterExists(url.locaid) AND Not done>
	<cfquery name="GetLocation" datasource="#application.memberDSN#">
		SELECT * FROM sl_location
		Where LocationID = #url.locaid#
	</cfquery>
	<!--- Check if location has any games.  If so, you can't delete --->
	<cfquery name="CheckGames" datasource="#application.memberDSN#">
		Select gameid
		From sl_game
		Where LocationID = #url.locaid#
	</cfquery>

	<cfset form.u_lname = "#GetLocation.LocationName#">
	<cfset form.u_sname = "#GetLocation.ShortName#">
	<cfset form.u_addr = "#GetLocation.Address#">
	<cfset form.u_city = "#GetLocation.City#">
	<cfset form.u_state = "#GetLocation.State#">
	<cfset form.u_zip = "#GetLocation.ZipCode#">
	<cfset form.u_phone = "#GetLocation.Phone#">
	<cfset form.u_mapurl = "#GetLocation.MapURL#">
	<cfset form.u_mapimage = "#GetLocation.MapImage#">
	<cfset form.u_directions = "#GetLocation.Directions#">
	<cfset form.action = "updateLocation">
<cfelse>
	<cfset form.u_lname = "">
	<cfset form.u_sname = "">
	<cfset form.u_addr = "">
	<cfset form.u_city = "">
	<cfset form.u_state = "">
	<cfset form.u_zip = "">
	<cfset form.u_phone = "">
	<cfset form.u_mapurl = "">
	<cfset form.u_mapimage = "">
	<cfset form.u_directions = "">
	<cfset form.action = "addLocation">
	<cfset url.locaid = "">
</cfif>

<cfset pageTitle = "Location Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Location?"))
			{
				document.forms[0].action.value = "deleteLocation";
				document.forms[0].submit();
			} 
			else
			{
			
			}
		}	
		
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.history.go(0);
			window.close();
		  }
		}
	</script>
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0"<cfif done> onload="closeRefresh();"</cfif>>
<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#</cfoutput><br>
		Edit Location
	</td>
</tr>
<tr><td align="center">
	<cfform action="locationedit.cfm?lid=#url.lid#&locaid=#url.locaid#" method="post">
	<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
	<table class="table table-condensed no-border"><tr><td valign="top" align="center">
		<table class="table table-condensed table-bordered">
			<tr><td>
			<table class="table table-condensed no-border">
				<tr>
					<td class="smallb">*Location Name: </td>
					<td class="small"><cfinput name="u_lname" type="text" value="#form.u_lname#" size="35" required="yes" message="Location Name is required." class="small"></td>
				</tr>
				<tr>
					<td class="smallb">*Short Name: </td>
					<td class="small"><cfinput name="u_sname" type="text" value="#form.u_sname#" size="25" maxlength="25" required="yes" message="Short Name is required." class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Address: </td>
					<td class="small"><input type="text" name="u_addr" size="35" value="<cfoutput>#form.u_addr#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb">City: </td>
					<td class="small"><input type="text" name="u_city" size="35" value="<cfoutput>#form.u_city#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb">State: </td>
					<td class="small"><input type="text" name="u_state" size="3" maxlength="2" value="<cfoutput>#form.u_state#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Zip Code: </td>
					<td class="small"><input type="text" name="u_zip" size="10" value="<cfoutput>#form.u_zip#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Phone: </td>
					<td class="small"><input type="text" name="u_phone" size="20" value="<cfoutput>#form.u_phone#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Map URL: </td>
					<td class="small"><input type="text" name="u_mapurl" size="35" value="<cfoutput>#form.u_mapurl#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Map Image: </td>
					<td class="small">
						<select name="u_mapimage" class="small">
							<option value=""<cfif #form.u_mapimage# EQ ""> selected</cfif>>None</option>
						<cfoutput query="imagelist">
							<option value="#imagelist.name#"<cfif #form.u_mapimage# EQ #imagelist.name#> selected</cfif>>#imagelist.name#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb" valign="top">Directions: </td>
					<td>
						<textarea name="u_directions" class="small" rows="7" cols="50"><cfoutput>#form.u_directions#</cfoutput></textarea>
					</td>
				</tr>
			</table>
			</td></tr>
		</table>
	</td></tr>
	<tr><td class="small" align="center">
		<cfif form.action EQ "updateLocation">
			<input type="submit" name="update" value="Update" class="small">
			<cfif CheckGames.RecordCount EQ 0>
				&nbsp;&nbsp;&nbsp;<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
			</cfif>
		<cfelse>
			<input type="submit" name="add" value="Add" class="small">
		</cfif>
		&nbsp;&nbsp;&nbsp;<input type="reset" class="small"><br>
		<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
	</td></tr>
	<tr> 
		<td class="small">* Required Field</td>
	</tr>
	</table>
	</cfform>
</td></TR>
</TABLE>

</body>
</html>
