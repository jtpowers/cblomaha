<cfset rootdir = "../">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfset errmsg = "">
<cfparam name="url.lid" default="1">
<cfparam name="url.ncat" default="">

<cfset getTopNews = leagueObj.getTopNews(#url.lid#, "#URLDecode(url.ncat)#")>

<cfparam name="url.nid" default="#getTopNews.newsid#">
<cfif url.ncat EQ "">
	<cfset url.ncat="#getTopNews.Category#">
</cfif>

<cfquery name="getNewsItem" datasource="#application.memberDSN#">
	Select n.*, gp.password, gp.gpid
	From sl_news n, sl_general_purpose gp
	Where newsid = #url.nid# and gp.value_1 = n.category and gp.name = 'MenuSection' and gp.leagueid = #url.lid#
</cfquery>
<cfif isDefined("form.mPassword")>
	<cfif form.mPassword EQ getNewsItem.password>
		<cfif isDefined("cookie.EVW_MenuSection")>
			<cfcookie name="EVW_MenuSection" value="#cookie.EVW_MenuSection#, #getNewsItem.gpid#">
		<cfelse>
			<cfcookie name="EVW_MenuSection" value="#getNewsItem.gpid#">
		</cfif>
	<cfelse>
		<cfset errmsg = "Sorry, that is the wrong Password.">
	</cfif>
</cfif>

<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
    <cfinclude template="#rootdir#ssi/header_news.cfm">
    
    <center>
    <cfif getNewsItem.password GT "" and NOT ParameterExists(cookie.EVW_MenuSection)>
        <cfinclude template="../ssi/menu_login.cfm">
    <cfelseif getNewsItem.password GT "" and Not ListContains(cookie.EVW_MenuSection, "#getNewsItem.gpid#")>
        <cfinclude template="../ssi/menu_login.cfm">
    <cfelse>
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
    </cfif>
    </center>
    <cfinclude template="#rootdir#ssi/footer_ad.cfm">
</div>
<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
