<cfset rootDir = "../">
<cfparam name="form.lid" default="1">
<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateSection">
	<cfquery name="UpdateMenuSection" datasource="#memberDSN#">
		Update sl_general_purpose
		Set Value_1 = '#form.u_cat#',
			Value_2 = '#form.u_display#',
			Value_3 = '#form.u_longname#',
			Value_5 = #form.u_menudisplay#,
			Value_6 = #form.u_hpdisplay#
		Where name = 'MenuSection' and AssocID = #application.aid# and value_1 = '#url.cat#'
	</cfquery>
	<cfif form.u_cat NEQ url.cat>
		<cfquery name="UpdatePages" datasource="#memberDSN#">
			Update sl_news
			Set category = '#u_cat#'
			Where AssocID = #application.aid# and category = '#url.cat#'
		</cfquery>
	</cfif>
	<cfset done = 1>
<cfelseif action EQ "addSection">
	<!--- Get Last Menu Section Order and Add 1 --->
	<cfquery name="GetOrder" datasource="#memberDSN#" maxrows="1">
		Select Max(value_4) as lastorder
		From sl_general_purpose
		Where name = 'MenuSection' and 
					AssocID = #application.aid#
	</cfquery>
	<cfif IsNumeric(GetOrder.lastorder)>
		<cfset nextOrder = #GetOrder.lastorder# + 1>
	<cfelse>
		<cfset nextOrder = 1>
	</cfif>
	<!--- Insert New Menu Section --->
	<cfquery name="AddMenuSection" datasource="#memberDSN#">
		Insert Into sl_general_purpose (AssocID, Name, Value_1, Value_2, Value_3, Value_4, Value_5, Value_6)
		Values(#application.aid#, 'MenuSection', '#form.u_cat#', '#form.u_display#', '#form.u_longname#', '#nextOrder#',
				#form.u_menudisplay#, #form.u_hpdisplay#)
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "deleteSection">
	<cfquery name="DeleteMenuSection" datasource="#memberDSN#">
		Delete From sl_general_purpose
		where  name = 'MenuSection' and AssocID = #application.aid# and value_1 = '#url.cat#'
	</cfquery>
	<cfset done = 1>
</cfif>
	
<cfif ParameterExists(url.cat) AND Not done>
	<cfquery name="GetSection" datasource="#memberDSN#" maxrows="1">
		Select *
		From sl_general_purpose
		Where name = 'MenuSection' and 
					AssocID = #application.aid# and
					value_1 = '#url.cat#'
	</cfquery>
	<!--- Check if season has any Divisions.  If so, you can't delete --->
	<cfquery name="CheckPages" datasource="#memberDSN#">
		Select newsID
		From sl_news
		Where category = '#url.cat#'
	</cfquery>
	<cfset form.u_cat = "#GetSection.Value_1#">
	<cfset form.u_display = "#GetSection.Value_2#">
	<cfset form.u_longname = "#GetSection.Value_3#">
	<cfset form.u_order = "#GetSection.Value_4#">
	<cfset form.u_menudisplay = "#GetSection.Value_5#">
	<cfset form.u_hpdisplay = "#GetSection.Value_6#">
	<cfset form.action = "updateSection">
<cfelse>
	<cfset form.u_cat = "">
	<cfset form.u_display = "">
	<cfset form.u_longname = "">
	<cfset form.action = "addSection">
	<cfset form.u_order = "0">
	<cfset form.u_menudisplay = "1">
	<cfset form.u_hpdisplay = "1">
	<cfset url.cat = "">
</cfif>

<cfset pageTitle = "#application.sl_name# - Menu Section Edit">
<html>
<head>
	<cfinclude template="../ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Menu Section?"))
			{
				document.forms(0).action.value = "deleteSection";
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
	<cfset onloadattr = "document.forms(0).u_cat.focus();">
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#</cfoutput><br>
		Edit Season
	</td>
</tr>
<tr><td align="center">
	<cfform action="sectionedit.cfm?cat=#url.cat#" method="post">
	<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
	<input type="hidden" name="u_order" value="<cfoutput>#form.u_order#</cfoutput>">
	<table cellpadding="2" cellspacing="0">
	<tr><td valign="top" align="center">
		<table border="1" cellspacing="0" cellpadding="3">
			<tr><td>
			<table cellpadding="2" cellspacing="0">
				<tr>
					<td class="smallb">*Section Code: </td>
					<td><cfinput name="u_cat" type="text" value="#form.u_cat#" required="yes" message="Section Code is required." class="small"></td>
				</tr>
				<tr>
					<td class="smallb">*Menu Display: </td>
					<td><cfinput name="u_display" type="text" value="#form.u_display#" required="yes" message="Menu Display is required." class="small"></td>
				</tr>
				<tr>
					<td class="smallb">*Long Name: </td>
					<td><cfinput name="u_longname" type="text" value="#form.u_longname#" required="yes" message="Long Name is required." class="small"></td>
				</tr>
				<tr>
					<td class="smallb">Display on Menu: </td>
					<td>
						<select name="u_menudisplay" class="small">
							<option value="1"<cfif form.u_menudisplay EQ 1> SELECTED</cfif>>Yes</option>
							<option value="0"<cfif form.u_menudisplay EQ 0> SELECTED</cfif>>No</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">Display on Homepage: </td>
					<td>
						<select name="u_hpdisplay" class="small">
							<option value="1"<cfif form.u_hpdisplay EQ 1> SELECTED</cfif>>Yes</option>
							<option value="0"<cfif form.u_hpdisplay EQ 0> SELECTED</cfif>>No</option>
						</select>
					</td>
				</tr>
				<tr><td colspan="2" align="center">
				</td></tr>
			</table>
			</td></tr>
		</table>
	</td></tr>
	<tr><td align="center">
		<cfif form.action EQ "updateSection">
			<input type="submit" name="update" value="Update" class="small">
			<cfif CheckPages.RecordCount EQ 0>
			<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
			</cfif>
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
