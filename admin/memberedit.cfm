<cfparam name="action" default="">
<cfparam name="url.cid" default="">
<cfset done = 0>
<cfset errmsg = "">

<cfquery name="getLeaguesMbr" datasource="#memberDSN#">
	Select *
	From sl_league
	Where associd = #application.aid#
</cfquery>

<cfif action EQ "updateStaff">
	<cfquery name="CheckEmail" datasource="#memberDSN#">
		Select UserID
		From sl_user
		Where UserEmail = '#s_email#' and UserID <> #url.cid# and associd = #application.aid#
	</cfquery>
	<cfif CheckEmail.RecordCount EQ 0>
		<cfset ePassword = Encrypt(password1, '#application.pwKey#')>
		<cfquery name="UpdateStaff" datasource="#memberDSN#">
			Update sl_user
			Set UserName = '#s_name#',
				UserEmail = '#s_email#', 
				Password = <cfif LEN(ePassword) GT 0>'#ePassword#'<cfelse>NULL</cfif>,
				UserEmail2 = <cfif LEN(s_email2) GT 0>'#s_email2#'<cfelse>NULL</cfif>, 
				UserTextNbr = <cfif LEN(s_textnbr) GT 0>'#s_textnbr#'<cfelse>NULL</cfif>, 
				UserTextURL = <cfif LEN(s_textnbr) GT 0>'#s_texturl#'<cfelse>NULL</cfif>
			Where UserID = #url.cid#
		</cfquery>
		<cfquery name="DeleteUserNotify" datasource="#memberDSN#">
			Delete From sl_user_notify
			Where userid = #url.cid#
		</cfquery>
		<cfoutput query="getLeaguesMbr">
			<cfset s_levelEval = "form.s_slevel#leagueid#">
			<cfset s_levelValue = Evaluate(s_levelEval)>
			<cfif s_levelValue EQ "Yes">
				<cfquery name="InsertNotify" datasource="#memberDSN#">
					Insert Into sl_user_notify(UserID, LeagueID)
					Values (#url.cid#, #leagueid#)
				</cfquery>
			</cfif>
		</cfoutput>
		<cfset done = 1>
	<cfelse>
		<cfset errmsg = "** Duplicate Email Address **">
	</cfif>
<cfelseif action EQ "addStaff">
	<cfquery name="CheckEmail" datasource="#memberDSN#">
		Select UserID
		From sl_user
		Where UserEmail = '#s_email#' and associd = #application.aid#
	</cfquery>
	<cfif CheckEmail.RecordCount EQ 0>
		<cfset ePassword = Encrypt(password1, '#application.pwKey#')>
		<cfquery name="AddStaff" datasource="#memberDSN#">
			Insert Into sl_user (UserName, UserEmail, Password, UserEmail2, UserTextNbr, UserTextURL, MemberOnly, AssocID)
			Values('#s_name#', 
						'#s_email#', 
						<cfif LEN(ePassword) GT 0>'#ePassword#'<cfelse>NULL</cfif>,
						<cfif LEN(s_email2) GT 0>'#s_email2#'<cfelse>NULL</cfif>, 
						<cfif LEN(s_textnbr) GT 0>'#s_textnbr#'<cfelse>NULL</cfif>, 
						<cfif LEN(s_textnbr) GT 0>'#s_texturl#'<cfelse>NULL</cfif>,
						1,
						#application.aid#)		
		</cfquery>
		<cfquery name="getUserAdd" datasource="#memberDSN#">
			Select UserID
			From sl_user
			Where UserEmail = '#s_email#'
		</cfquery>
		<cfoutput query="getLeaguesMbr">
			<cfset s_levelEval = "form.s_slevel#leagueid#">
			<cfset s_levelValue = Evaluate(s_levelEval)>
			<cfif s_levelValue EQ "Yes">
				<cfquery name="InsertNotify" datasource="#memberDSN#">
					Insert Into sl_user_notify(UserID, LeagueID)
					Values (#getUserAdd.UserID#, #leagueid#)
				</cfquery>
			</cfif>
		</cfoutput>
		<cfset done = 1>
	<cfelse>
		<cfset errmsg = "** Duplicate Email Address **">
	</cfif>
<cfelseif action EQ "deleteStaff">
	<cftransaction>
		<cfquery name="DeleteNotify" datasource="#memberDSN#">
			Delete From sl_user_notify
			where  UserID = #url.cid#
		</cfquery>
		<cfquery name="DeleteCoach" datasource="#memberDSN#">
			Delete From sl_user
			where  UserID = #url.cid#
		</cfquery>
	</cftransaction>
	<cfset done = 1>
</cfif>
	
<cfset s_slevel1 = "No">
<cfset s_slevel2 = "No">
<cfset s_slevel3 = "No">
<cfset s_slevel4 = "No">
<cfset s_slevel5 = "No">
<cfset s_slevel6 = "No">
<cfset s_slevel7 = "No">
<cfset s_slevel8 = "No">
<cfset s_slevel9 = "No">

<cfif errmsg GT "">
<cfelseif url.cid GT "" AND action NEQ "deleteStaff">
	<cfquery name="GetUser" datasource="#memberDSN#">
		Select *
		From sl_user
		Where UserID = #url.cid#
	</cfquery>
	<cfquery name="GetNotifyLeagues" datasource="#memberDSN#">
		Select LeagueID
		From sl_user_notify
		Where userid = #url.cid#
		Order By LeagueID
	</cfquery>

	<cfset form.action="updateStaff">
	<cfset form.s_name="#GetUser.UserName#">
	<cfset form.s_email="#GetUser.UserEmail#">
	<cfset form.s_email2="#GetUser.UserEmail2#">
	<cfset form.s_textnbr="#GetUser.UserTextNbr#">
	<cfset form.s_texturl="#GetUser.UserTextURL#">
	<cfif GetUser.Password GT "">
		<cfset form.password1="#Decrypt(GetUser.Password,'#application.pwKey#')#">
	<cfelse>
		<cfset form.password1="">
	</cfif>
	<cfoutput query="getNotifyLeagues">
		<cfif getNotifyLeagues.leagueid EQ 1>
			<cfset s_slevel1 = "Yes">
		<cfelseif getNotifyLeagues.leagueid EQ 2>
			<cfset s_slevel2 = "Yes">
		<cfelseif getNotifyLeagues.leagueid EQ 3>
			<cfset s_slevel3 = "Yes">
		<cfelseif getNotifyLeagues.leagueid EQ 4>
			<cfset s_slevel4 = "Yes">
		<cfelseif getNotifyLeagues.leagueid EQ 5>
			<cfset s_slevel5 = "Yes">
		<cfelseif getNotifyLeagues.leagueid EQ 6>
			<cfset s_slevel6 = "Yes">
		<cfelseif getNotifyLeagues.leagueid EQ 7>
			<cfset s_slevel7 = "Yes">
		<cfelseif getNotifyLeagues.leagueid EQ 8>
			<cfset s_slevel8 = "Yes">
		<cfelseif getNotifyLeagues.leagueid EQ 9>
			<cfset s_slevel9 = "Yes">
		</cfif>
	</cfoutput>
<cfelse>
	<cfset form.action="addStaff">
	<cfset form.s_name="">
	<cfset form.s_email="">
	<cfset form.s_email2="">
	<cfset form.s_textnbr="">
	<cfset form.s_texturl="">
	<cfset form.password1="">
</cfif>

<cfquery name="GetTextURLs" datasource="#memberDSN#">
	Select value_1 as provider, value_2 as providerURL
	From sl_general_purpose
	Where name = 'TextMsgURL'
	Order By value_1
</cfquery>

<cfset rootDir = "../">
<cfset pageTitle = "#application.sl_name# - Member Edit">
<html>
<head>
	<cfinclude template="#rootDir#ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Member?"))
			{
				document.forms(0).action.value = "deleteStaff";
				document.forms(0).submit();
			} 
			else
			{
			
			}
		}	
		
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.history.go(0)
			window.close();
		  }
		}

		function echeck(str) {
			var at="@"
			var dot="."
			var lat=str.indexOf(at)
			var lstr=str.length
			var ldot=str.indexOf(dot)
			if (str.indexOf(at)==-1){
				alert("Invalid E-mail Address")
				return false
			}
			if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
				alert("Invalid E-mail Address")
				return false
			}
			if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
			 	alert("Invalid E-mail Address")
			 	return false
			}
			if (str.indexOf(at,(lat+1))!=-1){
				alert("Invalid E-mail Address")
				return false
			}
			if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
				alert("Invalid E-mail Address")
				return false
			}
			if (str.indexOf(dot,(lat+2))==-1){
				alert("Invalid E-mail Address")
				return false
			}
			if (str.indexOf(" ")!=-1){
				alert("Invalid E-mail Address")
				return false
			}
			return true          
		}

		function validatePwd() {
			var invalid = " "; // Invalid character is a space
			var minLength = 6; // Minimum length
			var pw1 = document.StaffForm.password1.value;
			var pw2 = document.StaffForm.password2.value;
			// check for a value in both fields.
			if (pw1 == '' || pw2 == '') {
				alert('Please enter your password twice.');
				return false;
			}
			// check for minimum length
			if (document.StaffForm.password1.value.length < minLength) {
				alert('Your password must be at least ' + minLength + ' characters long. Try again.');
				return false;
			}
			// check for spaces
			if (document.StaffForm.password1.value.indexOf(invalid) > -1) {
				alert("Sorry, spaces are not allowed.");
				return false;
			}
			else {
				if (pw1 != pw2) {
					alert ("You did not enter the same password twice. Please re-enter your password.");
					return false;
				}
			}
			return true;
		}

		function ValidateForm(){
			var staffName=document.StaffForm.s_name
			var emailID=document.StaffForm.s_email
			var emailID2=document.StaffForm.s_email2
			var psw1=document.StaffForm.password1
			var psw2=document.StaffForm.password2
		  	// Check Member Name
			if ((staffName.value==null)||(staffName.value=="")){
				alert("Please Enter Staff Member Name.")
				staffName.focus()
				return false
			}
			// Check Email Address is present and valid
			if ((emailID.value==null)||(emailID.value=="")){
				alert("Please Enter your Email ID")
				emailID.focus()
				return false
			}
			if (echeck(emailID.value)==false){
				emailID.focus()
				return false
			}
			// Check Email 2 is Valid if present
			if ((emailID2.value!=null)&&(emailID2.value!=""))
			{
				if (echeck(emailID2.value)==false){
					emailID2.focus()
					return false
				}
			}
			// Check that passwords are the same
			if (validatePwd()==false){
				psw1.value=""
				psw2.value=""
				psw1.focus()
				return false
			}
			return true
		}

	</script>
</head>
<cfif done>
	<cfset onloadattr = " closeRefresh();">
<cfelseif errmsg GT "">
	<cfset onloadattr = "document.forms(0).s_email.focus();">
<cfelse>
	<cfset onloadattr = "document.forms(0).s_name.focus();">
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<cfif NOT done>
<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#</cfoutput><br>
		Edit Member
	</td>
</tr>
<tr><td align="center">
	<table><tr><td valign="top" align="center">
		<form action="memberedit.cfm?cid=<cfoutput>#url.cid#</cfoutput>" method="post" name="StaffForm">
			<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
			<table border="1" cellspacing="0" cellpadding="3">
				<tr><td>
				<table cellpadding="2" cellspacing="0">
					<tr>
						<td class="smallb">*Name: </td>
						<td>
							<cfoutput>
							<input type="text" name="s_name" value="#form.s_name#" class="small" size="30">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td class="smallb">*Email: </td>
						<td>
							<cfoutput>
							<input type="text" name="s_email" value="#form.s_email#" class="small" size="40">
							<span class="notice">#errmsg#</span>
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td class="smallb">*Password: </td>
						<td class="smallb">
							<cfoutput>
							<input name="password1" type="password" class="small" value="#form.password1#" size="15" maxlength="12">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td class="smallb">*Retype Password: </td>
						<td class="smallb">
							<cfoutput>
							<input name="password2" type="password" class="small" value="#form.password1#" size="15" maxlength="12">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td class="smallb">2nd Email: </td>
						<td>
							<cfoutput>
							<input type="text" name="s_email2" value="#form.s_email2#" class="small" size="40">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td class="smallb" valign="top">Text Messaging: </td>
						<td>
							<cfoutput>
							<span class="smallb">Cell Nbr:</span>
							<input type="text" name="s_textnbr" value="#form.s_textnbr#" class="small" size="12" maxlength="10">
							</cfoutput><br>
							<span class="smallb">Provider:</span>
							<select name="s_texturl" class="small">
							<cfoutput query="GetTextURLs">
								<option value="#providerURL#"<cfif form.s_texturl EQ #providerURL#> SELECTED</cfif>>#provider#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="smallb">Notifications: </td><td></td>
					<tr>
						<td class="smallb">&nbsp;</td>
						<td>
							<table>
						<cfoutput query="getLeaguesMbr">
							<tr><td class="smallb">#leaguename#:</td>
							<td>
								<select name="s_slevel#leagueid#" class="small">
									<cfset s_levelEval = "s_slevel#leagueid#">
									<cfset s_levelValue = Evaluate(s_levelEval)>
									<option value="Yes"<cfif s_levelValue EQ 'Yes'> SELECTED</cfif>>Yes</option>
									<option value="No"<cfif s_levelValue EQ 'No'> SELECTED</cfif>>No</option>
								</select>
							</td></tr>
						</cfoutput>
						</table>
						</td>
					</tr>
				</table>
				</td></tr>
			</table>
			<br>
			<div align="center">
			<cfif form.action EQ "updateStaff">
				<input type="submit" name="update" value="Update" class="small" onClick="return ValidateForm();">
				<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
			<cfelse>
				<input type="submit" name="add" value="Add Member" class="small" onClick="return ValidateForm();">
			</cfif>
				<input type="reset" class="small">
				<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
			</div>
		</form>
	</td></tr>
	<tr> 
		<td class="small">* Required Field</td>
	</tr>
	</table>
</td></tr></table>
</cfif>
</body>
</html>
