<cfset rootdir = "../">
<cfparam name="form.tid" default="All">
<cfparam name="url.lid" default="">
<cfparam name="form.jt_gametype" default="All">

<cfset leagueType = "">
<cfif isDefined("url.calid")><cfset form.jt_calID = url.calid></cfif>
<cfif isDefined("url.tid")><cfset form.tid = url.tid></cfif>
<cfif isDefined("url.gType")><cfset form.jt_gametype = url.gType></cfif>

<cfif ParameterExists(Jump)>
	<cfset currentdate = "#dateformat('#jt_year#-#jt_month#-01')#">
</cfif>
<!--- set parameters --->
	<CFPARAM NAME="currentdate" DEFAULT="#dateformat(now())#">
	<CFPARAM NAME="currentMonth" DEFAULT="#month(currentdate)#">
	<CFPARAM NAME="currentYear" DEFAULT="#year(currentdate)#">
	<CFPARAM NAME="detail" DEFAULT="0">
	<CFPARAM NAME="FormDate" DEFAULT="#currentdate#">
	<CFPARAM NAME="ThisDate" DEFAULT="#FormDate#">
	<CFPARAM NAME="SelectedMonth" DEFAULT="#month(ThisDate)#">
	<CFPARAM NAME="SelectedYear" DEFAULT="#year(ThisDate)#">
	<CFSET FIRSTDAY= SelectedMonth & "/1/" & SelectedYear>
	<CFSET LASTDAY= SelectedMonth & "/" & #DAYSINMONTH(FIRSTDAY)# & "/" & SelectedYear >
	<CFSET FIRST_NN = #DAYOFWEEK(FIRSTDAY)# - 1>
	<CFSET LAST_NN = 7 - #DAYOFWEEK(LASTDAY)# >
	<CFSET Next_month = #dateformat(DateAdd("m",1,"#currentdate#"))#>
	<CFSET LAst_month = #dateformat(DateAdd("m",-1,"#currentdate#"))#>
<!--- end parameters --->

<!-- BEGIN DATA WINDOW -->
<cfquery name="getCalendars" datasource="#memberDSN#" dbtype="ODBC">
SELECT *
FROM sl_calendar
Where associd = #application.aid#
ORDER BY calOrder
</cfquery>
<cfif isDefined("form.jt_calID")><cfelse>
	<cfset form.jt_calID = getCalendars.calendarID[1]>
	<cfloop query="getCalendars">
		<cfif leagueid EQ url.lid>
			<cfset form.jt_calID = getCalendars.calendarID>
		</cfif>
	</cfloop>
</cfif>
<cfquery name="getCal" datasource="#memberDSN#" dbtype="ODBC">
SELECT *
FROM sl_calendar
WHERE 	calendarID in (#form.jt_calID#)
ORDER BY calOrder
</cfquery>
<cfset url.lid = getCal.leagueid>
<cfset cName = getCal.CalName>

<cfif getCal.leagueid GT "">
	<cfquery name="getCalLeague" datasource="#memberDSN#">
		Select LeagueType
		From sl_league
		Where leagueid = #getCal.leagueid#
	</cfquery>
	<cfset leagueType = "#getCalLeague.LeagueType#">
<cfelse>
	<cfset leagueType = "">
</cfif>

<cfif LEN(form.jt_calID) GT 2><cfset leagueType = "School"><cfset form.tid = "all"><cfset url.lid = ""><cfset cName = "ALHS Boys & Girls"></cfif>

<cfquery name="getEvents" datasource="#memberDSN#" dbtype="ODBC">
SELECT eventdate, starttime, endtime, location, description, title, status, eventid, calendarid, 0 as locationid, '' as otherinfo, '' as gametype
FROM sl_calendar_event 
WHERE 	calendarID in (#form.jt_calID#)
			AND (eventDate > '#DateFormat(LAst_month, "YYYY-MM")#-21'
					 AND eventDate < '#DateFormat(Next_month, "YYYY-MM")#-10')
			<cfif form.jt_gametype NEQ "all" AND form.jt_gametype NEQ "other">
				and 0 = 1
			</cfif>
ORDER BY eventDate, starttime, title
</cfquery>

<cfif leagueType EQ "League">
	<cfquery name="getGames" datasource="#memberDSN#">
		Select g.gamedate as eventdate, g.gametime as starttime, g.endtime as endtime,
				CONCAT(loca.locationname, '-', IF(c.courtname is NULL, '',c.courtname)) as location,
				CONCAT(vt.name, ' vs ', ht.name) as description,
				CONCAT(d.gender, ' ', d.divname) as title,
				g.status, g.gameid as eventid, g.calendarid, loca.locationid,
				g.description as otherinfo, g.gametype
		From sl_game g, sl_team ht, sl_team vt, sl_location loca, sl_court c, sl_division d
		Where calendarID = #form.jt_calID# and
				(gameDate > '#DateFormat(LAst_month, "YYYY-MM")#-21'
					 AND gameDate < '#DateFormat(Next_month, "YYYY-MM")#-10') and
				ht.teamid = g.h_teamid and
				vt.teamid = g.v_teamid and
				<cfif form.tid NEQ "all">(ht.teamid = #form.tid# or vt.teamid = #form.tid#) and</cfif>
				<cfif form.jt_gametype NEQ "all">
					g.gametype = '#form.jt_gametype#' and
				</cfif>
				c.courtid = g.courtid and
				loca.locationid = g.locationid and
				d.divid = ht.divid
		Order By gameDate, gametime
	</cfquery>
<cfelse>
	<cfquery name="getGames" datasource="#memberDSN#">
		Select g.gamedate as eventdate, g.gametime as starttime, g.endtime as endtime,
				CONCAT(loca.shortname, IF(c.courtname is NULL, '',CONCAT('-',c.courtname))) as location,
				CONCAT(' vs ', g.opponent) as description,
			<cfif LEN(form.jt_calID) GT 2>
				CONCAT(d.gender, ' ', ht.name, ' ', g.gametype) as title,
			<cfelse>
				CONCAT(ht.name, ' ', g.gametype) as title,
			</cfif>
				g.status, g.gameid as eventid, g.calendarid, loca.locationid,
				g.description as otherinfo, g.gametype
		From sl_game g, sl_team ht, sl_location loca, sl_court c, sl_division d
		Where calendarID IN (#form.jt_calID#) and
				(gameDate > '#DateFormat(LAst_month, "YYYY-MM")#-21'
					 AND gameDate < '#DateFormat(Next_month, "YYYY-MM")#-10') and
				ht.teamid = g.h_teamid and
				<cfif form.tid NEQ "all">ht.teamid =#form.tid# and</cfif>
				<cfif form.jt_gametype NEQ "all">
					g.gametype = '#form.jt_gametype#' and
				</cfif>
				c.courtid = g.courtid and
				loca.locationid = g.locationid and
				d.divid = ht.divid
		Order By gameDate, gametime
	</cfquery>
</cfif>

<cfquery name="Events" dbtype="query">
	Select *	From getEvents
	Union
	Select * From getGames
</cfquery>

<cfif url.lid GT "">
	<cfquery name="getTeams" datasource="#memberDSN#">
		Select t.teamid, t.name, d.divname, d.gender, d.divid, s.seasonname, l.leaguename, t.leaguenbr
		From sl_team t, sl_division d, sl_season s, sl_league l
		Where d.divid = t.divid and 
				s.seasonid = d.seasonid and 
				s.leagueid = l.leagueid and
				l.leagueid = #getCal.leagueid# and
				s.StartDate <= '#DateFormat(FIRSTDAY, "YYYY-MM-DD")#' and s.DeadlineDate >= '#DateFormat(LASTDAY, "YYYY-MM-DD")#'
		Order by l.leaguename, s.seasonname, d.divname, t.leaguenbr, t.Name
	</cfquery>
</cfif>
<cfquery name="getGameTypes" datasource="#memberDSN#">
	Select value_1 as gametype
	From sl_general_purpose
	Where name = 'GameType'
	Order By value_4
</cfquery>

<cfset pageTitle = "#application.sl_name# Calendar">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#application.sl_name#</cfoutput></title>
<cfinclude template="#rootdir#ssi/webscript.htm">
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">

<cfinclude template="#rootdir#ssi/header.htm">
<div id="dhtmltooltip"></div>

<script type="text/javascript">

/***********************************************
* Cool DHTML tooltip script- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/

var offsetxpoint=-60 //Customize x offset of tooltip
var offsetypoint=20 //Customize y offset of tooltip
var ie=document.all
var ns6=document.getElementById && !document.all
var enabletip=false
if (ie||ns6)
var tipobj=document.all? document.all["dhtmltooltip"] : document.getElementById? document.getElementById("dhtmltooltip") : ""

function ietruebody(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function ddrivetip(thetext, thecolor, thewidth){
if (ns6||ie){
if (typeof thewidth!="undefined") tipobj.style.width=thewidth+"px"
if (typeof thecolor!="undefined" && thecolor!="") tipobj.style.backgroundColor=thecolor
tipobj.innerHTML=thetext
enabletip=true
return false
}
}

function positiontip(e){
if (enabletip){
var curX=(ns6)?e.pageX : event.clientX+ietruebody().scrollLeft;
var curY=(ns6)?e.pageY : event.clientY+ietruebody().scrollTop;
//Find out how close the mouse is to the corner of the window
var rightedge=ie&&!window.opera? ietruebody().clientWidth-event.clientX-offsetxpoint : window.innerWidth-e.clientX-offsetxpoint-20
var bottomedge=ie&&!window.opera? ietruebody().clientHeight-event.clientY-offsetypoint : window.innerHeight-e.clientY-offsetypoint-20

var leftedge=(offsetxpoint<0)? offsetxpoint*(-1) : -1000

//if the horizontal distance isn't enough to accomodate the width of the context menu
if (rightedge<tipobj.offsetWidth)
//move the horizontal position of the menu to the left by it's width
tipobj.style.left=ie? ietruebody().scrollLeft+event.clientX-tipobj.offsetWidth+"px" : window.pageXOffset+e.clientX-tipobj.offsetWidth+"px"
else if (curX<leftedge)
tipobj.style.left="5px"
else
//position the horizontal position of the menu where the mouse is positioned
tipobj.style.left=curX+offsetxpoint+"px"

//same concept with the vertical position
if (bottomedge<tipobj.offsetHeight)
tipobj.style.top=ie? ietruebody().scrollTop+event.clientY-tipobj.offsetHeight-offsetypoint+"px" : window.pageYOffset+e.clientY-tipobj.offsetHeight-offsetypoint+"px"
else
tipobj.style.top=curY+offsetypoint+"px"
tipobj.style.visibility="visible"
}
}

function hideddrivetip(){
if (ns6||ie){
enabletip=false
tipobj.style.visibility="hidden"
tipobj.style.left="-1000px"
tipobj.style.backgroundColor=''
tipobj.style.width=''
}
}

document.onmousemove=positiontip

</script>
<center>
<table width="95%" border="0" cellspacing="0" cellpadding="3">
<tr>
	<td align="center" valign="top" class="smallb">
		<cfoutput>
		<form action="index.cfm?lid=#url.lid#" method="post">
		</cfoutput>
		Calendar:
		<select name="jt_calID" class="small">
			<cfoutput query="getCalendars">
				<option value="#calendarID#"<cfif jt_calID eq #calendarID#> SELECTED</cfif>>#calName#</option>
			</cfoutput>
		</select>
		<cfif url.lid GT "">
		&nbsp;&nbsp;&nbsp;
			Team:
			<select name="tid" class="small">
				<option value="all"<cfif form.tid EQ "all"> selected</cfif>>All</option>
			<cfoutput query="getTeams">
				<option value="#teamid#"<cfif form.tid EQ teamid> selected</cfif>><cfif leaguenbr GT "">#leaguenbr#. </cfif>#name#</option>
			</cfoutput>
			</select>
		</cfif>
		&nbsp;&nbsp;&nbsp;
		Event Type:
		<select name="jt_gametype" class="small">
			<option value="all"<cfif form.jt_gametype EQ "all"> SELECTED</cfif>>All</option>
			<cfoutput query="getGameTypes">
				<option value="#gametype#"<cfif form.jt_gametype EQ gametype> selected</cfif>>#gametype#</option>
			</cfoutput>
		</select>
		&nbsp;&nbsp;&nbsp;
		<select name="jt_month" class="small">
			<option value="1"<cfif currentMonth eq 1> SELECTED</cfif>>January</option>
			<option value="2"<cfif currentMonth eq 2> SELECTED</cfif>>February</option>
			<option value="3"<cfif currentMonth eq 3> SELECTED</cfif>>March</option>
			<option value="4"<cfif currentMonth eq 4> SELECTED</cfif>>April</option>
			<option value="5"<cfif currentMonth eq 5> SELECTED</cfif>>May</option>
			<option value="6"<cfif currentMonth eq 6> SELECTED</cfif>>June</option>
			<option value="7"<cfif currentMonth eq 7> SELECTED</cfif>>July</option>
			<option value="8"<cfif currentMonth eq 8> SELECTED</cfif>>August</option>
			<option value="9"<cfif currentMonth eq 9> SELECTED</cfif>>September</option>
			<option value="10"<cfif currentMonth eq 10> SELECTED</cfif>>October</option>
			<option value="11"<cfif currentMonth eq 11> SELECTED</cfif>>November</option>
			<option value="12"<cfif currentMonth eq 12> SELECTED</cfif>>December</option>
		</select>
		<input type="text" name="jt_year" value="<cfoutput>#currentYear#</cfoutput>" size="5" maxlength="4" class="small">
		<input type="submit" name="Jump" value="Go!" class="small">
		</form>
	</td>
</tr>
<tr>
	<td align="right" valign="top" class="small">
		<cfoutput>
		<a href="calprint.cfm?lid=#url.lid#&tid=#form.tid#&calid=#form.jt_calid#&year=#SelectedYear#&month=#SelectedMonth#&gType=#form.jt_gametype#" target="_blank" class="offheresm" onMouseover="ddrivetip('Go to Printable HTML Page','yellow','150');" onMouseout="hideddrivetip();">Printable Copy</a><!---  (
		<a href="calprint.cfm?lid=#url.lid#&calid=#form.jt_calid#&year=#SelectedYear#&month=#SelectedMonth#" target="_blank" class="offheresm" onMouseover="ddrivetip('Go to Printable HTML Page','yellow','150');" onMouseout="hideddrivetip();">HTML</a>,
		<a href="calprint.cfm?lid=#url.lid#&calid=#form.jt_calid#&year=#SelectedYear#&month=#SelectedMonth#&format=pdf" target="_blank" class="offheresm" onMouseover="ddrivetip('Go to Printable PDF Page','yellow','150');" onMouseout="hideddrivetip();">PDF</a>) --->
		</cfoutput>
	</td>
</tr>
</table>
<!--- begin calendar --->
<table width="95%" border="1" cellspacing="0" cellpadding="3">
<TR bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>" bordercolor="<cfoutput>#application.sl_tbcolor#</cfoutput>"><CFOUTPUT> 
	<td colspan="1" align="left" width="14.3%" valign="top"><a href="index.cfm?lid=#url.lid#&tid=#form.tid#&calid=#form.jt_calid#&currentdate=#last_month#&gType=#form.jt_gametype#" class="linkw" onMouseover="ddrivetip('Go to #DateFormat(last_month, "mmmm, yyyy")#','yellow','150');" onMouseout="hideddrivetip();"><img src="/wsimages/left_arrow_yellow.gif" width="9" height="15" border="0" alt="previous month"> Previous</a></td>
    <td colspan="5" align="CENTER" valign="TOP" width="71.4%" class="titlesubw">
		#cName# - #MonthAsString(SelectedMonth)# #SelectedYear#
	</td>
 	<td colspan="1" align="right" width="14.3%" valign="top"><a href="index.cfm?lid=#url.lid#&tid=#form.tid#&calid=#form.jt_calid#&currentdate=#next_month#&gType=#form.jt_gametype#" class="linkw" onMouseover="ddrivetip('Go to #DateFormat(next_month, "mmmm, yyyy")#','yellow','150');" onMouseout="hideddrivetip();">Next <img src="/wsimages/right_arrow_yellow.gif" width="9" height="15" border="0" alt="next month"></a></td>
</CFOUTPUT></tr>
<cfoutput>
<TR bgcolor="0000CC" bordercolor="silver">
</cfoutput>
 	<th width="14.3%" align="CENTER" class="smallw">Sunday</TH>
    <th width="14.3%" align="CENTER" class="smallw">Monday</TH>
	<th width="14.3%" align="CENTER" class="smallw">Tuesday</TH>
	<th width="14.3%" align="CENTER" class="smallw">Wednesday</TH>
	<th width="14.3%" align="CENTER" class="smallw">Thursday</TH>
	<th width="14.3%" align="CENTER" class="smallw">Friday</TH>
	<th width="14.3%" align="CENTER" class="smallw">Saturday</TH>
</TR>

<cfinclude template="calrow.cfm">

</TABLE>
</center>
<cfinclude template="#rootdir#ssi/footer.htm">
</body>
</html>