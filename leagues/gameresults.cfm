<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">
<cfset errmsg = "">
<cfset rootdir = "../">
<cfparam name="url.lid" default="1">

<cfset getSeasons = leagueObj.getSeasons(#url.lid#)>

<cfinclude template="#rootdir#ssi/cookiecheck.cfm">

<cfset getGamesPlayed = leagueObj.getGamesPlayed(#form.sid#)>

<cfif form.sid NEQ sidCookie>
	<cfset form.gdate = getGamesPlayed.gamedate[1]>
</cfif>
<cfparam name="form.gdate" default="#getGamesPlayed.gamedate[1]#">
<cfif getGamesPlayed.RecordCount GT 0>
	<cfset getGameScores = leagueObj.getGameResults(#url.lid#,#form.gdate#)>
</cfif>

<cfset getDivisions = leagueObj.getDivisions(sid=#form.sid#)>

<cfset pageTitle = "Game Results">
<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">

	<div class="row">
		<div class="col-xs-12 titlemain">
			<cfoutput>#pageTitle#</cfoutput>
		</div>
	</div>
	<div class="row">
		<div class="clearfix col-md-4 col-lg-4 col-xs-hidden col-sm-hidden"></div>
		<div class="col-sm-12 col-md-4 col-lg-3 titlemain">
			<form action="gameresults.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post" class="form-horizontal">
				<div class="form-group">
					<label class="control-label col-xs-6 small">Season</label>
					<div class="col-xs-6 pull-left">
						<select name="sid" class="small" onChange="submit();">
						<cfoutput query="getSeasons">
							<option value="#SeasonID#"<cfif SeasonID EQ form.sid> SELECTED</cfif>>#SeasonName#</option>
						</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label col-xs-6 small">Game Date:</label>
					<div class="col-xs-6 pull-left">
						<select name="gDate" class="small" onChange="submit();">
						<cfoutput query="getGamesPlayed">
							<option value="#DateFormat(gamedate, 'yyyy-mm-dd')#"<cfif form.gDate EQ DateFormat(gamedate, 'yyyy-mm-dd')> selected</cfif>>#DateFormat(gamedate, 'ddd, mm/dd/yyyy')#</option>
						</cfoutput>
						</select>
					</div>
				</div>
			</form>
		</div>
		<div class="clearfix col-md-4 col-lg-4 col-xs-hidden col-sm-hidden"></div>
	</div>

<table border="0" cellspacing="0" cellpadding="2" width="100%"><!--T1-->

<tr><td>&nbsp;</td></tr>
<tr><td align="center">
<cfif getGamesPlayed.RecordCount GT 0>
	<table class="table table-responsive table-condensed no-border"><!--T2-->
		<cfset hDiv = "">
		<cfset holdLevel = "">
		<cfset levelcount = 1>
		<CFOUTPUT QUERY="getGameScores">
			<cfif getDivisions.RecordCount GT 3>
				<cfif divlevel NEQ holdLevel>
					<cfif levelcount GT 1>
						</table><!--T2-->
						</td></tr>
						<cfset hDiv = "">
					</cfif>
					<cfset levelcount = levelcount + 1>
					<cfset holdLevel = divlevel>
					<tr><td align="center" valign="top">
				</cfif>
			<cfelse>
				<tr><td align="center" valign="top">
			</cfif>
			<cfif divname NEQ hDiv>
				<cfif hDiv NEQ ""></table><!-- T3 --></td><td valign="top"></cfif>
				<TABLE BORDER="0" cellspacing="0" cellpadding="2" width="250"><!-- T3 -->
				<tr bgcolor="#application.sl_tbcolor#">
					<TD class="titlesubw" nowrap align="center">
					#divname#
					</TD>	
				</tr>						
				<cfset hDiv = "#divname#">
			</cfif>

			<TR>
				<TD class="small" nowrap>
					<table cellpadding="1" cellspacing="0" border="1" width="100%"><!--T4-->
					<tr><td>
						<table cellpadding="1" cellspacing="0" border="0" width="100%" bgcolor="CCCCFF"><!--T5-->
						<tr>
							<td<cfif H_Points LT V_Points> class="smallb"<cfelse> class="small"</cfif>>
								#vteam#&nbsp;&nbsp;
							</td>
							<td align="right"<cfif H_Points LT V_Points> class="smallb"<cfelse> class="small"</cfif>>
								#V_Points#
							</td>
						</tr>
						<tr>
							<td<cfif H_Points GT V_Points> class="smallb"<cfelse> class="small"</cfif>>
								#hteam#&nbsp;&nbsp;
							</td>
							<td align="right"<cfif H_Points GT V_Points> class="smallb"<cfelse> class="small"</cfif>>
								#H_Points#
							</td>
						</tr>
						</table><!--T5-->
					</td></tr>
					</table><!--T4-->
				</TD>
			</TR>
		</CFOUTPUT>
		</TABLE><!-- T3 -->
	</td></tr></TABLE><!-- T2 -->
</cfif>
</td></tr></TABLE><!-- T1 -->

</div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
