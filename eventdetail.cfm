<cfset rootdir = "/">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfquery name="GetEvent" datasource="#application.memberDSN#">
	Select e.*, l.leagueurl
	From sl_event e LEFT JOIN sl_league l on l.leagueid = e.leagueid
	Where EventID = #url.evid#
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
<cfset form.evlid = "#GetEvent.LeagueID#">
<cfset form.evctname = "#GetEvent.ContactName#">
<cfset form.evctphone = "#GetEvent.ContactPhone#">
<cfset form.evctemail = "#GetEvent.ContactEmail#">
<cfset form.evflyer = "#GetEvent.EventFlyer#">
<cfset form.evgender = "#GetEvent.EventGender#">

<cfset pageTitle = "Youth Sports Event Details">
<cfinclude template="#rootdir#ssi/header.cfm">

<div class="panel panel-primary">
	<div class="panel-heading">
		<div class="panel-title text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
	</div>
    <div class="panel-body">
<table class="table table-condensed no-border">
<tr><td align="center">
	<table class="table table-condensed no-border"><tr><td valign="top" align="center">
		<table class="table table-condensed table-bordered">
			<tr><td>
			<table class="table table-condensed no-border">
				<tr>
					<td class="titlesub">Event Name: </td>
					<td colspan="3" class="medium"><cfoutput>#form.evname#</cfoutput></td>
				</tr>
				<tr>
					<td class="titlesub">Event Type: </td>
					<td class="medium"><cfoutput>#form.evtype#</cfoutput></td>
					<td class="titlesub">Event Sport:</td>
					<td class="medium"><cfoutput>#form.evsport#</cfoutput></td>
				</tr>
				<tr>
					<td class="titlesub">Cost:</td>
					<td colspan="3" class="medium">
						<cfoutput>#form.evcost#</cfoutput>
					</td>
				</tr>
				<tr>
					<td class="titlesub">Gender:</td>
					<td class="medium"><cfoutput>#form.evgender#</cfoutput></td>
					<td class="titlesub">Grades or Ages:</td>	
					<td class="medium"><cfoutput>#form.evgrades#</cfoutput></td>
				</tr>
				<tr>
					<td class="titlesub">Event Dates: </td>
					<td colspan="3" class="medium">
						<cfoutput>#form.evfromdate#</cfoutput>
					<cfif LEN(form.evtodate) GT 0>
						- <cfoutput>#form.evtodate#</cfoutput>
					</cfif>
					</td>
				</tr>
				<tr>
					<td class="titlesub">Deadline: </td>
					<td colspan="3" class="medium">
						<cfoutput>#form.evdeadline#</cfoutput>
					</td>
				</tr>
				<tr>
					<td class="titlesub">Contact Name: </td>
					<td colspan="3" class="medium">
						<cfoutput>#form.evctname#</cfoutput>
					</td>
				</tr>
				<tr>
					<td class="titlesub">Contact Phone: </td>
					<td class="medium"><cfoutput>#form.evctphone#</cfoutput>
					<td class="titlesub">Email: </td>
					<td class="medium">
						<cfif LEN(form.evctemail) GT 0>
							<cfoutput><a href="mailto:#form.evctemail#">#form.evctemail#</a></cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="titlesub">Event Website: </td>
					<td colspan="3" class="medium">
					<cfif LEN(form.evwebsite) GT 0>
						<cfif LEFT(form.evwebsite , 4) EQ "http">
							<cfset wsURL = "#form.evwebsite#">
						<cfelse>
							<cfset wsURL = "http://#form.evwebsite#">
						</cfif>
						<cfoutput><a href="#wsURL#" target="_blank">#wsURL#</a></cfoutput>
					</cfif>
				</tr>
				<tr>
					<td class="titlesub">Location: </td>
					<td colspan="3" class="medium"><cfoutput>#form.evloca#</cfoutput></td>
				</tr>
				<tr>
					<td class="titlesub">Event Address: </td>
					<td colspan="3" class="medium"><cfoutput>#form.evaddr#</cfoutput></td>
				</tr>
				<tr>
					<td class="titlesub">Event City: </td>
					<td class="medium"><cfoutput>#form.evcity#</cfoutput></td>
					<td colspan="2" class="medium">
						<span class="titlesub">State:</span>
						<cfoutput>#form.evstate#</cfoutput>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="titlesub">Zip Code:</span>
						<cfoutput>#form.evzip#</cfoutput>
					</td>
				</tr>
				<tr>
					<td class="titlesub" valign="top">Event Flyer: </td>
					<td colspan="3" class="medium">
						<cfif LEN(form.evflyer) GT 0>
							<cfoutput><a href="files/evfiles/#form.evflyer#" target="_blank">#form.evflyer#</a></cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="titlesub" colspan="4">Event Description:</td>
				<tr>
					<td colspan="4" class="medium">
						<textarea name="evdesc" cols="90" rows="15" class="small" readonly><cfoutput>#form.evdesc#</cfoutput></textarea>
					</td>
				</tr>
			</table>
			</td></tr>
		</table>
		<a href="javascript:window.close();" class="link">Close Window</a>
	</td></tr></table>
</td></TR>
</TABLE>
    </div>
</div>
<cfinclude template="#rootdir#ssi/footer.cfm">
