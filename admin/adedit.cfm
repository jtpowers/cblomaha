<cfset rootDir = "../">
<cfparam name="form.lid" default="1">
<cfparam name="action" default="">
<cfset done = 0>

<cfquery name="getLeagues" datasource="#memberDSN#">
	Select *
	From sl_league
	Where associd = #application.aid#
</cfquery>

<cfif action EQ "updateAd">
	<cfset photo = "">
	<cfif form.u_image GT "">
		<cf_p1autoresize imagepath="#leagueDir#\ads\" maxsize="160" filefield="u_image" nameconflict="makeunique">
	</cfif>
	<cfquery name="UpdateAd" datasource="#memberDSN#">
		Update sl_advertiser
		Set 	AdName = '#form.u_name#', 
				AdLink = <cfif form.u_link GT "">'http://#REPLACE(form.u_link,"http://","")#'<cfelse>NULL</cfif>, 
				<cfif photo GT "">AdImage = '#photo#',</cfif>
				AdPriority = <cfif u_priority GT "">#u_priority#<cfelse>NULL</cfif>
		Where AdID = #url.adid#
	</cfquery>
	<cfoutput query="getLeagues">
		<cfset adPEval = "form.u_priority#LeagueID#">
		<cfset adP = Evaluate(adPEval)>
		<cfquery name="UpdateAdLeague" datasource="#memberDSN#">
			Update sl_advertiser_league
			Set 	AdPriority = <cfif adP GT "">#adP#<cfelse>NULL</cfif>
			Where AdID = #url.adid# and LeagueID = #LeagueID#
		</cfquery>
	</cfoutput>
	<cfset done = 1>
<cfelseif action EQ "addAd">
	<cfset photo = "">
	<cfif form.u_image GT "">
		<cf_p1autoresize imagepath="#leagueDir#\ads\" maxsize="160" filefield="u_image" nameconflict="makeunique">
	</cfif>
	<!--- Insert New Advertiser --->
	<cfquery name="AddAd" datasource="#memberDSN#">
		Insert Into sl_advertiser (AdName, AdLink, AdImage, AdPriority)
		Values('#form.u_name#', 
				<cfif form.u_link GT "">'http://#REPLACE(form.u_link,"http://","")#'<cfelse>NULL</cfif>, 
				<cfif photo GT "">'#photo#'<cfelse>NULL</cfif>, 
				<cfif u_priority GT "">#u_priority#<cfelse>NULL</cfif>)
	</cfquery>
	<cfquery name="UpdateAd" datasource="#memberDSN#">
		Update sl_advertiser
		Set 	AdDisplayCount = 0
	</cfquery>
	<!--- Get New Advertiser --->
	<cfquery name="AddAd" datasource="#memberDSN#">
		Select Max(AdID) as newAdID
		From sl_advertiser
	</cfquery>
	<cfoutput query="getLeagues">
		<cfset adPEval = "form.u_priority#LeagueID#">
		<cfset adP = Evaluate(adPEval)>
		<cfquery name="UpdateAdLeague" datasource="#memberDSN#">
			Insert Into sl_advertiser_league (AdID, LeagueID, AdPriority)
			Values (#AddAd.newAdID#, #LeagueID#, <cfif adP GT "">#adP#<cfelse>NULL</cfif>)
		</cfquery>
	</cfoutput>
	<cfquery name="UpdateAdLeague" datasource="#memberDSN#">
		Update sl_advertiser_league
		Set AdDisplayCount = 0
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "deleteAd">
	<cfquery name="DeleteAdLeague" datasource="#memberDSN#">
		Delete From sl_advertiser_league
		where  AdID = '#url.adid#'
	</cfquery>
	<cfquery name="DeleteAd" datasource="#memberDSN#">
		Delete From sl_advertiser
		where  AdID = '#url.adid#'
	</cfquery>
	<cfset done = 1>
</cfif>
	
<cfif ParameterExists(url.adid) AND Not done>
	<cfquery name="GetAd" datasource="#memberDSN#" maxrows="1">
		Select *
		From sl_advertiser
		Where AdID = '#url.adid#'
	</cfquery>
	<cfset form.u_name = "#GetAd.AdName#">
	<cfset form.u_link = "#REPLACE(GetAd.AdLink,"http://","")#">
	<cfset form.u_image = "#GetAd.AdImage#">
	<cfset form.u_priority = "#GetAd.AdPriority#">
	<cfset form.action = "updateAd">
<cfelse>
	<cfset form.u_name = "">
	<cfset form.u_link = "">
	<cfset form.u_image = "">
	<cfset form.u_priority = "">
	<cfset url.adid = "">
	<cfset form.action = "addAd">
</cfif>

<cfset pageTitle = "#application.sl_name# - Advertiser Edit">
<html>
<head>
	<cfinclude template="../ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Advertiser?"))
			{
				document.forms(0).action.value = "deleteAd";
				document.forms(0).submit();
			} 
			else
			{
			
			}
		}	
		
		function closeRefresh() {
		  if (window.opener && !window.opener.closed)
		  {
			window.opener.history.go(0);
			window.close();
		  }
		}
	</script>
</head>

<cfif done>
	<cfset onloadattr = "closeRefresh();">
<cfelse>
	<cfset onloadattr = "document.forms(0).u_name.focus();">
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#</cfoutput><br>
		Edit Advertiser
	</td>
</tr>
<tr><td align="center">
	<cfform action="adedit.cfm?adid=#url.adid#" method="post" enctype="multipart/form-data">
	<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
	<table cellpadding="2" cellspacing="0">
	<tr><td valign="top" align="center">
		<table border="1" cellspacing="0" cellpadding="3">
			<tr><td>
			<table cellpadding="2" cellspacing="0">
				<tr>
					<td class="smallb">*Advertiser Name: </td>
					<td><cfinput name="u_name" type="text" value="#form.u_name#" required="yes" message="Advertiser Name is required." class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Link: </td>
					<td><span  class="smallb">http://</span><input type="text" name="u_link" value="<cfoutput>#form.u_link#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb" valign="top">Banner: </td>
					<td valign="top">
						<input type="file" name="u_image" class="small"><br><br>
						<cfif form.u_image GT ""><img src="<cfoutput>#rootdir#ads/#form.u_image#</cfoutput>"></cfif>
					</td>
				</tr>
				<tr><td colspan="2" align="center">
				</td></tr>
			</table>
			</td>
			<td valign="top">
			<table cellpadding="2" cellspacing="0">
				<tr>
					<td class="smallb" colspan="2" align="center">Priority For Each Site<br>(1 Being the Highest)</td>
				</tr>
				<tr>
					<td class="smallb">MAA Main Site</td>
					<td class="small">
						<select name="u_priority" class="small">
							<cfloop from="1" to="5" index="pc">
							<cfoutput>
							<option value="#pc#"<cfif form.u_priority EQ pc> SELECTED</cfif>>#pc#</option>
							</cfoutput>
							</cfloop>
							<option value=""<cfif form.u_priority EQ ""> SELECTED</cfif>>Don't Display</option>
						</select>
					</td>
				</tr>
				<cfif url.adid GT "">
					<cfquery name="GetAdLeagues" datasource="#memberDSN#">
						Select al.*, l.leaguename
						From sl_advertiser_league al, sl_league l
						Where AdID = #url.adid# and l.leagueid = al.leagueid
					</cfquery>
					<cfoutput query="GetAdLeagues">
					<tr>
						<td class="smallb">#leaguename#:</td>
						<td class="small">
							<select name="u_priority#leagueid#" class="small">
								<cfloop from="1" to="5" index="pc">
								<option value="#pc#"<cfif adpriority EQ pc> SELECTED</cfif>>#pc#</option>
								</cfloop>
								<option value=""<cfif adpriority EQ ""> SELECTED</cfif>>Don't Display</option>
							</select>
						</td>
					</tr>
					</cfoutput>
				<cfelse>
					<cfoutput query="getLeagues">
					<tr>
						<td class="smallb">#leaguename#:</td>
						<td class="small">
							<select name="u_priority#leagueid#" class="small">
								<cfloop from="1" to="5" index="pc">
								<option value="#pc#">#pc#</option>
								</cfloop>
								<option value="" SELECTED>Don't Display</option>
							</select>
						</td>
					</tr>
					</cfoutput>
				</cfif>
				</table>
			</td>
			</tr>
		</table>
	</td></tr>
	<tr><td align="center">
		<cfif form.action EQ "updateAd">
			<input type="submit" name="update" value="Update" class="small">
			<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
		<cfelse>
			<input type="submit" name="add" value="Add" class="small">
		</cfif>
		<input type="reset" class="small"><br>
		<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
	</td></tr>
	<tr> 
		<td class="small">* Required Field</td>
	</tr>
	</table>
	</cfform>
</td></TR>
</TABLE>
<br><br>

</body>
</html>
