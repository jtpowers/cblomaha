<cfset rootdir = "">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfquery name="getTopNews" datasource="#application.memberDSN#" maxrows="1">
	Select *
	From sl_news
	Where associd = #application.aid# and
			category = '#url.ncat#' and
			DisplayFlag = 1
	Order by sortorder, createdate desc
</cfquery>

<cfparam name="url.nid" default="#getTopNews.newsid#">

<cfquery name="getNewsItem" datasource="#application.memberDSN#">
	Select *
	From sl_news
	Where newsid = #url.nid#
</cfquery>

<cfinclude template="#rootdir#ssi/header.cfm">

<center>
<table bgcolor="#FFFFFF">
	<tr>
		<td class="titlemain" align="center"><cfoutput>#getNewsItem.Title#</cfoutput></td>
	</tr>
	<tr>
		<td>
			<cfoutput>#getNewsItem.Body#</cfoutput>
		</td>
	</tr>
</table>
</center>
<cfinclude template="#rootdir#ssi/footer.cfm">
