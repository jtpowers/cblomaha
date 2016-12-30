<cfcomponent> 
	<cfobject component="cfc.league" name="leagueObj">
    
    <cffunction name="getAssocInfo"> 
    	<cfargument name="aid" required="yes" type="numeric" default="1">
    	
        <cfset var getAssocInfo=""> 
        <cfquery name="getAssocInfo" datasource="#memberDSN#">
			Select *
			From sl_association
			Where associd = #Arguments.aid#
		</cfquery>

         <cfreturn getAssocInfo> 
    </cffunction> 
    
    <cffunction name="updateVistorCount"> 
    	<cfargument name="aid" required="yes" type="numeric" default="1">
    	<cfargument name="vCount" required="yes" type="numeric" default="1">

		<cfset lcounter = Arguments.vCount + 1>
		<cfquery name="updateLeagueCounter" datasource="#memberDSN#">
			Update sl_association
			Set Visitors = #lcounter#
			Where associd = #Arguments.aid#
		</cfquery>
    </cffunction> 
    
    <cffunction name="getLeagues" returntype="query"> 
    	
        <cfset var getLeagues=""> 
		<cfquery name="getLeagues" datasource="#application.memberDSN#">
			Select *
			From sl_league
			Where leagueid = #application.aid#
		</cfquery>

         <cfreturn getLeagues> 
    </cffunction> 
    
    <cffunction name="checkMemberOnly"> 
    	<cfargument name="Lynx_UserID" required="yes">
	
        <cfset var checkMemberOnly=""> 
 		<cfquery name="checkMemberOnly" datasource="#application.memberDSN#">
			Select memberonly
			From sl_user
			Where userid = #Arguments.Lynx_UserID#
		</cfquery>

 		<cfreturn checkMemberOnly>
	</cffunction>

    <cffunction name="checkLogin" access="remote" returntype="string"> 
    	<cfargument name="email" required="yes" default="">
    	<cfargument name="password" required="yes" default="">
        
        <cfset validLogin = "False">
		<cfif arguments.password GT "">
            <cfset ePassword = Encrypt(arguments.password, '#application.pwKey#')>
        <cfelse>
            <cfset ePassword = "">
        </cfif>
        <cfquery name="checkUser" datasource="#application.memberDSN#">
            Select userid
            From sl_user
            Where UserEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#"> and 
            	password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ePassword#"> and 
                associd = <cfqueryparam cfsqltype="cf_sql_integer" value="#application.aid#">
        </cfquery>
        <cfif checkUser.RecordCount GT 0>
            <cfcookie name="Lynx_UserID" value="#checkUser.userid#">
            <cfset validLogin = "True">
        <cfelse>
            <cfset validLogin = "False">
        </cfif>

 		<cfreturn validLogin>
	</cffunction>

    <cffunction name="GetTextURLs" access="remote" returntype="query"> 
		
		<cfquery name="qryTextURLs" datasource="#application.memberDSN#">
			Select value_1 as provider, value_2 as providerURL
			From sl_general_purpose
			Where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="TextMsgURL">
			Order By value_1
		</cfquery>

 		<cfreturn qryTextURLs>
	</cffunction>

    <cffunction name="getUserInfo" access="remote" returntype="struct"> 
    	<cfargument name="cid" required="yes">
		
		<cfset userStruct = StructNew()>
		
		<cfquery name="qryUser" datasource="#application.memberDSN#">
			Select *
			From sl_user
			Where UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cid#">
		</cfquery>
		<cfset userStruct.getUser = qryUser>
		
		<cfquery name="qryNotifyLeagues" datasource="#application.memberDSN#">
			Select LeagueID
			From sl_user_notify
			Where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cid#">
			Order By LeagueID
		</cfquery>
		<cfset userStruct.getNotifyLeagues = qryNotifyLeagues>

 		<cfreturn userStruct>
	</cffunction>

    <cffunction name="addMember" access="remote" returntype="string"> 
    	<cfargument name="formStruct" required="yes" type="struct">
        
        <cfset rtnMessage = "">
		<cfquery name="CheckEmail" datasource="#application.memberDSN#">
			Select UserID
			From sl_user
			Where UserEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_email#"> and 
				associd = <cfqueryparam cfsqltype="cf_sql_integer" value="#application.aid#">
		</cfquery>
		<cfif CheckEmail.RecordCount EQ 0>
			<cfset ePassword = Encrypt(arguments.formStruct.password1, '#application.pwKey#')>
			<cfquery name="AddStaff" datasource="#application.memberDSN#">
				Insert Into sl_user (UserName, UserEmail, Password, UserEmail2, UserTextNbr, UserTextURL, MemberOnly, AssocID)
				Values('#s_name#', 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_email#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ePassword#">,
							<cfif LEN(arguments.formStruct.s_email2) GT 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_email2#"><cfelse>NULL</cfif>, 
							<cfif LEN(arguments.formStruct.s_textnbr) GT 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_textnbr#"><cfelse>NULL</cfif>, 
							<cfif LEN(arguments.formStruct.s_texturl) GT 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_texturl#"><cfelse>NULL</cfif>,
							1,
							#application.aid#)		
			</cfquery>
			<cfquery name="getUserAdd" datasource="#application.memberDSN#">
				Select UserID
				From sl_user
				Where UserEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_email#">
			</cfquery>
			<cfset getLeaguesMbr = leagueObj.getLeagueInfo(#application.aid#)>
			<cfoutput query="getLeaguesMbr">
				<cfset s_levelEval = "arguments.formStruct.s_slevel#leagueid#">
				<cfset s_levelValue = Evaluate(s_levelEval)>
				<cfif s_levelValue EQ "Yes">
					<cfquery name="InsertNotify" datasource="#application.memberDSN#">
						Insert Into sl_user_notify(UserID, LeagueID)
						Values (#getUserAdd.UserID#, #getLeaguesMbr.leagueid#)
					</cfquery>
				</cfif>
			</cfoutput>
			<cfset rtnMessage = "The profile has been added.">
		<cfelse>
			<cfset rtnMessage = "Profile has not been added.  Duplicate email address.">
		</cfif>

 		<cfreturn rtnMessage>
	</cffunction>

    <cffunction name="deleteMember" access="remote" returntype="string"> 
    	<cfargument name="cid" required="yes">
        
        <cfset rtnMessage = "The profile has been deleted.">
		<cftransaction>
			<cfquery name="DeleteNotify" datasource="#application.memberDSN#">
				Delete From sl_user_notify
				where  UserID = #arguments.cid#
			</cfquery>
			<cfquery name="DeleteCoach" datasource="#application.memberDSN#">
				Delete From sl_user
				where  UserID = #arguments.cid#
			</cfquery>
		</cftransaction>

 		<cfreturn rtnMessage>
	</cffunction>

    <cffunction name="updateMember" access="remote" returntype="string"> 
    	<cfargument name="formStruct" required="yes" type="struct">
        
        <cfset rtnMessage = "">
		<cfquery name="CheckEmail" datasource="#application.memberDSN#">
			Select UserID
			From sl_user
			Where UserEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_email#"> and 
				associd = <cfqueryparam cfsqltype="cf_sql_integer" value="#application.aid#"> and
                UserID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.cid#">
		</cfquery>
		<cfif CheckEmail.RecordCount EQ 0>
			<cfset ePassword = Encrypt(arguments.formStruct.password1, '#application.pwKey#')>
			<cfquery name="AddStaff" datasource="#application.memberDSN#">
				Update sl_user 
           		Set
					UserName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#s_name#">,
					UserEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_email#">, 
					Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ePassword#">,
					UserEmail2 = <cfif LEN(arguments.formStruct.s_email2) GT 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_email2#"><cfelse>NULL</cfif>, 
					UserTextNbr = <cfif LEN(arguments.formStruct.s_textnbr) GT 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_textnbr#"><cfelse>NULL</cfif>, 
					UserTextURL = <cfif LEN(arguments.formStruct.s_texturl) GT 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formStruct.s_texturl#"><cfelse>NULL</cfif>,
					AssocID = #application.aid#
				Where UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.cid#">		
			</cfquery>

			<cfset getLeaguesMbr = leagueObj.getLeagueInfo(#application.aid#)>
            <cfquery name="DeleteUserNotify" datasource="#application.memberDSN#">
                Delete From sl_user_notify
                Where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.cid#">
            </cfquery>
			<cfoutput query="getLeaguesMbr">
				<cfset s_levelEval = "arguments.formStruct.s_slevel#leagueid#">
				<cfset s_levelValue = Evaluate(s_levelEval)>
				<cfif s_levelValue EQ "Yes">
					<cfquery name="InsertNotify" datasource="#application.memberDSN#">
						Insert Into sl_user_notify(UserID, LeagueID)
						Values (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formStruct.cid#">, #getLeaguesMbr.leagueid#)
					</cfquery>
				</cfif>
			</cfoutput>
			<cfset rtnMessage = "The profile has been updated.">
		<cfelse>
			<cfset rtnMessage = "Profile not updated.  Duplicate email address.">
		</cfif>

 		<cfreturn rtnMessage>
	</cffunction>

    <cffunction name="getEventTypes" access="remote" returntype="query"> 
        
		<cfquery name="qry_getEventTypes" datasource="#application.memberDSN#">
			Select *
			From sl_general_purpose
			Where name = 'EventType'
			Order by Value_4
		</cfquery>

 		<cfreturn qry_getEventTypes>
	</cffunction>

    <cffunction name="getEvents" access="remote" returntype="query"> 
     	<cfargument name="siteid" required="yes" type="numeric">
    	<cfargument name="formStruct" required="yes" type="struct">
        <cfargument name="approvedOnly" type="numeric" default="1">
       
		<cfquery name="qry_getEvents" datasource="#application.memberDSN#">
			Select e.*, ela.approval_date
			From sl_event e Left Join sl_event_league_approval ela On ela.eventid = e.eventid And ela.siteid = #url.siteid#
			Where 1 = 1
				<cfif LEN(arguments.formStruct.evtype) GT 0>
					and eventtype = '#arguments.formStruct.evtype#'
				</cfif>
				<cfif LEN(arguments.formStruct.evsport) GT 0>
					and e.sport = '#arguments.formStruct.evsport#'
				</cfif>
				<cfif LEN(arguments.formStruct.evgender) GT 0>
					<cfif arguments.formStruct.evgender EQ "Boys" OR arguments.formStruct.evgender EQ "Girls">
						and (eventgender = '#arguments.formStruct.evgender#'
						or eventgender = 'Boys & Girls')
					<cfelse>
						and eventgender = '#arguments.formStruct.evgender#'
					</cfif>
				</cfif>
				<cfif arguments.formStruct.evdate EQ "Future">
					and fromdate >= '#DateFormat(Now(), "yyyy-mm-dd")#'
				</cfif>
				<cfif arguments.approvedOnly>
                	and ela.approval_date IS NOT NULL
                </cfif>
			Order by fromdate,eventtype
		</cfquery>

 		<cfreturn qry_getEvents>
	</cffunction>

    <cffunction name="getEventGenders" access="remote" returntype="query"> 
        
		<cfquery name="qry_getEventGenders" datasource="#application.memberDSN#">
			Select *
			From sl_general_purpose
			Where name = 'EventGender'
			Order by Value_4
		</cfquery>

 		<cfreturn qry_getEventGenders>
	</cffunction>

    <cffunction name="getEventSports" access="remote" returntype="query"> 
        
		<cfquery name="qry_getEventSports" datasource="#application.memberDSN#">
			Select *
			From sl_general_purpose
			Where name = 'EventSport'
			Order by Value_4
		</cfquery>

 		<cfreturn qry_getEventSports>
	</cffunction>


    <cffunction name="insertEvent" access="remote" returntype="string"> 
    	<cfargument name="formStruct" required="yes" type="struct">

        <cfquery name="qry_insertEvent" datasource="#application.memberDSN#">
            Insert Into sl_event (EventName, EventType, Location, EventAddress, EventState, EventCity,
            		EventZipCode, EventWebsite, EventDesc, Sport, FromDate, ToDate, Deadline, GradesAges, 
                    Cost, LeagueID, ContactName, ContactPhone, ContactEmail, EventFlyer, EventGender, createdate)
            Values('#arguments.formStruct.evname#',
                '#arguments.formStruct.evtype#',
                <cfif LEN(arguments.formStruct.evloca) GT 0>'#arguments.formStruct.evloca#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evaddr) GT 0>'#arguments.formStruct.evaddr#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evstate) GT 0>'#arguments.formStruct.evstate#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evcity) GT 0>'#arguments.formStruct.evcity#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evzip) GT 0>'#arguments.formStruct.evzip#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evwebsite) GT 0>'#arguments.formStruct.evwebsite#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evdesc) GT 0>'#arguments.formStruct.evdesc#'<cfelse>NULL</cfif>,
                '#arguments.formStruct.evsport#',
                <cfif LEN(arguments.formStruct.evfromdate) GT 0>'#DateFormat(arguments.formStruct.evfromdate, "YYYY-MM-DD")#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evtodate) GT 0>'#DateFormat(arguments.formStruct.evtodate, "YYYY-MM-DD")#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evdeadline) GT 0>'#DateFormat(arguments.formStruct.evdeadline, "YYYY-MM-DD")#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evgrades) GT 0>'#arguments.formStruct.evgrades#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evcost) GT 0>'#arguments.formStruct.evcost#'<cfelse>NULL</cfif>,
                NULL,
                <cfif LEN(arguments.formStruct.evctname) GT 0>'#arguments.formStruct.evctname#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evctphone) GT 0>'#arguments.formStruct.evctphone#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evctemail) GT 0>'#arguments.formStruct.evctemail#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evflyer) GT 0>'#arguments.formStruct.evflyer#'<cfelse>NULL</cfif>,
                <cfif LEN(arguments.formStruct.evgender) GT 0>'#arguments.formStruct.evgender#'<cfelse>NULL</cfif>,
                '#DateFormat(Now(), "YYYY-MM-DD")#')
        </cfquery>
        
        <cfset rtnMessage = "Your event has been saved.">
        
        <cfreturn rtnMessage>
    </cffunction>
    
    <cffunction name="approveEvent" access="remote" returntype="string"> 
     	<cfargument name="evid" required="yes" type="numeric">
     	<cfargument name="siteid" required="yes" type="numeric">

        <cfquery name="qry_approveEvent" datasource="#application.memberDSN#">
            Insert Into sl_event_league_approval (eventid, siteid, approval_date)
            Values (#arguments.evid#, #arguments.siteid#, '#DateFormat(now(), "yyyy-mm-dd")#')
        </cfquery>

		<cfset rtnMessage = "Your event has been approved.">
        
        <cfreturn rtnMessage>
    </cffunction>

</cfcomponent>