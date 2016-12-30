<cfparam name="form.lid" default="0">
<cfparam name="action" default="">
<cfset done = 0>

<cfif isDefined("url.approve")>
	<cfquery name="InsertEventApproval" datasource="#memberDSN#">
		Insert Into sl_event_league_approval (eventid, siteid, approval_date)
		Values (#url.evid#, #url.siteid#, '#DateFormat(now(), "yyyy-mm-dd")#')
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "updateEvent">
	<cfquery name="checkEvent" datasource="#memberDSN#">
		SELECT LeagueID
		FROM sl_event
		Where EventID = #url.evid#
	</cfquery>
	<cfif LEN(form.filename) GT 0>
		<cffile action="upload"
				destination="#leagueDir#\files\evfiles"
				filefield="filename" 
				nameconflict="overwrite">
		<cfset form.evflyer = "#File.ServerFile#">
	</cfif>

	<cfquery name="UpdateEvent" datasource="#memberDSN#">
		Update sl_event
		Set EventName = '#form.evname#',
			 EventType = '#form.evtype#',
			 Location = <cfif LEN(form.evloca) GT 0>'#form.evloca#'<cfelse>NULL</cfif>,
			 EventAddress = <cfif LEN(form.evaddr) GT 0>'#form.evaddr#'<cfelse>NULL</cfif>,
			 EventState = <cfif LEN(form.evstate) GT 0>'#form.evstate#'<cfelse>NULL</cfif>,
			 EventCity = <cfif LEN(form.evcity) GT 0>'#form.evcity#'<cfelse>NULL</cfif>,
			 EventZipCode = <cfif LEN(form.evzip) GT 0>'#form.evzip#'<cfelse>NULL</cfif>,
			 EventWebsite = <cfif LEN(form.evwebsite) GT 0>'#form.evwebsite#'<cfelse>NULL</cfif>,
			 EventDesc = <cfif LEN(form.evdesc) GT 0>'#form.evdesc#'<cfelse>NULL</cfif>,
			 Sport = '#form.evsport#',
			 FromDate = <cfif LEN(form.evfromdate) GT 0>'#DateFormat(form.evfromdate, "YYYY-MM-DD")#'<cfelse>NULL</cfif>,
			 ToDate = <cfif LEN(form.evtodate) GT 0>'#DateFormat(form.evtodate, "YYYY-MM-DD")#'<cfelse>NULL</cfif>,
			 Deadline = <cfif LEN(form.evdeadline) GT 0>'#DateFormat(form.evdeadline, "YYYY-MM-DD")#'<cfelse>NULL</cfif>,
			 GradesAges = <cfif LEN(form.evgrades) GT 0>'#form.evgrades#'<cfelse>NULL</cfif>,
			 Cost = <cfif LEN(form.evcost) GT 0>'#form.evcost#'<cfelse>NULL</cfif>,
			 ContactName = <cfif LEN(form.evctname) GT 0>'#form.evctname#'<cfelse>NULL</cfif>,
			 ContactPhone = <cfif LEN(form.evctphone) GT 0>'#form.evctphone#'<cfelse>NULL</cfif>,
			 ContactEmail = <cfif LEN(form.evctemail) GT 0>'#form.evctemail#'<cfelse>NULL</cfif>,
			 EventFlyer = <cfif LEN(form.evflyer) GT 0>'#form.evflyer#'<cfelse>NULL</cfif>,
			 EventGender = <cfif LEN(form.evgender) GT 0>'#form.evgender#'<cfelse>NULL</cfif>
		Where EventID = #url.evid#
	</cfquery>
	
	<cfif isDefined("form.evapproved") AND form.evapproved EQ "">
		<cfquery name="InsertEventApproval" datasource="#memberDSN#">
			Insert Into sl_event_league_approval (eventid, siteid, approval_date)
			Values (#url.evid#, #url.siteid#, '#DateFormat(now(), "yyyy-mm-dd")#')
		</cfquery>
	<cfelseif Not isDefined("form.evapproved")>
		<cfquery name="DeleteEventApproval" datasource="#memberDSN#">
			Delete From sl_event_league_approval
			where  EventID = #url.evid# and siteid = #url.siteid#
		</cfquery>
	</cfif>
	<cfset done = 1>
<cfelseif action EQ "addEvent">
	<cfif LEN(form.filename) GT 0>
		<cffile action="upload"
				destination="#leagueDir#\files\evfiles"
				filefield="filename" 
				nameconflict="overwrite">
		<cfset form.evflyer = "#File.ServerFile#">
	</cfif>

	<cfquery name="AddNews" datasource="#memberDSN#">
		Insert Into sl_event (EventName, EventType, Location, EventAddress, EventState, EventCity, EventZipCode, EventWebsite,
			 EventDesc, Sport, FromDate, ToDate, Deadline, GradesAges, Cost, LeagueID, ContactName, ContactPhone, 
			 ContactEmail, EventFlyer, EventGender, createdate)
		Values('#form.evname#',
			'#form.evtype#',
			<cfif LEN(form.evloca) GT 0>'#form.evloca#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evaddr) GT 0>'#form.evaddr#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evstate) GT 0>'#form.evstate#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evcity) GT 0>'#form.evcity#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evzip) GT 0>'#form.evzip#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evwebsite) GT 0>'#form.evwebsite#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evdesc) GT 0>'#form.evdesc#'<cfelse>NULL</cfif>,
			'#form.evsport#',
			<cfif LEN(form.evfromdate) GT 0>'#DateFormat(form.evfromdate, "YYYY-MM-DD")#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evtodate) GT 0>'#DateFormat(form.evtodate, "YYYY-MM-DD")#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evdeadline) GT 0>'#DateFormat(form.evdeadline, "YYYY-MM-DD")#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evgrades) GT 0>'#form.evgrades#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evcost) GT 0>'#form.evcost#'<cfelse>NULL</cfif>,
			NULL,
			<cfif LEN(form.evctname) GT 0>'#form.evctname#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evctphone) GT 0>'#form.evctphone#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evctemail) GT 0>'#form.evctemail#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evflyer) GT 0>'#form.evflyer#'<cfelse>NULL</cfif>,
			<cfif LEN(form.evgender) GT 0>'#form.evgender#'<cfelse>NULL</cfif>,
			'#DateFormat(Now(), "YYYY-MM-DD")#')
	</cfquery>
	<cfquery name="GetLastEvent" datasource="#memberDSN#">
		SELECT Max(EventID) as lastevid
		FROM sl_event
	</cfquery>
	<cfset url.evid = GetLastEvent.lastevid>

	<cfif isDefined("form.evapproved")>
		<cfquery name="InsertEventApproval" datasource="#memberDSN#">
			Insert Into sl_event_league_approval (eventid, siteid, approval_date)
			Values (#url.evid#, #url.siteid#, '#DateFormat(now(), "yyyy-mm-dd")#')
		</cfquery>
	</cfif>
	
	<cfset done = 1>
<cfelseif action EQ "deleteEvent">
	<cfquery name="DeleteEventApproval" datasource="#memberDSN#">
		Delete From sl_event_league_approval
		where  EventID = #url.evid# and SiteID = #url.siteid#
	</cfquery>
	
	<cfquery name="DeleteEVent" datasource="#memberDSN#">
		Delete From sl_event
		where  EventID = #url.evid#
	</cfquery>
	
	<cfset done = 1>
</cfif>
<cfif done>
	<cflocation url="sportevent.cfm">
</cfif>
	
<cfquery name="getTypes" datasource="#memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'EventType'
	Order by Value_4
</cfquery>

<cfquery name="getGenders" datasource="#memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'EventGender'
	Order by Value_4
</cfquery>

<cfquery name="getSports" datasource="#memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'EventSport'
	Order by Value_4
</cfquery>

<cfquery name="getSiteInfo" datasource="#memberDSN#">
	Select *
	From p1_website
	Where SiteID = #url.siteid#
</cfquery>

<cfdirectory action="list" directory="#leagueDir#\files\evfiles" name="filelist">

<cfset rootDir = "../">

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfset onloadattr = "document.forms[0].evname.focus();">
</cfif>
<cfset pageTitle = "Youth Sports Events">
<cfinclude template="#rootdir#ssi/header.cfm">
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Events?"))
			{
				document.forms[0].action.value = "deleteEvent";
				document.forms[0].submit();
			} 
			else
			{
			
			}
		}	
		
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
		  	location.href='sportevent.cfm?siteid=<cfoutput>#url.siteid#</cfoutput>';
		  }
		}
	</script>
<div class="panel panel-primary">
	<div class="panel-heading">
		<div class="panel-title text-center">
			<span class="titlemain"><cfoutput>#pageTitle#</cfoutput></span><br>
        	<span class="titlesub">Edit Sports Event</span>
        </div>
	</div>
    <div class="panel-body">
<cfif NOT done>
<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#getSiteInfo.sitename#</cfoutput><br>
		Edit Sports Event
	</td>
</tr>
<tr><td align="center">
	<table><tr><td valign="top" align="center">
		<cfif ParameterExists(url.evid) AND action NEQ "deleteEvent">
			<cfquery name="GetEvent" datasource="#memberDSN#">
				SELECT e.*, ela.approval_date
				FROM sl_event e Left Join sl_event_league_approval ela On ela.eventid = e.eventid And ela.siteid = #url.siteid#
				Where e.EventID = #url.evid#
			</cfquery>
			<cfset form.evname = "#GetEvent.EventName#">
			<cfset form.evtype = "#GetEvent.EventType#">
			<cfset form.evloca = "#GetEvent.Location#">
			<cfset form.evaddr = "#GetEvent.EventAddress#">
			<cfset form.evstate = "#GetEvent.EventState#">
			<cfset form.evcity = "#GetEvent.EventCity#">
			<cfset form.evzip = "#GetEvent.EventZipCode#">
			<cfset form.evwebsite = "#GetEvent.EventWebsite#">
			<cfset form.evdesc = "#GetEvent.EventDesc#">
			<cfset form.evsport = "#GetEvent.Sport#">
			<cfset form.evfromdate = "#DateFormat(GetEvent.FromDate, 'mm/dd/yyyy')#">
			<cfset form.evtodate = "#DateFormat(GetEvent.ToDate, 'mm/dd/yyyy')#">
			<cfset form.evdeadline = "#DateFormat(GetEvent.Deadline, 'mm/dd/yyyy')#">
			<cfset form.evgrades = "#GetEvent.GradesAges#">
			<cfset form.evcost = "#GetEvent.Cost#">
			<cfset form.evctname = "#GetEvent.ContactName#">
			<cfset form.evctphone = "#GetEvent.ContactPhone#">
			<cfset form.evctemail = "#GetEvent.ContactEmail#">
			<cfset form.evflyer = "#GetEvent.EventFlyer#">
			<cfset form.evgender = "#GetEvent.EventGender#">
			<cfset form.evapprdate = "#GetEvent.approval_date#">
			<cfset form.action = "updateEvent">
		<cfelse>
			<cfset url.evid = "">
			<cfset form.evname = "">
			<cfset form.evtype = "Tournament">
			<cfset form.evloca = "">
			<cfset form.evaddr = "">
			<cfset form.evstate = "">
			<cfset form.evcity = "">
			<cfset form.evzip = "">
			<cfset form.evwebsite = "">
			<cfset form.evdesc = "">
			<cfset form.evsport = "Basketball">
			<cfset form.evfromdate = "">
			<cfset form.evtodate = "">
			<cfset form.evdeadline = "">
			<cfset form.evgrades = "">
			<cfset form.evcost = "">
			<cfset form.evctname = "">
			<cfset form.evctphone = "">
			<cfset form.evctemail = "">
			<cfset form.evflyer = "">
			<cfset form.evgender = "Boys & Girls">
			<cfset form.evapprdate = "#DateFormat(now(), "yyyy-mm-dd")#">
			<cfset form.action = "addEvent">
		</cfif>
		<form action="sporteventedit.cfm?evid=<cfoutput>#url.evid#&siteid=#url.siteid#</cfoutput>" method="post" enctype="multipart/form-data">
		<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
		<table border="1" cellspacing="0" cellpadding="3">
			<tr><td>
			<table cellpadding="2" cellspacing="0">
				<tr>
					<td class="smallb">Event Name: </td>
					<td colspan="3"><input type="text" name="evname" value="<cfoutput>#form.evname#</cfoutput>" class="small" size="50"></td>
				</tr>
				<tr>
					<td class="smallb">Event Type: </td>
					<td>
						<select name="evtype" class="small">
						<cfoutput query="getTypes">
							<option value="#Value_1#"<cfif Value_1 EQ form.evtype> SELECTED</cfif>>#Value_3#</option>
						</cfoutput>
						</select>
					</td>
					<td class="smallb" colspan="2">Gender:
						<select name="evgender" class="small">
						<cfoutput query="getGenders">
							<option value="#Value_1#"<cfif Value_1 EQ form.evgender> SELECTED</cfif>>#Value_3#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">Event Sport: </td>
					<td colspan="3" class="smallb">
						<select name="evsport" class="small">
						<cfoutput query="getSports">
							<option value="#Value_1#"<cfif Value_1 EQ form.evsport> SELECTED</cfif>>#Value_3#</option>
						</cfoutput>
						</select>
						Cost:
						<input type="text" name="evcost" value="<cfoutput>#form.evcost#</cfoutput>" class="small" size="10">
						Grades or Ages:
						<input type="text" name="evgrades" value="<cfoutput>#form.evgrades#</cfoutput>" class="small" size="20">
					</td>
				</tr>
				<tr>
					<td class="smallb">Event Dates: </td>
					<td class="smallb" colspan="3">
						From:
						<input type="text" name="evfromdate" value="<cfoutput>#form.evfromdate#</cfoutput>" class="small" size="10">
						To:
						<input type="text" name="evtodate" value="<cfoutput>#form.evtodate#</cfoutput>" class="small" size="10">
						Deadline:
						<input type="text" name="evdeadline" value="<cfoutput>#form.evdeadline#</cfoutput>" class="small" size="10">
					</td>
				</tr>
				<tr>
					<td class="smallb">Contact Name: </td>
					<td class="smallb" colspan="3">
						<input type="text" name="evctname" value="<cfoutput>#form.evctname#</cfoutput>" class="small" size="20">
						Phone:
						<input type="text" name="evctphone" value="<cfoutput>#form.evctphone#</cfoutput>" class="small" size="12">
						Email:
						<input type="text" name="evctemail" value="<cfoutput>#form.evctemail#</cfoutput>" class="small" size="25">
					</td>
				</tr>
				<tr>
					<td class="smallb">Event Website: </td>
					<td colspan="3"><input type="text" name="evwebsite" value="<cfoutput>#form.evwebsite#</cfoutput>" class="small" size="50"></td>
				</tr>
				<tr>
					<td class="smallb">Location: </td>
					<td colspan="3"><input type="text" name="evloca" value="<cfoutput>#form.evloca#</cfoutput>" class="small" size="50"></td>
				</tr>
				<tr>
					<td class="smallb">Event Address: </td>
					<td colspan="3"><input type="text" name="evaddr" value="<cfoutput>#form.evaddr#</cfoutput>" class="small" size="50"></td>
				</tr>
				<tr>
					<td class="smallb">Event City: </td>
					<td colspan="3" class="smallb">
						<input type="text" name="evcity" value="<cfoutput>#form.evcity#</cfoutput>" class="small">
						State:
						<input type="text" name="evstate" maxlength="2" size="3" value="<cfoutput>#form.evstate#</cfoutput>" class="small">
						Zip Code:
						<input type="text" name="evzip" maxlength="10" size="10" value="<cfoutput>#form.evzip#</cfoutput>" class="small">
					</td>
				</tr>
				<tr>
					<td class="smallb" valign="top">Event Flyer: </td>
					<td colspan="3">
						<select name="evflyer" class="small">
							<option value=""<cfif #form.evflyer# EQ ""> selected</cfif>>None</option>
						<cfoutput query="filelist">
							<option value="#filelist.name#"<cfif #form.evflyer# EQ #filelist.name#> selected</cfif>>#filelist.name#</option>
						</cfoutput>
						</select>
						or Upload New File<br>
						<input name="filename" type="file" class="small" size="60">
					</td>
				</tr>
				<tr>
					<td class="smallb" colspan="4">Event Description:</td>
				<tr>
					<td colspan="4">
						<textarea class="small" name="evdesc" cols="90" rows="10"><cfoutput>#form.evdesc#</cfoutput></textarea>
					</td>
				</tr>
				<tr>
					<td class="smallb" colspan="4" align="center">
						<cfoutput>
						Approve Event for #getSiteInfo.sitename#
						<input name="evapproved" type="checkbox" value="#form.evapprdate#"<cfif #form.evapprdate# GT ""> checked</cfif>>
						</cfoutput>
					</td>
				</tr>
				<tr><td colspan="4" align="center">
						<input type="submit" name="update" value="Update" class="small">
						<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
						<input type="reset" class="small">
				</td></tr>
			</table>
			</td></tr>
		</table>
		</form>
		<a href="javascript:history.go(-1);" class="link">Return to Events</a>&nbsp;&nbsp;&nbsp;
		<a href="javascript:window.close();" class="link">Close Window</a>
	</td></tr></table>
</td></TR>
</TABLE>
</cfif>
<br><br>
	</div>
</div>
<cfinclude template="#rootdir#ssi/footer.cfm">
