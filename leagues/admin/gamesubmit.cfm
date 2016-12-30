<cfparam name="form.tid" default="all">
<cfparam name="form.gDate" default="all">
<cfparam name="form.sortby" default="g.gamedate, g.gametime">

<cfif form.tid NEQ "all">
	<cfquery name="getDivID" datasource="#application.memberDSN#">
		Select t.divid, d.seasonid
		From sl_team t, sl_division d
		Where teamid = #form.tid# and 
				d.divid = t.divid
	</cfquery>
	<cfset form.did = getDivID.divid>
</cfif>

<cflocation url="game.cfm?lid=#url.lid#&tid=#form.tid#&gDate=#form.gDate#&sortby=#form.sortby#&did=#form.did#&sid=#form.sid#">