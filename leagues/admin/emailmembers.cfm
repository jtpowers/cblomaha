<cfquery name="getEmailMembers" datasource="#memberDSN#">
	Select UserName, UserEmail, UserEmail2
	From sl_user u, sl_user_notify un
	where un.leagueid = #url.lid# and
			u.userid = un.userid and
			u.goodemail = 1
</cfquery>

<cfquery name="getLeagueEmail" datasource="#memberDSN#">
	Select LeagueName
	From sl_league
	Where leagueid = #url.lid#
</cfquery>
<cfquery name="getSender" datasource="#memberDSN#">
	Select UserName
	From sl_user
	Where userid = #cookie.Lynx_UserID#
</cfquery>
<cfset domainname = "#Replace(application.sl_url, "http://www.", "")#">

<cfoutput query="getEmailMembers">

<cfif isDefined("url.alertid")>
	<cfquery name="getAlertMsg" datasource="#memberDSN#">
		Select AlertTitle, AlertInfo
		From sl_alert
		Where alertid = #url.alertid#
	</cfquery>
	<cfif UserEmail2 GT "">
		<cfset emailList = "#getEmailMembers.UserEmail#; #getEmailMembers.UserEmail2#">
	<cfelse>
		<cfset emailList = "#getEmailMembers.UserEmail#">
	</cfif>

	<cfmail to="#emailList#" 
				from="webmaster@#domainname#" 
				subject="#getLeagueEmail.LeagueName# Alert" type="html">
<strong>#DateFormat(Now(), "mm/dd/yyyy")# #TimeFormat(Now(), "hh:mm tt")#</strong
><br><br>
#getSender.UserName# has posted an alert on the #Replace(application.sl_url, "http://www.", "")# website.
<br><br>
<strong>Alert Title:</strong><br>
#getAlertMsg.AlertTitle#
<br><br>
<strong>Alert Info:</strong>
<br>
#getAlertMsg.AlertInfo#
<br><br>
For more information go to 
<a href="#application.sl_url#/leagues/index.cfm?lid=#url.lid#" target="_blank"><strong>#Replace(application.sl_url, "http://www.", "")#</strong></a>.<br>
If you no longer wish to receive these emails, just login to #Replace(application.sl_url, "http://www.", "")# and update your profile, or reply to this email.
<br><br>
Have a great day
	</cfmail>

<cfelseif isDefined("url.msgid")>
	<cfquery name="getAlertMsg" datasource="#memberDSN#">
		Select Title, Message
		From sl_messageboard
		Where MessageID = #url.msgid#
	</cfquery>
	<cfmail to="#emailList#" 
				from="webmaster@#domainname#" 
				subject="#getLeagueEmail.LeagueName# Message" type="html">
<strong>#DateFormat(Now(), "mm/dd/yyyy")# #TimeFormat(Now(), "hh:mm tt")#</strong
><br><br>
#getSender.UserName# has posted a message on the #Replace(application.sl_url, "http://www.", "")# website.
<br><br>
<strong>Message Title:</strong><br>
#getAlertMsg.Title#
<br><br>
<strong>Message Info:</strong>
<br>
#getAlertMsg.Message#
<br><br>
For more information go to 
<a href="#application.sl_url#/leagues/index.cfm?lid=#url.lid#" target="_blank"><strong>#Replace(application.sl_url, "http://www.", "")#</strong></a>.<br>
If you no longer wish to receive these emails, just login to #Replace(application.sl_url, "http://www.", "")# and update your profile, or reply to this email.
<br><br>
Have a great day
	</cfmail>
</cfif>

</cfoutput>

<cfif isDefined("url.alertid")>
	<!--- Send Alert Text message email addresses --->
	<cfquery name="getTextMembers" datasource="#memberDSN#">
		Select UserName, UserTextNbr, UserTextURL
		From sl_user u, sl_user_notify un
		where un.leagueid = #url.lid# and UserTextNbr IS NOT NULL and UserTextNbr > "" and
				u.userid = un.userid
	</cfquery>
	
	<cfset txtNbr = 0>
	<cfloop query="getTextMembers">
		<cfif LEN(UserTextNbr) EQ 10 AND ISNumeric(UserTextNbr)>
			<cfoutput>#UserTextNbr#</cfoutput><br> 
			<cfif txtNbr GT 9><cfset txtNbr = 0></cfif>
			<cfmail to="#UserTextNbr##UserTextURL#" 
					from="txtmsg#txtNbr#@#domainname#" 
					subject="#getLeagueEmail.LeagueName#-#getAlertMsg.AlertTitle#">
#getAlertMsg.AlertInfo#
			</cfmail>
			<cfset txtNbr = txtNbr + 1>
		</cfif>
	</cfloop>

</cfif>
