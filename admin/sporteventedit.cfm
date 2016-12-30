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
<tr><td align="center">
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
		<table table table-condensed no-border>
			<tr><td>
				<!--- Line 1 --->
				<div class="col-xs-7 form-group">
					<label class="col-xs-4 titlesub">Contact Name:</label>
					<div class="col-xs-8">
						<input name="evctname" id="evctname" type="text" value="<cfoutput>#form.evctname#</cfoutput>" placeholder="Contact Name" class="form-control input-small">
					</div>
				</div>
				<div class="col-xs-5 form-group">
					<label class="col-xs-3 titlesub">Phone:</label>
					<div class="col-xs-9">
						<input type="text" name="evctphone" value="<cfoutput>#form.evctphone#</cfoutput>" class="form-control input-small">
					</div>
				</div>
				<!--- Line 2 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-3 titlesub">Contact Email: </label>
					<div class="col-xs-9">
						<input type="text" name="evctemail" id="evctemail" class="form-control input-small" placeholder="Email Address" value="<cfoutput>#form.evctemail#</cfoutput>">
					</div>
				</div>
				<!--- Line 3 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-3 titlesub">Event Name: </label>
					<div class="col-xs-9">
						<input type="text" name="evname" id="evname" class="form-control input-small" placeholder="Event Name" value="<cfoutput>#form.evname#</cfoutput>">
					</div>
				</div>
				<!--- Line 4 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-1 titlesub">Type:</label>
					<div class="col-xs-3">
						<select name="evtype" class="form-control input-small">
						<cfoutput query="getTypes">
							<option value="#Value_1#"<cfif Value_1 EQ form.evtype> SELECTED</cfif>>#Value_3#</option>
						</cfoutput>
						</select>
					</div>
					<label class="col-xs-1 titlesub">Gender:</label>
					<div class="col-xs-3">
						<select name="evgender" class="form-control input-small">
						<cfoutput query="getGenders">
							<option value="#Value_1#"<cfif Value_1 EQ form.evgender> SELECTED</cfif>>#Value_3#</option>
						</cfoutput>
						</select>
					</div>
					<label class="col-xs-1 titlesub">Sport:</label>
					<div class="col-xs-3">
						<select name="evsport" class="form-control input-small">
						<cfoutput query="getSports">
							<option value="#Value_1#"<cfif Value_1 EQ form.evsport> SELECTED</cfif>>#Value_3#</option>
						</cfoutput>
						</select>
					</div>
				</div>
				<!--- Line 5 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-3 titlesub">Grades or Ages:</label>
					<div class="col-xs-4">
						<input type="text" name="evgrades" value="<cfoutput>#form.evgrades#</cfoutput>" class="form-control input-small">
					</div>
					<label class="col-xs-1 titlesub">Cost:</label>
					<div class="col-xs-4">
						<input type="text" name="evcost" value="<cfoutput>#form.evcost#</cfoutput>" class="form-control input-small">
					</div>
				</div>
				<!--- Line 6 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-3 titlesub">Event Dates:</label>
					<div class="col-xs-3 dateContainer">
						<div class="input-group input-append date" id="fromDatePicker">
						<input type="text" name="evfromdate" id="evfromdate" value="<cfoutput>#form.evfromdate#</cfoutput>" class="form-control input-small" placeholder="From Date">
						<span class="input-group-addon add-on"><span class="glyphicon glyphicon-calendar"></span></span>
						</div>
					</div>
					<div class="col-xs-3 dateContainer">
						<div class="input-group input-append date" id="toDatePicker">
						<input type="text" name="evtodate" id="evtodate" value="<cfoutput>#form.evtodate#</cfoutput>" class="form-control input-small" placeholder="To Date">
						<span class="input-group-addon add-on"><span class="glyphicon glyphicon-calendar"></span></span>
						</div>
					</div>
					<div class="col-xs-3 dateContainer">
						<div class="input-group input-append date" id="deadlineDatePicker">
						<input type="text" name="evdeadline" id="evdeadline" value="<cfoutput>#form.evdeadline#</cfoutput>" class="form-control input-small" placeholder="Deadline">
						<span class="input-group-addon add-on"><span class="glyphicon glyphicon-calendar"></span></span>
						</div>
					</div>
				</div>
				<!--- Line 7 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-3 titlesub">Event Website: </label>
					<div class="col-xs-9">
						<input type="text" name="evwebsite" value="<cfoutput>#form.evwebsite#</cfoutput>" class="form-control input-small">
					</div>
				</div>
				<!--- Line 8 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-3 titlesub">Location: </label>
					<div class="col-xs-9">
						<input type="text" name="evloca" value="<cfoutput>#form.evloca#</cfoutput>" class="form-control input-small">
					</div>
				</div>
				<!--- Line 8 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-3 titlesub">Event Address: </label>
					<div class="col-xs-9">
						<input type="text" name="evaddr" value="<cfoutput>#form.evaddr#</cfoutput>" class="form-control input-small">
					</div>
				</div>
				<!--- Line 9 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-2 titlesub">Event City:</label>
					<div class="col-xs-4">
						<input type="text" name="evcity" value="<cfoutput>#form.evcity#</cfoutput>" class="form-control input-small">
					</div>
					<label class="col-xs-1 titlesub">State:</label>
					<div class="col-xs-2">
						<input type="text" name="evstate" value="<cfoutput>#form.evstate#</cfoutput>" class="form-control input-small">
					</div>
					<label class="col-xs-1 titlesub">Zip:</label>
					<div class="col-xs-2">
						<input type="text" name="evzip" value="<cfoutput>#form.evzip#</cfoutput>" class="form-control input-small">
					</div>
				</div>
				<!--- Line 10 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-3 titlesub">Event Flyer: </label>
					<div class="col-xs-9">
						<select name="evflyer" class="small">
							<option value=""<cfif #form.evflyer# EQ ""> selected</cfif>>None</option>
						<cfoutput query="filelist">
							<option value="#filelist.name#"<cfif #form.evflyer# EQ #filelist.name#> selected</cfif>>#filelist.name#</option>
						</cfoutput>
						</select>
						<span class="titlesub">or Upload New File</span><br>
						<input name="filename" type="file" class="form-control input-sm" size="60">
					</div>
				</div>
				<!--- Line 11 --->
				<div class="col-xs-12 form-group">
					<label class="col-xs-3 titlesub">Event Description: </label>
					<div class="col-xs-9">
						<textarea class="form-control input-small" name="evdesc" cols="90" rows="3"><cfoutput>#form.evdesc#</cfoutput></textarea>
					</div>
				</div>
				<!--- Line 12 --->
				<div class="col-xs-12 form-group text-center">
						<cfoutput>
						<label class="titlesub">
							Approve Event for #getSiteInfo.sitename#:
							<input name="evapproved" type="checkbox" value="#form.evapprdate#"<cfif #form.evapprdate# GT ""> checked</cfif>>
						</label>
						</cfoutput>
				</div>
				<!--- Line 13 --->
				<div class="col-xs-12 form-group">
					<div class="col-xs-12 text-center">
						<input type="submit" name="update" value="Submit Event" class="small">
						<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
						<input type="reset" class="small">
					</div>
				</div>
			</td></tr>
		</table>
		</form>
		<a href="javascript:history.go(-1);" class="link">Return to Events</a>&nbsp;&nbsp;&nbsp;
		<a href="javascript:window.close();" class="link">Close Window</a>
</td></TR>
</TABLE>
</cfif>
<br><br>
	</div>
</div>
<cfinclude template="#rootdir#ssi/footer.cfm">
<cfset today = DateFormat(Now(),"MM/DD/YYYY")>
<script>
$(document).ready(function() {
    $('#fromDatePicker')
        .datepicker({
            format: 'mm/dd/yyyy',
            startDate: '<cfoutput>#today#</cfoutput>'
        })
        .on('changeDate', function(e) {
            // Revalidate the start date field
            $('#eventForm').formValidation('revalidateField', 'evfromdate');
        });

    $('#toDatePicker')
        .datepicker({
            format: 'mm/dd/yyyy',
            startDate: '<cfoutput>#today#</cfoutput>'
        })
        .on('changeDate', function(e) {
            $('#eventForm').formValidation('revalidateField', 'evtodate');
        });

    $('#deadlineDatePicker')
        .datepicker({
            format: 'mm/dd/yyyy',
            startDate: '<cfoutput>#today#</cfoutput>'
        })
        .on('changeDate', function(e) {
            $('#eventForm').formValidation('revalidateField', 'evdeadline');
        });

    $('#eventForm').formValidation({
        framework: 'bootstrap',
        icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            evctname: {
                validators: {
                    notEmpty: {
                        message: 'The Contact Name is required'
                    }
                }
            },
            evctemail: {
                validators: {
                    emailAddress: {
                        message: 'The Contact Email is invalid'
                    }
                }
            },
            evname: {
                validators: {
                    notEmpty: {
                        message: 'The Event Name is required'
                    }
                }
            },
			evfromdate: {
				validators: {
					notEmpty: {
						message: 'The From Date is required'
					},
					date: {
						format: 'MM/DD/YYYY',
						max: 'evtodate',
						message: 'The From Date is not a valid'
					}
				}
			},
			evtodate: {
				validators: {
					date: {
						format: 'MM/DD/YYYY',
						min: 'evfromdate',
						message: 'The To Date is not a valid'
					}
				}
			},
			evdeadline: {
				validators: {
					date: {
						format: 'MM/DD/YYYY',
						message: 'The Deadline Date is not a valid'
					}
				}
			}
        }
	})
	.on('success.field.fv', function(e, data) {
		if (data.field === 'evfromdate' && !data.fv.isValidField('evtodate')) {
			// We need to revalidate the end date
			data.fv.revalidateField('evtodate');
		}

		if (data.field === 'evtodate' && !data.fv.isValidField('evfromdate')) {
			// We need to revalidate the start date
			data.fv.revalidateField('evfromdate');
		}
    });
});
</script>