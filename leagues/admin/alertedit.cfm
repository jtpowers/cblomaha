<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateAlert">
	<cfquery name="UpdateAlert" datasource="#application.memberDSN#">
		Update sl_alert
		Set AlertTitle = '#u_atitle#',
			AlertInfo = '#u_ainfo#',
			StartDate = '#DateFormat(u_sdate, "yyyy-mm-dd")#',
			EndDate = '#DateFormat(u_edate, "yyyy-mm-dd")#',
			AssocID = <cfif isDefined("form.mainDisplay")>#application.aid#<cfelse>NULL</cfif>
		Where AlertID = #url.alertid#
	</cfquery>
	<cfif isDefined("form.emailAlert")>
		<cfinclude template="emailmembers.cfm">
	</cfif>
	<cfset done = 1>
<cfelseif action EQ "addAlert">
	<cfquery name="AddAlert" datasource="#application.memberDSN#">
		Insert Into sl_alert (AlertTitle, AlertInfo, StartDate, EndDate, LeagueID, AssocID)
		Values('#u_atitle#', '#u_ainfo#', '#DateFormat(u_sdate, "yyyy-mm-dd")#', '#DateFormat(u_edate, "yyyy-mm-dd")#', #url.lid#,
				<cfif isDefined("form.mainDisplay")>#application.aid#<cfelse>NULL</cfif>)
	</cfquery>
	<cfquery name="getNewAlert" datasource="#application.memberDSN#">
		SELECT max(AlertID) as newAID
		FROM sl_alert
		Where leagueid = #url.lid#
	</cfquery>
	<cfset url.alertid = getNewAlert.newAID>
	<cfif isDefined("form.emailAlert")>
		<cfinclude template="emailmembers.cfm">
	</cfif>
	<cfset done = 1>
<cfelseif action EQ "deleteAlert">
	<cfquery name="DeleteAlert" datasource="#application.memberDSN#">
		Delete From sl_alert
		where  AlertID = #url.alertid#
	</cfquery>
	<cfset done = 1>
</cfif>

<cfif ParameterExists(url.alertid) AND Not done>
	<cfquery name="GetAlert" datasource="#application.memberDSN#">
		SELECT *
		FROM sl_alert
		Where AlertID = #url.alertid#
	</cfquery>
	<cfset form.u_atitle = "#GetAlert.AlertTitle#">
	<cfset form.u_ainfo = "#GetAlert.AlertInfo#">
	<cfset form.u_sdate = "#DateFormat(GetAlert.StartDate, 'mm/dd/yyyy')#">
	<cfset form.u_edate = "#DateFormat(GetAlert.EndDate, 'mm/dd/yyyy')#">
	<cfset form.mainDisplay = "#GetAlert.AssocID#">
	<cfset form.emailAlert = "">
	<cfset form.action = "updateAlert">
<cfelse>
	<cfset form.u_atitle = "">
	<cfset form.u_ainfo = "">
	<cfset form.u_sdate = "#DateFormat(Now(), 'mm/dd/yyyy')#">
	<cfset form.u_edate = "#DateFormat(DateAdd('d', 2, Now()), 'mm/dd/yyyy')#">
	<cfset form.mainDisplay = "">
	<cfset form.emailAlert = "1">
	<cfset form.action = "addAlert">
	<cfset url.alertid = "">
</cfif>

<cfset pageTitle = "#application.sl_name# - Alert Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Alert?"))
			{
				document.forms[0].action.value = "deleteAlert";
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

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfset onloadattr = "document.forms[0].u_atitle.focus();">
</cfif>
<cfoutput>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="#onloadattr#">
</cfoutput>
<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#</cfoutput><br>
		Edit Alert
	</td>
</tr>
<tr><td align="center">
	<cfform action="alertedit.cfm?alertid=#url.alertid#&lid=#url.lid#" method="post">
	<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
	<table class="table table-condensed no-border"><tr><td valign="top" align="center">
		<table class="table table-condensed table-bordered">
			<tr><td>
			<table class="table table-condensed no-border">
				<tr><td width="25%"></td><td width="25%"></td><td width="25%"></td><td width="25%"></td></tr>
				<tr>
					<td class="smallb">*Alert Title: </td>
					<td colspan="3"><cfinput type="text" name="u_atitle" message="Must enter an Alert Title." required="yes" class="small" size="40" value="#form.u_atitle#" validateat="onBlur, onSubmit"></td>
				</tr>
				<tr>
					<td class="smallb" valign="top">Alert Info: </td>
					<td colspan="3">
						<textarea name="u_ainfo" cols="40" rows="5" class="small"><cfoutput>#form.u_ainfo#</cfoutput></textarea>
					</td>
				</tr>
				<tr>
					<td class="smallb">*Start Date: </td>
					<td colspan="3"><cfinput type="text" name="u_sdate" message="Must enter a valid Start Date. (mm/dd/yyyy)" validateat="onBlur, onSubmit" validate="date" required="yes" class="small" value="#DateFormat(form.u_sdate, "mm/dd/yyyy")#" size="12">
					</td>
				</tr>
				<tr>
					<td class="smallb">*End Date: </td>
					<td colspan="3"><cfinput type="text" name="u_edate" message="Must enter a valid End Date. (mm/dd/yyyy)" validateat="onBlur, onSubmit" validate="date" required="yes" class="small" value="#DateFormat(form.u_edate, "mm/dd/yyyy")#" size="12">
					</td>
				</tr>
				<tr>
					<td class="smallb" colspan="2" nowrap>
						Display on Main Page: 
						<input name="mainDisplay" type="checkbox" value="1"<cfif form.mainDisplay GT ""> checked</cfif>>
					</td>
					<td class="smallb" colspan="2" nowrap>
						Email Alert to Members: 
						<input name="emailAlert" type="checkbox" value="1"<cfif form.emailAlert GT ""> checked</cfif>>
					</td>
				</tr>
			</table>
			</td></tr>
		</table>
	</td></tr>
	<tr><td colspan="2" align="center">
		<cfif form.action EQ "updateAlert">
			<input type="submit" name="update" value="Update" class="small">
			<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
		<cfelse>
			<input type="submit" name="add" value="Add" class="small">
		</cfif>
		<input type="reset" class="small"><br>
		<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
	</td></tr>
	<tr> 
		<td colspan="2" class="small">* Required Field</td>
	</tr>
	</table>
	</cfform>
</td></TR>
</TABLE>
<br><br>

</body>
</html>
