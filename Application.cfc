<cfcomponent>
	
	<cfset this.name = "CBLOmaha"> 
	<cfset this.clientmanagement="False"> 
	<cfset this.sessionmanagement="True"> 
	<cfset this.sessiontimeout="#createtimespan(0,0,30,0)#"> 
	<cfset this.applicationtimeout="#createtimespan(10,0,0,0)#">
    
	
	<cffunction name="onApplicationStart">
        return true;
	</cffunction>

    <cffunction  name="onRequestStart" returntype="void">
		<cfset application.memberDSN = "cblomaha">
		<cfset application.aid = 1>
		<cfset application.pwKey = "cblomaha">
		<cfset application.leagueDir = "D:\home\cblomaha.com\wwwroot">
		<cfquery name="SelectAssocInfo" datasource="#application.memberDSN#">
			Select *
			From sl_association
			Where associd = #application.aid#
		</cfquery>
		<cfset application.sl_name = "#SelectAssocInfo.AssocName#">
		<cfset application.sl_siteid = "#SelectAssocInfo.SiteID#">
		<cfset application.sl_assocabrv = "#SelectAssocInfo.AssocAbrv#">
		<cfset application.sl_url = "#SelectAssocInfo.AssocURL#">
		<cfset application.sl_desc = "#SelectAssocInfo.Description#">
		<cfset application.sl_keywords = "#SelectAssocInfo.Keywords#">
		<cfset application.sl_logo = "#SelectAssocInfo.AssocLogo#">
		<cfset application.sl_hdcenter = "#SelectAssocInfo.HeaderImageCenter#">
		<cfset application.sl_hdright = "#SelectAssocInfo.HeaderImageRight#">
		<cfset application.sl_hdleft = "#SelectAssocInfo.HeaderImageLeft#">
		<cfset application.sl_hdcolor = "#SelectAssocInfo.HeaderColor#">
		<cfset application.sl_tbcolor = "#SelectAssocInfo.TableHeaderColor#">
		<cfset application.sl_mncolor = "#SelectAssocInfo.HeaderMenuColor#">
		<cfset application.sl_arcolor = "#SelectAssocInfo.AltRowColor#">
		<cfset application.sl_hdbkgimage = "#SelectAssocInfo.HeaderBackground#">
		<cfset application.sl_hdbkgheight = "#SelectAssocInfo.HeaderBkgHeight#">

		<cfif isDefined("url.lid") and url.lid GT 0>
			<cfquery name="SelectLeagueInfo" datasource="#application.memberDSN#">
				Select *
				From sl_league
				Where leagueid = #url.lid#
			</cfquery>
			<cfset application.sl_leaguename = "#SelectLeagueInfo.LeagueName#">
			<cfset application.sl_leaguelogo = "#SelectLeagueInfo.LeagueLogo#">
			<cfset application.sl_leagueHIC = "#SelectLeagueInfo.HeaderImageCenter#">
			<cfset application.sl_leagueHIR = "#SelectLeagueInfo.HeaderImageRight#">
			<cfset application.sl_leaguesport = "#SelectLeagueInfo.Sport#">
			<cfset application.sl_showplayers = "#SelectLeagueInfo.ShowPlayers#">
			<cfset application.sl_leaguetype = "#SelectLeagueInfo.LeagueType#">
			<cfset application.sl_showsched = "#SelectLeagueInfo.SchedFlag#">
		</cfif>
    	
    </cffunction>
    
	<!--- <cffunction name="onError"> 
		<cfargument name="Exception" required=true/> 
		<cfargument type="String" name="EventName" required=true/> 
		<!--- Log all errors. ---> 
		<cfif isDefined("Arguments.Eventname")>
			<cflog log="Application" type="error" text="Event Name: #Arguments.Eventname#" > 
		</cfif>
		<cfif isDefined("Arguments.Exception.message")>
			<cflog log="Application" type="error" text="Message: #Arguments.Exception.message#"> 
		</cfif>
		<cfif isDefined("Arguments.Exception.rootcause.message")>
			<cflog log="Application" type="error" text="Root Cause Message: #Arguments.Exception.rootcause.message#"> 
		</cfif>
		<!--- Display an error message if there is a page context. ---> 
		<cfif NOT (Arguments.EventName IS "onSessionEnd") OR  
				(Arguments.EventName IS "onApplicationEnd")> 
			<cfoutput> 
				<h2>Sorry, but an unexpected error occurred.</h2> 
				<p>Technical support has been notified of the issue.</p> 
				<!--- <p>Error Event: #Arguments.EventName#</p> 
				<p>Error details:<br> 
				<cfdump var=#Arguments.Exception#></p>  --->
			</cfoutput> 
		</cfif> 
	</cffunction> --->

</cfcomponent>
