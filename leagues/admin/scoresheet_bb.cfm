<cfloop from="1" to="#getGames.RecordCount#" index="gIndex">

<cfquery name="getHTeam" datasource="#application.memberDSN#">
	Select playername, Alternate, jerseynbr
	From sl_player
	Where teamid = #getGames.h_teamid[gIndex]#
	Order By Alternate, jerseynbr, playername
</cfquery>
<cfquery name="getVTeam" datasource="#application.memberDSN#">
	Select playername, Alternate, jerseynbr
	From sl_player
	Where teamid = #getGames.v_teamid[gIndex]#
	Order By Alternate, jerseynbr, playername
</cfquery>

<cfif getGames.gameperiods[gIndex] EQ 4>
	<cfset periodText = "Quarter">
	<cfinclude template="scoresheet_quarters.cfm">
<cfelse>
	<cfset periodText = "Half">
	<cfinclude template="scoresheet_halfs2.cfm">
</cfif>

</cfloop>