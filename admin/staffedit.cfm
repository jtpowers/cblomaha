<cfparam name="action" default="">
<cfparam name="url.cid" default="">
<cfset done = 0>
<cfset errmsg = "">
<cf_securityaccess userid="#cookie.Lynx_UserID#" aid="#application.aid#" dsn="#memberDSN#">
<cfset thisUserAccess = #useraccesslevel#>

<cfquery name="GetSecurityLeagues" datasource="#memberDSN#">
	Select LeagueName, LeagueID
	From sl_league
	Where AssocID = #application.aid#
	Order By LeagueID
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
				HPhoneNbr = <cfif LEN(s_hphone) GT 0>'#s_hphone#'<cfelse>NULL</cfif>, 
				WPhoneNbr = <cfif LEN(s_wphone) GT 0>'#s_wphone#'<cfelse>NULL</cfif>, 
				CPhoneNbr = <cfif LEN(s_cphone) GT 0>'#s_cphone#'<cfelse>NULL</cfif>, 
				UserEmail = '#s_email#', 
				Password = <cfif LEN(ePassword) GT 0>'#ePassword#'<cfelse>NULL</cfif>
			Where UserID = #url.cid#
		</cfquery>
		<cfquery name="DeleteAccess" datasource="#memberDSN#">
			Delete From sl_user_access
			Where userid = #url.cid# and associd = #application.aid#
		</cfquery>
		<cfquery name="InsertAccess" datasource="#memberDSN#">
			Insert Into sl_user_access(UserID, AssocID, LeagueID, AccessLevel)
			Values (#url.cid#, #application.aid#, NULL, #form.s_slevela#)
		</cfquery>
		
		<cfoutput query="GetSecurityLeagues">
			<cfset s_levelEval = "form.s_slevel#leagueid#">
			<cfset s_levelValue = Evaluate(s_levelEval)>
			<cfquery name="InsertAccess" datasource="#memberDSN#">
				Insert Into sl_user_access(UserID, AssocID, LeagueID, AccessLevel)
				Values (#url.cid#, #application.aid#, #leagueid#, #s_levelValue#)
			</cfquery>
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
			Insert Into sl_user (UserName, HPhoneNbr, WPhoneNbr, CPhoneNbr, UserEmail, Password, AssocID)
			Values('#s_name#', 
						<cfif LEN(s_hphone) GT 0>'#s_hphone#'<cfelse>NULL</cfif>, 
						<cfif LEN(s_wphone) GT 0>'#s_wphone#'<cfelse>NULL</cfif>, 
						<cfif LEN(s_cphone) GT 0>'#s_cphone#'<cfelse>NULL</cfif>, 
						'#s_email#', 
						<cfif LEN(ePassword) GT 0>'#ePassword#'<cfelse>NULL</cfif>,
						#application.aid#)
		</cfquery>
		<cfquery name="getUserAdd" datasource="#memberDSN#">
			Select UserID
			From sl_user
			Where UserEmail = '#s_email#'
		</cfquery>
		<cfquery name="InsertAccess" datasource="#memberDSN#">
			Insert Into sl_user_access(UserID, AssocID, LeagueID, AccessLevel)
			Values (#getUserAdd.UserID#, #application.aid#, NULL, #form.s_slevela#)
		</cfquery>
		
		<cfoutput query="GetSecurityLeagues">
			<cfset s_levelEval = "form.s_slevel#leagueid#">
			<cfset s_levelValue = Evaluate(s_levelEval)>
			<cfquery name="InsertAccess" datasource="#memberDSN#">
				Insert Into sl_user_access(UserID, AssocID, LeagueID, AccessLevel)
				Values (#getUserAdd.UserID#, #application.aid#, #leagueid#, #s_levelValue#)
			</cfquery>
		</cfoutput>
		<cfset done = 1>
	<cfelse>
		<cfset ePassword = Encrypt(password1, '#application.pwKey#')>
		<cfset url.cid = #CheckEmail.UserID#>
		<cfquery name="UpdateStaff" datasource="#memberDSN#">
			Update sl_user
			Set UserName = '#s_name#',
				HPhoneNbr = <cfif LEN(s_hphone) GT 0>'#s_hphone#'<cfelse>NULL</cfif>, 
				WPhoneNbr = <cfif LEN(s_wphone) GT 0>'#s_wphone#'<cfelse>NULL</cfif>, 
				CPhoneNbr = <cfif LEN(s_cphone) GT 0>'#s_cphone#'<cfelse>NULL</cfif>, 
				UserEmail = '#s_email#', 
				Password = <cfif LEN(ePassword) GT 0>'#ePassword#'<cfelse>NULL</cfif>,
				MemberOnly = 0
			Where UserID = #url.cid#
		</cfquery>
		<cfquery name="DeleteAccess" datasource="#memberDSN#">
			Delete From sl_user_access
			Where userid = #url.cid# and associd = #application.aid#
		</cfquery>
		<cfquery name="InsertAccess" datasource="#memberDSN#">
			Insert Into sl_user_access(UserID, AssocID, LeagueID, AccessLevel)
			Values (#url.cid#, #application.aid#, NULL, #form.s_slevela#)
		</cfquery>
		
		<cfoutput query="GetSecurityLeagues">
			<cfset s_levelEval = "form.s_slevel#leagueid#">
			<cfset s_levelValue = Evaluate(s_levelEval)>
			<cfquery name="InsertAccess" datasource="#memberDSN#">
				Insert Into sl_user_access(UserID, AssocID, LeagueID, AccessLevel)
				Values (#url.cid#, #application.aid#, #leagueid#, #s_levelValue#)
			</cfquery>
		</cfoutput>
	</cfif>
<cfelseif action EQ "deleteStaff">
	<cftransaction>
		<cfquery name="DeleteTeamCoach" datasource="#memberDSN#">
			Delete From sl_user_access
			where  UserID = #url.cid# and associd = #application.aid#
		</cfquery>
		<cfquery name="DeleteCoach" datasource="#memberDSN#">
			Delete From sl_user
			where  UserID = #url.cid#
		</cfquery>
	</cftransaction>
	<cfset done = 1>
</cfif>
	
<cfif errmsg GT "">
<cfelseif url.cid GT "" AND action NEQ "deleteStaff">
	<cfquery name="GetUser" datasource="#memberDSN#">
		Select *
		From sl_user
		Where UserID = #url.cid#
	</cfquery>
	<cfset form.action="updateStaff">
	<cfset form.s_name="#GetUser.UserName#">
	<cfset form.s_hphone="#GetUser.HPhoneNbr#">
	<cfset form.s_wphone="#GetUser.WPhoneNbr#">
	<cfset form.s_cphone="#GetUser.CPhoneNbr#">
	<cfset form.s_email="#GetUser.UserEmail#">
	<cfif GetUser.Password GT "">
		<cfset form.password1="#Decrypt(GetUser.Password,'#application.pwKey#')#">
	<cfelse>
		<cfset form.password1="">
	</cfif>
		<cf_securityaccess userid="#cid#" aid="#application.aid#" dsn="#memberDSN#">
	<cfset form.s_slevela="#useraccesslevel#">
	<cfoutput query="getSecurityLeagues">
		<cf_securityaccess userid="#cid#" aid="#application.aid#" lid="#getSecurityLeagues.leagueid#" dsn="#memberDSN#">
		<cfif getSecurityLeagues.leagueid EQ 1>
			<cfset s_slevel1 = "#useraccesslevel#">
		<cfelseif getSecurityLeagues.leagueid EQ 2>
			<cfset s_slevel2 = "#useraccesslevel#">
		<cfelseif getSecurityLeagues.leagueid EQ 3>
			<cfset s_slevel3 = "#useraccesslevel#">
		<cfelseif getSecurityLeagues.leagueid EQ 4>
			<cfset s_slevel4 = "#useraccesslevel#">
		<cfelseif getSecurityLeagues.leagueid EQ 5>
			<cfset s_slevel5 = "#useraccesslevel#">
		<cfelseif getSecurityLeagues.leagueid EQ 6>
			<cfset s_slevel6 = "#useraccesslevel#">
		<cfelseif getSecurityLeagues.leagueid EQ 7>
			<cfset s_slevel7 = "#useraccesslevel#">
		<cfelseif getSecurityLeagues.leagueid EQ 8>
			<cfset s_slevel8 = "#useraccesslevel#">
		<cfelseif getSecurityLeagues.leagueid EQ 9>
			<cfset s_slevel9 = "#useraccesslevel#">
		</cfif>
	</cfoutput>
<cfelse>
	<cfset form.action="addStaff">
	<cfset form.s_name="">
	<cfset form.s_hphone="">
	<cfset form.s_wphone="">
	<cfset form.s_cphone="">
	<cfset form.s_email="">
	<cfset form.password1="">
	<cfset form.s_slevela="0">
	<cfset s_slevel1 = "0">
	<cfset s_slevel2 = "0">
	<cfset s_slevel3 = "0">
	<cfset s_slevel4 = "0">
	<cfset s_slevel5 = "0">
	<cfset s_slevel6 = "0">
	<cfset s_slevel7 = "0">
	<cfset s_slevel8 = "0">
	<cfset s_slevel9 = "0">
</cfif>

<cfset rootDir = "../">
<cfset pageTitle = "#application.sl_name# - User Edit">
<html>
<head>
	<cfinclude template="../ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this User Member?"))
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
			var psw1=document.StaffForm.password1
			var psw2=document.StaffForm.password2
		  
			if ((staffName.value==null)||(staffName.value=="")){
				alert("Please Enter Staff Member Name.")
				staffName.focus()
				return false
			}
			if ((emailID.value==null)||(emailID.value=="")){
				alert("Please Enter your Email ID")
				emailID.focus()
				return false
			}
			if (echeck(emailID.value)==false){
				emailID.focus()
				return false
			}
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
		Edit User Member
	</td>
</tr>
<tr><td align="center">
	<table><tr><td valign="top" align="center">
		<form action="staffedit.cfm?cid=<cfoutput>#url.cid#</cfoutput>" method="post" name="StaffForm">
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
						<td class="smallb" valign="top">Home Phone: </td>
						<td class="smallb">
							<cfoutput><input type="text" name="s_hphone" value="#form.s_hphone#" class="small" size="15"></cfoutput>
						</td>
					</tr>
					<tr>
						<td class="smallb" valign="top">Work Phone: </td>
						<td class="smallb">
							<cfoutput><input type="text" name="s_wphone" value="#form.s_wphone#" class="small" size="15"></cfoutput>
						</td>
					</tr>
					<tr>
						<td class="smallb" valign="top">Cell Phone: </td>
						<td class="smallb">
							<cfoutput><input type="text" name="s_cphone" value="#form.s_cphone#" class="small" size="15"></cfoutput>
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
					<cfif thisUserAccess GTE 9 OR form.action NEQ "updateStaff">
					<tr>
						<td class="smallb">Security Levels: </td><td></td>
					<tr>
						<td class="smallb">&nbsp;</td>
						<td>
							<table>
							<tr><td class="smallb"><cfoutput>#application.sl_assocabrv#</cfoutput> Main:</td>
							<td>
							<select name="s_slevela" class="small">
								<option value="0"<cfif form.s_slevela EQ 0> SELECTED</cfif>>None</option>
								<option value="5"<cfif form.s_slevela EQ 5> SELECTED</cfif>>Menu Section</option>
								<option value="9"<cfif form.s_slevela EQ 9> SELECTED</cfif>>Administrator</option>
							</select>
							</td></tr>
						<cfoutput query="getSecurityLeagues">
							<tr><td class="smallb">#leaguename#:</td>
							<td>
							<select name="s_slevel#leagueid#" class="small">
								<cfset s_levelEval = "s_slevel#leagueid#">
								<cfset s_levelValue = Evaluate(s_levelEval)>
								<option value="0"<cfif s_levelValue EQ 0> SELECTED</cfif>>None</option>
								<option value="3"<cfif s_levelValue EQ 3> SELECTED</cfif>>Menu Section</option>
								<option value="5"<cfif s_levelValue EQ 5> SELECTED</cfif>>Coach</option>
								<option value="7"<cfif s_levelValue EQ 7> SELECTED</cfif>>League Admin.</option>
							</select>
							</td></tr>
						</cfoutput>
						</table>
						</td>
					</tr>
					<cfelse>
						<input type="hidden" name="s_slevela" value="<cfoutput>#form.s_slevela#</cfoutput>">
						<cfoutput query="getSecurityLeagues">
							<cfset s_levelEval = "s_slevel#leagueid#">
							<cfset s_levelValue = Evaluate(s_levelEval)>
							<input type="hidden" name="s_slevel#leagueid#" value="#s_levelValue#">
						</cfoutput>
					</cfif>
				</table>
				</td></tr>
			</table>
			<br>
			<div align="center">
			<cfif form.action EQ "updateStaff">
				<input type="submit" name="update" value="Update" class="small" onClick="return ValidateForm();">
				<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
			<cfelse>
				<input type="submit" name="add" value="Add Staff Member" class="small" onClick="return ValidateForm();">
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
