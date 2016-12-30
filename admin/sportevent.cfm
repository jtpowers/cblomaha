<cfset rootdir = "../">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfif isDefined("url.approve")>
	<cfquery name="InsertEventApproval" datasource="#memberDSN#">
		Insert Into sl_event_league_approval (eventid, siteid, approval_date)
		Values (#url.evid#, #url.siteid#, '#DateFormat(now(), "yyyy-mm-dd")#')
	</cfquery>
	<cfset done = 1>
</cfif>

<cfquery name="getTypes" datasource="#memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'EventType'
	Order by Value_4
</cfquery>
<cfparam name="form.evtype" default="">
<cfparam name="form.evdate" default="Future">
<cfparam name="url.siteid" default="1">

<!---<cfset getEvents = assocObj.getEvents(#url.siteid#,#form#)>--->
<cfquery name="getEvents" datasource="#memberDSN#">
	SELECT e.*, ela.approval_date
	FROM sl_event e Left Join sl_event_league_approval ela On ela.eventid = e.eventid And ela.siteid = #url.siteid#
	Where 1 = 1
		<cfif LEN(form.evtype) GT 0>
			and eventtype = '#form.evtype#'
		</cfif>
		<cfif form.evdate EQ "Future">
			and fromdate >= '#DateFormat(Now(), "yyyy-mm-dd")#'
		</cfif>
	Order by fromdate, eventtype
</cfquery>

<cfset pageTitle = "Youth Sports - Sport Event List">
<cfinclude template="#rootdir#ssi/header.cfm">

<div class="panel panel-primary">
	<div class="panel-heading">
		<div class="panel-title text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
	</div>
    <div class="panel-body">
	<form action="sportevent.cfm" method="post">
	<div class="col-xs-12 text-center">
    	<div class="form-group">
			<label class="smallb">Event Type:</label>
			<select name="evtype" onChange="document.forms[0].submit();" class="small">
				<option value=""<cfif form.evtype EQ ""> SELECTED</cfif>>All</option>
			<cfoutput query="getTypes">
				<option value="#Value_1#"<cfif Value_1 EQ form.evtype> SELECTED</cfif>>#Value_3#</option>
			</cfoutput>
			</select>&nbsp;&nbsp;
			<label class="smallb">Date:</label>
			<select name="evdate" class="small" onChange="document.forms[0].submit();">
				<option value=""<cfif form.evdate EQ ""> SELECTED</cfif>>All Events</option>
				<option value="Future"<cfif form.evdate EQ "Future"> SELECTED</cfif>>Future Only</option>
			</select>
        </div>
 			<cfoutput>
			<a href="sporteventedit.cfm?evtype=#form.evtype#&siteid=#url.siteid#" class="linksm">Add Event</a>
			</cfoutput>
   </div>
	</form>
	<div class="col-xs-12 text-center">
		<div class="table-responsive">
		<table class="table table-condensed no-border">
			<tr>
				<td valign="top" align="center">
					<div class="event-table">
					<table class="table table-condensed table-bordered table-striped">
					<thead>
						<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
							<td class="titlesmw" align="center">Event Date</td>
							<td class="titlesmw" align="center">Name</td>
							<td class="titlesmw" align="center">Type</td>
							<td class="titlesmw" align="center">Gender</td>
							<td class="titlesmw" align="center">Create Date</td>
							<td class="titlesmw" align="center">Approved</td>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="getEvents">
							<tr>
								<td class="small" align="center">#DateFormat(fromdate, "mm/dd/yyyy")#</td>
								<td class="small">
									<a href="sporteventedit.cfm?evid=#eventid#&evtype=#eventtype#&siteid=#url.siteid#" class="linksm">
										#eventname#
									</a>
								</td>
								<td class="small">#eventtype#</td>
								<td class="small" align="center">#eventgender#</td>
								<td class="small" align="center">#DateFormat(createdate, "mm/dd/yyyy")#</td>
								<td class="small" align="center">
								<cfif LEN(approval_date) GT 0>
								#DateFormat(approval_date, "mm/dd/yyyy")#
								<cfelse>
									<a href="sportevent.cfm?evid=#eventid#&approve=y&siteid=#url.siteid#" class="linksm">
									Approve Event
									</a>
								</cfif>
								</td>
							</tr>
						</cfoutput>
					</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td align="center">
					<cfoutput><a href="sporteventedit.cfm?evtype=#form.evtype#&siteid=#url.siteid#" class="linksm">Add Event</a></cfoutput>
				</td>
			</tr>
			<tr>
				<td class="small" align="center">
					<a href="javascript:window.close();" class="link">Close Window</a>
				</td>
			</tr>
		</table>
		</div>
	</div>
    </div>
</div>
<cfinclude template="#rootdir#ssi/footer.cfm">
