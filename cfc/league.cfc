<cfcomponent> 
    <cffunction name="getLeagueInfo" returntype="query"> 
    	<cfargument name="lid" required="yes" type="numeric" default="1">
    	
        <cfset var getLeagueInfo=""> 
		<cfquery name="getLeagueInfo" datasource="#application.memberDSN#">
			Select *
			From sl_league
			Where leagueid = #Arguments.lid#
		</cfquery>

         <cfreturn getLeagueInfo> 
    </cffunction> 
    
    <cffunction name="updateVistorCount"> 
    	<cfargument name="lid" required="yes" type="numeric" default="1">
    	<cfargument name="vCount" required="yes" type="numeric" default="1">

		<cfset lcounter = Arguments.vCount + 1>
		<cfquery name="updateLeagueCounter" datasource="#application.memberDSN#">
			Update sl_league
			Set LeagueCounter = #lcounter#
			Where leagueid = #Arguments.lid#
		</cfquery>
    </cffunction> 
    
    <cffunction name="getCategories"> 
    	<cfargument name="lid" required="yes" type="numeric" default="1">
    	<cfargument name="category" type="string" default="">
    	
        <cfset var getCategories=""> 
		<cfquery name="getCategories" datasource="#application.memberDSN#">
			Select Distinct gp.value_1, gp.value_3, gp.Value_6 as displayHP
			From sl_general_purpose gp, sl_news n
			Where gp.name = 'MenuSection' and 
				  gp.AssocID = #application.aid# and 
				  gp.LeagueID = #arguments.lid# and 
                  <cfif arguments.category GT "">
                  	Value_1 = '#arguments.category#' and
                  </cfif>
				  n.Category = gp.value_1 and 
				  n.DisplayFlag = 1 and n.associd = #application.aid#
			Order by Value_4
		</cfquery>
		
		<cfreturn getCategories>
	</cffunction>

    <cffunction name="getMessages"> 
    	<cfargument name="lid" required="yes" type="numeric" default="1">

        <cfset var getMessages=""> 
		<cfquery name="getMessages" datasource="#application.memberDSN#">
			Select m.*, l.leaguename
			From sl_messageboard m Left Outer Join sl_league l On l.leagueid = m.leagueid
			Where (ExpirationDate >= Now() or ExpirationDate is NULL)
					and (m.leagueid is NULL or m.leagueid = #Arguments.lid#)
			Order by m.leagueid, PostedDate desc
		</cfquery>

		<cfreturn getMessages>
	</cffunction>
	
	
    <cffunction name="getHeaders"> 
    	<cfargument name="lid" type="numeric">
	
        <cfset var getHeaders=""> 
		<cfquery name="getHeaders" datasource="#application.memberDSN#">
			Select gp.value_1 as category, gp.value_2 as catDisplay
			From sl_general_purpose gp, sl_news n
			Where <cfif isDefined("Arguments.lid") and Arguments.lid GT "">gp.leagueid = #Arguments.lid#
					<cfelse>gp.associd = #application.aid# and gp.leagueid is NULL</cfif> and
					gp.value_5 = 1 and
					gp.name = 'MenuSection' and
					n.category = gp.value_1 and
					n.DisplayFlag = 1 and n.associd = #application.aid#
			Group By gp.value_1, gp.value_2
			Order By gp.value_4, gp.value_2
		</cfquery>

		<cfreturn getHeaders>
	</cffunction>

    <cffunction name="getCatItems"> 
    	<cfargument name="lid" type="numeric">
    	<cfargument name="ncat" required="yes">
	
        <cfset var getCatItems=""> 
		<cfquery name="getCatItems" datasource="#application.memberDSN#">
			Select *
			From sl_news
			Where 	<cfif isDefined("url.lid")>
						leagueid = #Arguments.lid# and
					<cfelse>
						associd = #application.aid# and leagueid is NULL and
					</cfif>
					Category = '#Arguments.ncat#' and
					DisplayFlag = 1
			Order by sortorder, createdate desc
		</cfquery>

 		<cfreturn getCatItems>
	</cffunction>


    <cffunction name="getAlertDisplay"> 
    	<cfargument name="lid" type="numeric">
	
        <cfset var getAlertDisplay=""> 
		<cfquery name="getAlertDisplay" datasource="#application.memberDSN#">
			Select *
			From sl_alert
			Where <cfif isDefined("Arguments.lid") and Arguments.lid GT "">leagueid = #Arguments.lid#<cfelse>associd = #application.aid#</cfif> and
					StartDate <= '#DateFormat(Now(), "yyyy-mm-dd")#' and
					EndDate >= '#DateFormat(Now(), "yyyy-mm-dd")#'
			Order By StartDate Desc
		</cfquery>

 		<cfreturn getAlertDisplay>
	</cffunction>
	
    <cffunction name="getTopNews"> 
    	<cfargument name="lid" type="numeric">
    	<cfargument name="ncat" default="">
		
		<cfquery name="qTopNews" datasource="#application.memberDSN#" maxrows="1">
			Select *
			From sl_news
			Where leagueid = #Arguments.lid# and
				<cfif Arguments.ncat GT "">
					category = '#Arguments.ncat#' and
				</cfif>
					DisplayFlag = 1
			Order by sortorder, createdate desc
		</cfquery>
		
 		<cfreturn qTopNews>
	</cffunction>
	
    <cffunction name="getNewsDisplay"> 
    	<cfargument name="lid" type="numeric">
    	<cfargument name="ncat" required="yes">
	
        <cfset var getNewsDisplay=""> 
		<cfquery name="getNewsDisplay" datasource="#application.memberDSN#">
			Select *
			From sl_news
			Where 	<cfif isDefined("Arguments.lid")>
						leagueid = #Arguments.lid# and
					<cfelse>
						associd = #application.aid# and leagueid is NULL and
					</cfif>
					Category = '#Arguments.ncat#' and
					DisplayFlag = 1
			Order by sortorder, createdate desc
		</cfquery>
		
 		<cfreturn getNewsDisplay>
	</cffunction>

    <cffunction name="getNews"> 
    	<cfargument name="lid" type="numeric">
    	<cfargument name="ncat" required="yes">
	
		<cfquery name="qry_getNews" datasource="#application.memberDSN#" maxrows="1">
			Select *
			From sl_news
			Where leagueid = #Arguments.lid# and
				category = '#Arguments.ncat#' and DisplayFlag = 1
			Order by sortorder, createdate desc
		</cfquery>
		
 		<cfreturn qry_getNews>
	</cffunction>

    <cffunction name="getGames"> 
    	<cfargument name="lid" required="yes" type="numeric">
    	<cfargument name="gsDate" default="">
    	<cfargument name="geDate" default="">
	
        <cfset var getGames=""> 
		<cfquery name="getGames" datasource="#application.memberDSN#">
			Select d.divname, d.divid, d.gender, s.seasonname, g.gametype, g.schedchange, g.status,
					g.gamedate, g.gametime, g.endtime, loca.locationname, loca.shortname, c.courtname, c.locationid, g.h_teamid, g.v_teamid, g.gamenbr,
					ht.name as hteam, ht.leaguenbr as hlnbr, g.gameid, g.h_points, g.v_points
					<cfif application.sl_leaguetype EQ "League">, vt.name as vteam, vt.leaguenbr as vlnbr
					<cfelse>, g.opponent as vteam, null as vlnbr</cfif>
			From sl_game g, sl_team ht, sl_location loca, sl_court c, sl_division d, sl_season s
				<cfif application.sl_leaguetype EQ "League">, sl_team vt</cfif>
			Where <cfif Arguments.gsDate GT "">
					(g.gamedate >= '#Arguments.gsDate#') and 
				  </cfif>
				  <cfif Arguments.geDate GT "">
					(g.gamedate <= '#Arguments.geDate#') and 
				  </cfif>
					s.leagueid = #Arguments.lid# and
					ht.teamid = g.h_teamid and
				  <cfif application.sl_leaguetype EQ "League">
					vt.teamid = g.v_teamid and
				  </cfif>
					c.courtid = g.courtid and
					loca.locationid = g.locationid and
					d.divid = ht.divid and
					s.seasonid = d.seasonid
			Order By g.gamedate, d.divorder, d.divname, g.gametime, g.endtime
		</cfquery>

 		<cfreturn getGames>
	</cffunction>

    <cffunction name="getAddsFooter" returntype="query" access="remote"> 
    	<cfargument name="lid" type="numeric" default="0">

		<cfquery name="qryAdsFooter" datasource="#application.memberDSN#" maxrows="5">
			Select a.AdID, a.AdName, a.AdLink, a.AdImage
            	<cfif arguments.lid GT 0>
                	, al.AdCount, al.adpriority, al.AdDisplayCount
                </cfif>
			From sl_advertiser a<cfif arguments.lid GT 0>, sl_advertiser_league al</cfif>
			Where 
            	<cfif arguments.lid GT 0>
                	al.leagueid = #url.lid# and al.AdID = a.AdID and al.adpriority is not null
                <cfelse>
                	a.adpriority is not null
                </cfif>
			Group By a.AdID, a.AdName, a.AdLink, a.AdImage, a.AdCount
          <cfif arguments.lid GT 0>
			Order by al.AdDisplayCount
          <cfelse>
			Order by a.AdDisplayCount
          </cfif>
		</cfquery>

 		<cfreturn qryAdsFooter>
	</cffunction>

    <cffunction name="updateAddsFooter" access="remote"> 
    	<cfargument name="newCount" required="yes" type="numeric">
    	<cfargument name="newDCount" required="yes" type="numeric">
    	<cfargument name="AdID" required="yes" type="numeric">
    	<cfargument name="lid" type="numeric" default="0">
        
        <cfquery name="updtAdsFooter" datasource="#application.memberDSN#">
            Update sl_advertiser_league
            Set AdCount = #arguments.newCount#,
                AdDisplayCount = #arguments.newDCount#
            Where AdID = #arguments.AdID#
            	<cfif arguments.lid GT 0>
                	and LeagueID = #arguments.lid#
               	</cfif>
        </cfquery>

	</cffunction>

    <cffunction name="getTopLocation" access="remote" returntype="query"> 
    	<cfargument name="lid" required="yes" type="numeric">
        
        <cfquery name="qryTopLocation" datasource="#application.memberDSN#" maxrows="1">
            Select l.*
            From sl_location l, sl_league_location ll
            Where ll.leagueid = #arguments.lid# and
                    l.locationid = ll.locationid
            Order by locationname
        </cfquery>
        
 		<cfreturn qryTopLocation>
	</cffunction>

    <cffunction name="getLocation" access="remote" returntype="query"> 
    	<cfargument name="locaid" required="yes" type="numeric">
        
        <cfquery name="qryLocation" datasource="#application.memberDSN#">
            Select *
            From sl_location
            Where locationid = #arguments.locaid#
        </cfquery>
        
 		<cfreturn qryLocation>
	</cffunction>
    
    <cffunction name="getLocationsList" access="remote" returntype="query"> 
    	<cfargument name="lid" required="yes" type="numeric">
    	<cfargument name="sid" default="">
        
        <cfquery name="qryLocationsList" datasource="#application.memberDSN#">
            Select l.*
            From sl_location l, sl_league_location ll
            Where ll.leagueid = #arguments.lid# and
                    l.locationid = ll.locationid and
                    l.locationname != 'TBD'
                <cfif arguments.sid GT "" AND IsNumeric(arguments.sid)>
                	and l.LocationID IN (SELECT DISTINCT LocationID FROM sl_game Where SeasonID = #arguments.sid#)
                </cfif>
            Order by locationname
        </cfquery>
        
 		<cfreturn qryLocationsList>
	</cffunction>

   <cffunction name="getSeasons" access="remote" returntype="query"> 
    	<cfargument name="lid" required="yes" type="numeric">
        
        <cfquery name="qrySeasons" datasource="#application.memberDSN#">
            Select seasonid, seasonname
            From sl_season
            Where leagueid = #arguments.lid#
            Order by startdate desc, seasonname
        </cfquery>
        
 		<cfreturn qrySeasons>
	</cffunction>

    <cffunction name="getSeason" access="remote" returntype="query"> 
    	<cfargument name="lid" required="yes" type="numeric">
    	<cfargument name="sid" required="yes" type="numeric">
        
        <cfquery name="qrySeason" datasource="#application.memberDSN#">
            Select seasonid, seasonname
            From sl_season
            Where leagueid = #arguments.lid# and seasonid = #arguments.sid#
            Order by startdate desc, seasonname
        </cfquery>
        
 		<cfreturn qrySeason>
	</cffunction>

    <cffunction name="getDivisions" access="remote" returntype="query"> 
    	<cfargument name="lid" default="">
    	<cfargument name="sid" required="yes" type="numeric">
        
        <cfquery name="qryDivisions" datasource="#application.memberDSN#">
            Select d.divname, d.gender, d.divid, d.divlevel, d.divorder, s.seasonname
            From sl_season s, sl_division d
            Where d.seasonID = s.seasonID and s.seasonid = #arguments.sid# 
			<cfif arguments.lid GT "">
				and s.leagueid = #arguments.lid#
			</cfif>
            Order by divorder, divname
        </cfquery>

 		<cfreturn qryDivisions>
	</cffunction>

    <cffunction name="getDivision" access="remote" returntype="query"> 
    	<cfargument name="did" required="yes" type="numeric">
        
        <cfquery name="qryDivision" datasource="#application.memberDSN#">
            Select d.*, s.seasonname
            From sl_season s, sl_division d
            Where d.seasonID = s.seasonID and
                    d.divid = #form.did#
        </cfquery>

 		<cfreturn qryDivision>
	</cffunction>

    <cffunction name="getTeams" access="remote" returntype="query"> 
    	<cfargument name="did" required="yes" type="numeric">

        <cfquery name="qryTeams" datasource="#application.memberDSN#">
            Select t.*, d.divname, d.gender
            From sl_team t, sl_division d
            Where d.divid = t.divid
                and t.divid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.did#">
                and t.name <> 'Bye'
            Order by t.leaguenbr, t.Name
        </cfquery>

 		<cfreturn qryTeams>
	</cffunction>

    <cffunction name="getTeam" access="remote" returntype="query"> 
    	<cfargument name="tid" required="yes" type="numeric">

        <cfquery name="qryTeam" datasource="#application.memberDSN#">
            Select t.*, d.divname, d.gender
            From sl_team t, sl_division d
            Where d.divid = t.divid
                and t.teamid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#">
        </cfquery>

 		<cfreturn qryTeam>
	</cffunction>

    <cffunction name="getPlayers" access="remote" returntype="query"> 
    	<cfargument name="tid" required="yes" type="numeric">

        <cfquery name="qryPlayers" datasource="#application.memberDSN#">
            SELECT playerid, p.playername, p.jerseynbr, alternate
            FROM sl_player p
            WHERE p.teamid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#">
            Order By alternate, p.jerseynbr, p.playername
        </cfquery>

 		<cfreturn qryPlayers>
	</cffunction>

    <cffunction name="getGameScores" access="remote" returntype="query"> 
    	<cfargument name="did" default="">
    	<cfargument name="tid" default="">

        <cfquery name="qryGameScores" datasource="#application.memberDSN#">
            Select d.divname,  
                    g.gamedate, g.gametime, g.h_points, g.V_points,
                    ht.name as hteam, ht.leaguenbr as hlnbr,
                    ht.level as hlevel
            <cfif application.sl_leaguetype EQ "League">, vt.name as vteam, vt.leaguenbr as vlnbr
                <cfelse>, g.opponent as vteam, null as vlnbr</cfif>	
            From sl_game g, sl_team ht, sl_division d
                <cfif application.sl_leaguetype EQ "League">, sl_team vt</cfif>
            Where 
                <cfif isDefined("arguments.tid") AND isNumeric(arguments.tid)>
                    <cfif application.sl_leaguetype EQ "League">
                        (ht.teamid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#"> OR 
                        	vt.teamid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#">) and
                    <cfelse>
                        (ht.teamid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#">) and
                    </cfif>
                <cfelse>
                    d.divid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.did#"> and
                </cfif>
                    ht.teamid = g.h_teamid and
                <cfif application.sl_leaguetype EQ "League">
                    vt.teamid = g.v_teamid and
                <cfelse>
                    g.gametype = 'game' and
                </cfif>
                    d.divid = ht.divid 
            Order By g.gamedate, g.gametime
        </cfquery>

 		<cfreturn qryGameScores>
	</cffunction>

    <cffunction name="getGameDates" access="remote" returntype="query"> 
    	<cfargument name="sid" required="yes" default="">

        <cfquery name="qryGameDates" datasource="#application.memberDSN#">
            Select g.gamedate
            From sl_game g, sl_team t, sl_division d
            Where t.teamid = g.H_Teamid and
                    d.divid = t.divid and
                    d.seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sid#">
            Group by gamedate
            Order by gamedate
        </cfquery>

 		<cfreturn qryGameDates>
	</cffunction>

    <cffunction name="getTeamGameDates" access="remote" returntype="query"> 
    	<cfargument name="tid" required="yes" default="">

        <cfquery name="qryTeamGameDates" datasource="#application.memberDSN#">
            Select gamedate, gameid
            From sl_game
            Where (H_Teamid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#"> or 
                        V_Teamid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tid#">) and
                        H_Points is not null
            Order by gamedate, gametime
        </cfquery>

 		<cfreturn qryTeamGameDates>
	</cffunction>

    <cffunction name="getGameSchedule" access="remote" returntype="query"> 
    	<cfargument name="sid" required="yes" default="">
    	<cfargument name="did" default="all">
    	<cfargument name="tid" default="all">
   		<cfargument name="gDate" default="all">
    	<cfargument name="u_locaid" default="all">
   		<cfargument name="refid" default="all">

		<cfif arguments.did NEQ "all">
            <cfset sortby = "g.gamedate, g.gametime">
        <cfelse>
            <cfset sortby = "loca.locationname, c.courtname, g.gamedate, g.gametime">
        </cfif>
        
        <cfquery name="qryGames" datasource="#application.memberDSN#">
        Select d.divname, d.divid, d.gender, s.seasonname, l.leaguename, l.leagueid, 
        		g.gametype, g.schedchange, g.status,
                g.gamedate, g.gametime, loca.locationname, loca.shortname, c.courtname, 
                g.h_teamid, g.v_teamid, g.h_points, g.v_points, g.gamenbr,
                ht.name as hteam, ht.leaguenbr as hlnbr, g.gameid, g.refid_1, g.refid_2, g.endtime
                <cfif application.sl_leaguetype EQ "League">, vt.name as vteam, vt.leaguenbr as vlnbr
                <cfelse>, g.opponent as vteam, null as vlnbr</cfif>
        From sl_game g, sl_team ht, sl_location loca, sl_court c, sl_division d, sl_season s, sl_league l
            <cfif application.sl_leaguetype EQ "League">, sl_team vt</cfif>
        Where 
            <cfif arguments.tid NEQ "all">
                (g.h_teamid = #arguments.tid# or g.v_teamid = #arguments.tid#) and
            </cfif>
            <cfif arguments.gDate EQ "all">
            <cfelseif arguments.gDate EQ "current">
                g.gamedate >= '#DateFormat(Now(), "YYYY-MM-DD")#' and
            <cfelse>
                g.gamedate = '#DateFormat(arguments.gDate, "YYYY-MM-DD")#' and
            </cfif>
            <cfif arguments.did NEQ "all">
                d.divid = #arguments.did# and
            </cfif>
            <cfif arguments.u_locaid NEQ "all">
                g.locationid = '#arguments.u_locaid#' and
            </cfif>
            <cfif arguments.refid NEQ "all">
                (g.refid_1 = #arguments.refid# or g.refid_2 = #arguments.refid#) and
            </cfif>
                ht.teamid = g.h_teamid and
            <cfif application.sl_leaguetype EQ "League">
                vt.teamid = g.v_teamid and
            </cfif>
                c.courtid = g.courtid and
                loca.locationid = g.locationid and
                d.divid = ht.divid and
                s.seasonid = d.seasonid and
                l.leagueid = s.leagueid and
                s.seasonid = #arguments.sid#
        Order By #sortby#
        </cfquery>

 		<cfreturn qryGames>
	</cffunction>

    <cffunction name="getRefs" access="remote" returntype="query"> 
    	<cfargument name="lid" required="yes" default="">

        <cfquery name="qryRefs" datasource="#application.memberDSN#">
            Select *
            From sl_referee
            Where leagueid = #arguments.lid#
            Order by refname
        </cfquery>

 		<cfreturn qryRefs>
	</cffunction>

    <cffunction name="getGamesPlayed" access="remote" returntype="query"> 
    	<cfargument name="sid" required="yes" default="">
		
		<cfquery name="qryGamesPlayed" datasource="#application.memberDSN#">
			Select g.gamedate
			From sl_game g, sl_team t, sl_division d
			Where H_Points is not null and
					t.teamid = g.H_teamid and
					d.divid = t.divid and
					d.seasonid = #arguments.sid#
			Group By gamedate
			Order By gamedate desc
		</cfquery>

 		<cfreturn qryGamesPlayed>
	</cffunction>

    <cffunction name="getGameResults" access="remote" returntype="query"> 
    	<cfargument name="lid" required="yes" default="">
   		<cfargument name="gDate" required="yes" default="all">
		
		<cfquery name="qryGameScores" datasource="#application.memberDSN#">
			Select d.divname, ht.level as hlevel, vt.level as vlevel, d.divlevel, 
					g.gamedate, g.gametime, g.h_points, g.V_points, g.gameid,
					ht.name as hteam, vt.name as vteam, ht.leaguenbr as hlnbr, vt.leaguenbr as vlnbr
			From sl_game g, sl_team ht, sl_team vt, sl_division d, sl_season s
			Where 
					g.gamedate = '#DateFormat(arguments.gdate, "yyyy-mm-dd")#' and
					ht.teamid = g.h_teamid and
					vt.teamid = g.v_teamid and
					d.divid = ht.divid and
					s.seasonid = d.seasonid and
					s.leagueid = #arguments.lid# and
					(ht.name <> 'Bye' or vt.name <> 'Bye')
			Order By d.divorder, d.divlevel, d.divname, g.gamedate, g.gametime
		</cfquery>

 		<cfreturn qryGameScores>
	</cffunction>

    <cffunction name="getStandings" access="remote" returntype="query"> 
    	<cfargument name="did" required="yes" default="">
		
        <cfquery name="qryStandings" datasource="#application.memberDSN#">
            SELECT t.name, t.leaguenbr, t.level,
                   SUM(IF(IF(t.teamid = g.h_teamid, h_points, v_points) > IF(t.teamid != g.h_teamid, h_points, v_points),1,0)) as wins,
                   SUM(IF(IF(t.teamid = g.h_teamid, h_points, v_points) < IF(t.teamid != g.h_teamid, h_points, v_points),1,0)) as losses,
                   SUM(IF(IF(t.teamid = g.h_teamid, h_points, v_points) = IF(t.teamid != g.h_teamid, h_points, v_points),1,0)) as ties,
                   SUM(IF(t.teamid = g.h_teamid, h_points, v_points)) as pointsfor,
                   SUM(IF(t.teamid != g.h_teamid, h_points, v_points)) as pointsagainst,
                   (SUM(IF(IF(t.teamid = g.h_teamid, h_points, v_points) > IF(t.teamid != g.h_teamid, h_points, v_points),1,0))) / 
                                                        (SUM(IF(t.teamid = g.h_teamid,1,0)) + SUM(IF(t.teamid = g.v_teamid,1,0))) as winpct
            FROM sl_team t Left Join sl_game g On (g.h_teamid = t.teamid or g.v_teamid = t.teamid) and g.h_points IS NOT NULL
            WHERE 
                  t.divid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.did#"> and
                  t.name <> 'Bye'
            GROUP BY t.name, t.leaguenbr, t.level
            Order By winpct desc, pointsagainst, pointsfor desc, t.leaguenbr
        </cfquery>

 		<cfreturn qryStandings>
	</cffunction>

</cfcomponent>