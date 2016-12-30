<cfsilent>
<!--- Name the application, and turn on session management --->
<CFAPPLICATION NAME="P1CBLOmahaApp" SESSIONMANAGEMENT="Yes">
<CFSET memberDSN = "cblomaha">

<cfset application.aid = 1>

<cfset application.pwKey = "cblomaha">
<cfset leagueDir = "D:\home\cblomaha.com\wwwroot">
<!--- <cfset leagueDir = "c:\ColdFusion8\wwwroot\lynxbb"> --->
<cfquery name="SelectAssocInfo" datasource="#memberDSN#">
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
	<cfquery name="SelectLeagueInfo" datasource="#memberDSN#">
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
</cfsilent>