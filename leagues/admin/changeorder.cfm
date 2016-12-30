<cftransaction>
<cfif isDefined("url.cat")>
	<cfquery name="GetSection1" datasource="#application.memberDSN#" maxrows="1">
		Select value_4
		From sl_general_purpose
		Where name = '#url.name#' and 
					LeagueID = #url.lid# and
					value_1 = '#url.cat#'
	</cfquery>
	
	<cfif url.dir EQ "up">
		<cfset newOrder1 = #GetSection1.value_4# - 1>
	<cfelseif url.dir EQ "down">
		<cfset newOrder1 = #GetSection1.value_4# + 1>
	</cfif>
	
	<cfquery name="GetSection2" datasource="#application.memberDSN#">
		Select value_1
		From sl_general_purpose
		Where name = '#url.name#' and LeagueID = #url.lid# and value_4 = '#NumberFormat(newOrder1,  "09")#'
	</cfquery>
	<cfquery name="UpdateOrder1" datasource="#application.memberDSN#">
		Update sl_general_purpose
		Set Value_4 = '#NumberFormat(newOrder1,  "09")#'
		Where name = '#url.name#' and LeagueID = #url.lid# and value_1 = '#url.cat#'
	</cfquery>
	<cfquery name="UpdateOrder2" datasource="#application.memberDSN#">
		Update sl_general_purpose
		Set Value_4 = '#NumberFormat(GetSection1.value_4,  "09")#'
		Where name = '#url.name#' and LeagueID = #url.lid# and value_1 = '#GetSection2.value_1#'
	</cfquery>
<cfelseif isDefined("url.nid")>
	<cfquery name="GetNews1" datasource="#application.memberDSN#" maxrows="1">
		Select sortorder, category
		From sl_news
		Where newsid = '#url.nid#'
	</cfquery>
	
	<cfif url.dir EQ "up">
		<cfset newOrder1 = #GetNews1.sortorder# - 1>
	<cfelseif url.dir EQ "down">
		<cfset newOrder1 = #GetNews1.sortorder# + 1>
	</cfif>
	
	<cfquery name="GetNews2" datasource="#application.memberDSN#">
		Select newsid
		From sl_news
		Where category = '#GetNews1.category#' and LeagueID = #url.lid# and sortorder = #newOrder1#
	</cfquery>
	<cfquery name="UpdateOrder1" datasource="#application.memberDSN#">
		Update sl_news
		Set sortorder = '#newOrder1#'
		Where newsid = '#url.nid#'
	</cfquery>
	<cfquery name="UpdateOrder2" datasource="#application.memberDSN#">
		Update sl_news
		Set sortorder = '#GetNews1.sortorder#'
		Where newsid = '#GetNews2.newsid#'
	</cfquery>
<cfelseif isDefined("url.did")>
	<cfquery name="GetDiv1" datasource="#application.memberDSN#" maxrows="1">
		Select divorder, seasonid
		From sl_division
		Where divid = '#url.did#'
	</cfquery>
	
	<cfif url.dir EQ "up">
		<cfset newOrder1 = #GetDiv1.divorder# - 1>
	<cfelseif url.dir EQ "down">
		<cfset newOrder1 = #GetDiv1.divorder# + 1>
	</cfif>
	
	<cfquery name="GetDiv2" datasource="#application.memberDSN#">
		Select divid
		From sl_division
		Where seasonid = '#GetDiv1.seasonid#' and divorder = #newOrder1#
	</cfquery>
	<cfquery name="UpdateOrder1" datasource="#application.memberDSN#">
		Update sl_division
		Set divorder = '#newOrder1#'
		Where divid = '#url.did#'
	</cfquery>
	<cfquery name="UpdateOrder2" datasource="#application.memberDSN#">
		Update sl_division
		Set divorder = '#GetDiv1.divorder#'
		Where divid = '#GetDiv2.divid#'
	</cfquery>
<cfelseif isDefined("url.calid")>
	<cfquery name="GetCal1" datasource="#application.memberDSN#" maxrows="1">
		Select calorder, calendarid
		From sl_calendar
		Where calendarid = #url.calid#
	</cfquery>
	
	<cfif url.dir EQ "up">
		<cfset newOrder1 = #GetCal1.calorder# - 1>
	<cfelseif url.dir EQ "down">
		<cfset newOrder1 = #GetCal1.calorder# + 1>
	</cfif>
	
	<cfquery name="GetCal2" datasource="#application.memberDSN#">
		Select calendarid
		From sl_calendar
		Where 
			<cfif url.lid GT "">
				leagueid = #url.lid#
			<cfelse>
				leagueid is null and associd = #application.aid#
			</cfif> and calorder = #newOrder1#
	</cfquery>
	<cfquery name="UpdateOrder1" datasource="#application.memberDSN#">
		Update sl_calendar
		Set calorder = #newOrder1#
		Where calendarid = #url.calid#
	</cfquery>
	<cfquery name="UpdateOrder2" datasource="#application.memberDSN#">
		Update sl_calendar
		Set calorder = #GetCal1.calorder#
		Where calendarid = #GetCal2.calendarid#
	</cfquery>
</cfif>
</cftransaction>
<html>
<head>
	<title>Change Order</title>
	<script language="javascript">
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.history.go(0);
			window.close();
		  }
		}
	</script>
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="closeRefresh();">

</body>
</html>
