<cfset rootdir = "/">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="form.lid" default="0">
<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "addEvent">
	<cfset form.evflyer = "">
	<cfif LEN(form.filename) GT 0>
		<cffile action="upload"
				destination="#application.leagueDir#\files\evfiles"
				filefield="filename"
				nameconflict="overwrite">
		<cfset form.evflyer = "#File.ServerFile#">
	</cfif>

    <cfset insertEvent = assocObj.insertEvent(#form#)>

<cfmail to="jonjensen@pstechnology.com" bcc="joepowers@cox.net" from="webmaster@cblomaha.com" subject="Event Submitted" type="html">
The following event has been submitted for approval on #application.sl_name#
<br><br>
Event Name: #form.evname#<br>
Event Date: #DateFormat(form.evfromdate, "YYYY-MM-DD")#<br>
Contact Name: #form.evctname#<br>
<br><br>
You can approve this event from the <a href="#application.sl_URL#/admin/sportevent.cfm" target="_blank">Event Admin page</a>.
<br><br>
Have a Great Day!!!!!!
</cfmail>
	<cfset done = 1>
<cfelse>
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
</cfif>
<cfset form.action = "addEvent">

<cfquery name="getTypes" datasource="#application.memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'EventType'
	Order by Value_4
</cfquery>

<cfquery name="getGenders" datasource="#application.memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'EventGender'
	Order by Value_4
</cfquery>

<cfquery name="getSports" datasource="#application.memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'EventSport'
	Order by Value_4
</cfquery>

<cfset pageTitle = "Youth Sports Events">
<cfif done>
	<cfset onloadattr = "startTimer();">
<cfelse>
	<cfset onloadattr = "document.forms(0).evname.focus();">
</cfif>
<cfinclude template="#rootdir#ssi/header.cfm">

<script language="javascript">
	var pageTimeout = "";
	function startTimer() {
		if (pageTimeout == "") {
			pageTimeout = setTimeout('history.go(-2)',10000);
		}
	}
</script>

<div class="panel panel-primary">
	<div class="panel-heading">
		<div class="panel-title text-center">
			<span class="titlemain"><cfoutput>#pageTitle#</cfoutput></span><br>
        	<span class="titlesub">Add New Event</span>
        </div>
	</div>
    <div class="panel-body">

<cfif done>
	<br><br>
	Your event has been submited to the league director.<br><br>
	Once it has been approved it will show up on Event List.<br><br>
	Thank You for Submitting Your Event.<br><br>
	<a href="javascript:history.go(-2);" class="link">Return to Events</a>&nbsp;&nbsp;&nbsp;
	<a href="javascript:window.close();" class="link">Close Window</a>
<cfelse>
	<table width="100%"><tr><td valign="top" align="center">
		<form action="eventadd.cfm" method="post" enctype="multipart/form-data" name="eventForm" id="eventForm" class="form-horizonal">
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
				<div class="col-xs-12 form-group">
					<div class="col-xs-12 text-center">
						<input type="submit" name="update" value="Submit Event" class="titlesub">
						<input type="reset" class="titlesub">
					</div>
				</div>
			</td></tr>
		</table>
		</form>
		<a href="javascript:history.go(-1);" class="linksm">Return to Events</a>&nbsp;&nbsp;&nbsp;
		<a href="javascript:window.close();" class="linksm">Close Window</a>
	</td></tr></table>
</cfif>
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