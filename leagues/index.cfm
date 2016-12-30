<cfcookie name="lynxbbsid" expires="now">
<cfparam name="url.lid" default="1">
<cfset rootdir = "../">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<cfset gsDate = DateFormat(Now(), "yyyy-mm-dd")>
<cfset geDate = DateFormat(DateAdd("d", gsDate, 8), "yyyy-mm-dd")>
<cfset getGames = leagueObj.getGames(#url.lid#,"#gsDate#","#geDate#")>
<cfset getCategories = leagueObj.getCategories(#url.lid#)>
<cfset topCat = getCategories.value_1>
<cfset getNews = leagueObj.getNews(#url.lid#,#topCat#)>

<div class="panel">

<table class="table table-condensed">
	<tr>
		<td width="210" valign="top" align="center" class="hidden-xs hidden-sm titlesub">
		<cfoutput query="getCategories">
			<cfif getCategories.displayHP>
			<div class="panel panel-primary">
				<div class="panel-heading">
					#getCategories.value_3#
				</div>
				<div class="panel-body panel-body-smpad">
                	<cfset url.ncat = "#getCategories.value_1#">
                    <cfinclude template="../ssi/incl_news_table.cfm">
				</div>
			</div>
			</cfif>
		</cfoutput>
		</td>
		
		<td valign="top" align="center">
			<cfif getGames.RecordCount GT 0 and application.sl_showsched GT 0>
		      <div class="titlemain" align="center">Upcoming Games</div>
		      <div class="home-sched">
				<table id="schedTable" class="table table-fixedheader table-condensed table-hover">
		          <thead>
		            <tr>
		              <th class="col-xs-8 text-center titlesub">Teams</th>
		              <th class="col-xs-2 text-center titlesub">Time</th>
		              <th class="col-xs-2 text-center titlesub">Location</th>
		            </tr>
		          </thead>
		          <tbody>
					<cfset hDate = "">
					<cfset hDiv = "">
					<cfset colColor = "C6D6FF">
		          	<cfoutput query="getGames">
						<cfif gamedate NEQ hDate>
							<tr class="danger">
								<td class="titlesub" nowrap colspan="5" align="center">
								#DateFormat(gamedate, "mm/dd/yyyy")#
								</td>	
							</tr>						
							<tr class="info">
								<td class="titlesub" nowrap colspan="5" align="center">
								#divname#
								</td>	
							</tr>						
							<cfset hDate = "#gamedate#">
							<cfset hDiv = "#divname#">
							<cfset colColor = "C6D6FF">
						<cfelseif divname NEQ hDiv>
							<tr class="info">
								<td class="titlesub" nowrap colspan="5" align="center">
								#divname#
								</td>	
							</tr>						
							<cfset hDiv = "#divname#">
							<cfset colColor = "C6D6FF">
						</cfif>
			            <tr>
			              <td class="col-xs-8 small">#vteam# vs #hteam#</td>
			              <td class="col-xs-2 small text-center">#TimeFormat(gametime, "h:mm tt")#</td>
			              <td class="col-xs-2"><a href="locations.cfm?lid=#url.lid#&locaid=#locationid#" class="linksm" title="#locationname#">#shortname# - #courtname#</a></td>
			            </tr>
		            </cfoutput>
		          </tbody>
		        </table>
		      </div>  
			<cfelse>
				<cfoutput>
				<table BORDER="0" cellspacing="0" cellpadding="2" width="100%">
					<tbody>
						<tr>
							<td class="titlemain text-center">#getNews.Title#</td>
						</tr>
						<tr>
							<td>#getNews.Body#</td>
						</tr>
					</tbody>
				</table>
				</cfoutput>
		    </cfif>
		</td>
		
		<td width="200" valign="top" align="center" class="hidden-xs hidden-sm hidden-md">
			<strong>Weather</strong><br>
			<cfset getMessages = leagueObj.getMessages(#url.lid#)>
			<cfif getMessages.RecordCount GT 0>
				<script src="http://netwx.accuweather.com/netweatherV2.asp?zipcode=68102&lang=eng&size=5&theme=1&metric=0"></script>
				<br><strong>Message Board</strong><br>
				<cfset leagueHold ="z">
				<cfoutput query="getMessages">
					<cfif leagueHold NEQ leaguename>
						<cfset leagueHold = leaguename>
						<img src="../wsimages/CBL_logo_Both_sm200.gif">
						<div align="center"><cfif leaguename GT ""><strong>#leaguename# Messages<cfelse>Website Messages</strong></cfif></div>
					</cfif>
					<p>
					<div align="left">
					<span class="smallb">
					<cfif DateDiff("d", posteddate, now()) LTE 3><img src="../wsimages/new_sign_17.gif" border="0"></cfif>
					#title#</span><br>
					<span class="small">--Posted #DateFormat(posteddate, "mm/dd/yyyy")#<br><br></span>
					<div class="small">#message#</div>
					</p>
					</div>
					<img src="../wsimages/CBL_logo_Both_sm200.gif">
				</cfoutput>
			<cfelse>
				<strong>Weather</strong><br>
				<div style='width: 160px; height: 600px; background-image: url( http://vortex.accuweather.com/adcbin/netweather_v2/backgrounds/silver_160x600_bg.jpg ); background-repeat: no-repeat; background-color: #86888B;' ><div style='height: 585px;' ><script src='http://netweather.accuweather.com/adcbin/netweather_v2/netweatherV2.asp?myspace=0&logo=0&tStyle=whteYell&zipcode=68102&lang=eng&size=15&theme=1&metric=0'></script></div><div style='text-align: center; font-size: 9px;line-height: 15px; color: #FFFFFF;' ><a style='font-family: arial, helvetica, verdana, sans-serif; font-size: 9px; font-weight: normal; color: #FFFFFF' href='http://wwwa.accuweather.com/index-forecast.asp?partner=accuweather&traveler=0' >Weather Forecast</a> | <a style='font-size: 9px; font-weight: normal; color: #FFFFFF' href='http://wwwa.accuweather.com/maps-satellite.asp' >Weather Maps</a></div></div>			
			</cfif>
		</td>
	</tr>
</table>
</div>
<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
