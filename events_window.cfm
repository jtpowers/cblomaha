<cfset rootdir = "/">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="form.evtype" default="">
<cfparam name="form.evsport" default="">
<cfparam name="form.evgender" default="">
<cfparam name="form.evdate" default="Future">
<cfparam name="url.siteid" default="1">

<cfset getTypes = assocObj.getEventTypes()>
<cfset getGenders = assocObj.getEventGenders()>
<cfset getSports = assocObj.getEventSports()>
<cfset getEvents = assocObj.getEvents(#url.siteid#,#form#)>

<cfset pageTitle = "Youth Sports Events">
<cfinclude template="#rootdir#ssi/header.cfm">

<div class="panel panel-primary">
	<div class="panel-heading">
		<div class="panel-title text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
	</div>
    <div class="panel-body">
	<div class="col-xs-12 text-center">
		<a href="eventadd.cfm" class="linksm">Submit Your Event</a><br>
	</div>
	<form action="events_window.cfm" method="post">
	<div class="col-xs-12 text-center">
    	<div class="form-group">
			<label class="smallb">Event Type:</label>
			<select name="evtype" onChange="document.forms[0].submit();" class="small">
				<option value=""<cfif form.evtype EQ ""> SELECTED</cfif>>All</option>
			<cfoutput query="getTypes">
				<option value="#Value_1#"<cfif Value_1 EQ form.evtype> SELECTED</cfif>>#Value_3#</option>
			</cfoutput>
			</select>&nbsp;&nbsp;
			<label class="smallb">Sport:</label>
			<select name="evsport" class="small" onChange="document.forms[0].submit();">
				<option value=""<cfif form.evsport EQ ""> SELECTED</cfif>>All</option>
			<cfoutput query="getSports">
				<option value="#Value_1#"<cfif Value_1 EQ form.evsport> SELECTED</cfif>>#Value_3#</option>
			</cfoutput>
			</select>&nbsp;&nbsp;
			<label class="smallb">Gender:</label>
			<select name="evgender" class="small" onChange="document.forms[0].submit();">
				<option value=""<cfif form.evgender EQ ""> SELECTED</cfif>>All</option>
			<cfoutput query="getGenders">
				<option value="#Value_1#"<cfif Value_1 EQ form.evgender> SELECTED</cfif>>#Value_3#</option>
			</cfoutput>
			</select>&nbsp;&nbsp;
			<label class="smallb">Date:</label>
			<select name="evdate" class="small" onChange="document.forms[0].submit();">
				<option value=""<cfif form.evdate EQ ""> SELECTED</cfif>>All Events</option>
				<option value="Future"<cfif form.evdate EQ "Future"> SELECTED</cfif>>Future Only</option>
			</select>
        </div>
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
					<tr bgcolor="#000099">
						<td class="titlesmw" align="center">Date</td>
						<td class="titlesmw" align="center">Name</td>
						<td class="titlesmw" align="center">Type</td>
						<td class="titlesmw" align="center">Gender</td>
						<td class="titlesmw" align="center">Cost</td>
						<td class="titlesmw" align="center">Information</td>
					</tr>
					</thead>
					<tbody>
					<cfset gColor = "C6D6FF">
					<cfoutput query="getEvents">
						<tr>
							<td class="small" nowrap="nowrap">#DateFormat(fromdate, "mm/dd/yyyy")#</td>
							<td class="small">#eventname#</td>
							<td class="small">#eventtype#</td>
							<td class="small" nowrap="nowrap">#eventgender#&nbsp;</td>
							<td class="small">#cost#&nbsp;</td>
							<td nowrap="nowrap">
								<a href="javascript:fPopWindow('eventdetail.cfm?evid=#eventid#', 'custom','700','600','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm" title="Event Details">details</a><cfif LEN(contactemail) GT 0>|<a href="mailto:#contactemail#" class="linksm">email</a></cfif><cfif LEN(eventwebsite) GT 0><cfif Left(eventwebsite, 7) NEQ "http://"><cfset getEvents.eventwebsite = "http://#eventwebsite#"></cfif>|<a href="#getEvents.eventwebsite#" target="_blank" class="linksm">website</a></cfif><cfif LEN(eventflyer) GT 0>|<a href="files/evfiles/#eventflyer#" target="_blank" class="linksm">flyer</a></cfif>&nbsp;
							</td>
						</tr>
					</cfoutput>
					</tbody>
					</table>
					</div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<a href="eventadd.cfm" class="linksm">Submit Your Event</a>
				</td>
			</tr>
			<tr>
				<td align="center">
					<a href="javascript:window.close();" class="linksm">Close Window</a>
				</td>
			</tr>
		</table>
		</div>
	</div>
    </div>
</div>
<cfinclude template="#rootdir#ssi/footer.cfm">
