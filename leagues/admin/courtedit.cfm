<cfset rootDir = "../../">
<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateCourt">
	<cfquery name="UpdateCourt" datasource="#application.memberDSN#">
		Update sl_court
		Set CourtName = '#u_cname#',
			LocationID = #u_locaid#
		Where CourtID = #url.cid#
	</cfquery>
	<cfset url.locaid = form.u_locaid>
	<cfset done = 1>
<cfelseif action EQ "addCourt">
	<cfquery name="AddCourt" datasource="#application.memberDSN#">
		Insert Into sl_court (CourtName, LocationID)
		Values('#u_cname#', #u_locaid#)
	</cfquery>
	<cfset url.locaid = form.u_locaid>
	<cfset done = 1>
<cfelseif action EQ "deleteCourt">
	<cfquery name="DeleteCourt" datasource="#application.memberDSN#">
		Delete From sl_court
		where  CourtID = #url.cid#
	</cfquery>
	<cfset url.locaid = "">
	<cfset done = 1>
</cfif>
	
<cfquery name="getLocations" datasource="#application.memberDSN#">
	Select l.locationid, l.locationname
	From sl_location l, sl_league_location ll
	Where ll.leagueid = #url.lid# and
			l.locationid = ll.locationid
	Order by LocationName
</cfquery>

<cfif ParameterExists(url.cid) AND Not done>
	<cfquery name="GetCourt" datasource="#application.memberDSN#">
		SELECT *
		FROM sl_court
		Where CourtID = #url.cid#
	</cfquery>
	<!--- Check if court has any games.  If so, you can't delete --->
	<cfquery name="CheckGames" datasource="#application.memberDSN#">
		Select gameid
		From sl_game
		Where CourtID = #url.cid#
	</cfquery>
	<cfset form.u_cname = "#GetCourt.CourtName#">
	<cfset form.u_locaid = "#GetCourt.LocationID#">
	<cfset form.action = "updateCourt">
<cfelse>
	<cfset form.u_cname = "">
	<cfset form.u_locaid = "#url.locaid#">
	<cfset form.action = "addCourt">
	<cfset url.cid = "">
</cfif>

<cfset pageTitle = "Court Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Court?"))
			{
				document.forms[0].action.value = "deleteCourt";
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
		<cfoutput>#application.sl_name#<br>
		#application.sl_leaguename#</cfoutput><br>
		Edit Court
	</td>
</tr>
<tr><td align="center">
	<cfform action="courtedit.cfm?lid=#url.lid#&cid=#url.cid#" method="post">
	<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
	<table class="table table-condensed no-border"><tr><td valign="top" align="center">
		<table class="table table-condensed table-bordered">
			<tr><td>
			<table class="table table-condensed no-border">
				<tr>
					<td class="smallb">*Court Name: </td>
					<td><cfinput name="u_cname" type="text" value="#form.u_cname#" required="yes" message="Field Name is required." class="small"></td>
				</tr>
				<tr>
					<td class="smallb">*Location: </td>
					<td>
						<select name="u_locaid" class="small">
						<cfoutput query="getLocations">
							<option value="#LocationID#"<cfif LocationID EQ form.u_locaid> selected</cfif>>#LocationName#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
			</table>
			</td></tr>
		</table>
	</td></tr>
	<tr><td align="center">
		<cfif form.action EQ "updateCourt">
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
