<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateMessage">
	<cfquery name="UpdateMessage" datasource="#application.memberDSN#">
		Update sl_messageboard
		Set Title = '#u_title#',
			Message = '#body#',
			ExpirationDate = <cfif u_edate GT "">'#DateFormat(u_edate, "yyyy-mm-dd")#'<cfelse>NULL</cfif>,
			LeagueID = #url.lid#
		Where MessageID = #url.msgid#
	</cfquery>
	<cfif isDefined("form.emailMsg")>
		<cfset sendTxt = 0>
		<cfinclude template="emailmembers.cfm">
	</cfif>
	<cfset done = 1>
<cfelseif action EQ "addMessage">
	<cfquery name="AddMessage" datasource="#application.memberDSN#">
		Insert Into sl_messageboard (Title, Message, PostedDate, ExpirationDate, LeagueID)
		Values('#u_title#', '#body#', '#DateFormat(Now(), "yyyy-mm-dd")#', 
		<cfif u_edate GT "">'#DateFormat(u_edate, "yyyy-mm-dd")#'<cfelse>NULL</cfif>, #url.lid#)
	</cfquery>
	<cfquery name="getNewMsg" datasource="#application.memberDSN#">
		SELECT max(MessageID) as newMID
		FROM sl_messageboard
		Where leagueid = #url.lid#
	</cfquery>
	<cfset url.msgid = getNewMsg.newMID>
	<cfif isDefined("form.emailMsg")>
		<cfset sendTxt = 0>
		<cfinclude template="emailmembers.cfm">
	</cfif>
	<cfset done = 1>
<cfelseif action EQ "deleteMessage">
	<cfquery name="DeleteMessage" datasource="#application.memberDSN#">
		Delete From sl_messageboard
		where  MessageID = #url.msgid#
	</cfquery>
	<cfset done = 1>
</cfif>

<cfif ParameterExists(url.msgid) AND Not done>
	<cfquery name="GetMessage" datasource="#application.memberDSN#">
		SELECT *
		FROM sl_messageboard
		Where MessageID = #url.msgid#
	</cfquery>
	<cfset form.u_title = "#GetMessage.Title#">
	<cfset form.u_msg = "#GetMessage.Message#">
	<cfset form.u_edate = "#DateFormat(GetMessage.ExpirationDate, 'mm/dd/yyyy')#">
	<cfset url.msgid = "#GetMessage.MessageID#">
	<cfset form.emailMsg = "">
	<cfset form.action = "updateMessage">
<cfelse>
	<cfset form.u_title = "">
	<cfset form.u_msg = "">
	<cfset form.u_edate = "">
	<cfset form.emailMsg = "1">
	<cfset form.action = "addMessage">
	<cfset url.msgid = "">
</cfif>

<cfset pageTitle = "Message Board Edit">
<cfinclude template="#rootdir#ssi/header.cfm">
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Message?"))
			{
				document.forms[0].action.value = "deleteMessage";
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

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfset onloadattr = "document.forms[0].u_title.focus();">
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<table class="table table-condensed no-border">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#</cfoutput><br>
		Edit Message Board
	</td>
</tr>
<tr><td align="center">
	<cfform action="msgboardedit.cfm?msgid=#url.msgid#&lid=#url.lid#" method="post">
	<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
	<table class="table table-condensed no-border"><tr><td valign="top" align="center">
		<table class="table table-condensed table-bordered">
			<tr><td>
			<table class="table table-condensed no-border">
				<tr>
					<td class="smallb">*Message Title: </td>
					<td><cfinput type="text" name="u_title" message="Must enter an Message Title." required="yes" class="small" size="40" value="#form.u_title#" validateat="onBlur, onSubmit"></td>
				</tr>
				<tr>
					<td class="smallb" valign="top" colspan="2">*Message: </td>
				</tr>
				<tr>
					<td colspan="2">
					<cfset prBody = "#form.u_msg#">
					<cfinclude template="#rootdir#ssi/editor2sm.cfm">
					</td>
				</tr>
				<tr>
					<td class="smallb">Expiration Date: </td>
					<td><cfinput type="text" name="u_edate" message="Must enter a valid End Date. (mm/dd/yyyy)" validateat="onBlur, onSubmit" validate="date" required="no" class="small" value="#DateFormat(form.u_edate, "mm/dd/yyyy")#" size="12">
					</td>
				</tr>
				<tr>
					<td class="smallb" nowrap>Email to Members:</td>
					<td class="smallb">
						<input name="emailMsg" type="checkbox" value="1"<cfif form.emailMsg GT ""> checked</cfif>>
						(Does not send text messages)
					</td>
				</tr>
			</table>
			</td></tr>
		</table>
	</td></tr>
	<tr><td colspan="2" align="center">
		<cfif form.action EQ "updateMessage">
			<input type="submit" name="update" value="Update" class="small">
			&nbsp;&nbsp;&nbsp;<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
		<cfelse>
			<input type="submit" name="add" value="Add" class="small">
		</cfif>
		&nbsp;&nbsp;&nbsp;<input type="reset" class="small"><br>
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
