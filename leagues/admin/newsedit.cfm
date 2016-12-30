<cfparam name="form.lid" default="1">
<cfparam name="action" default="">
<cfset done = 0>

<cfif isDefined("form.u_lid")>
	<cfset form.lid = form.u_lid>
<cfelseif isDefined("form.a_lid")>
	<cfset form.lid = form.a_lid>
</cfif>

<cfif action EQ "updateNews">
	<cfquery name="UpdateNews" datasource="#memberDSN#">
		Update sl_news
		Set TItle = '#u_title#',
			ShortTitle = <cfif LEN(u_stitle) GT 0>'#u_stitle#'<cfelse>NULL</cfif>,
			Body = '#u_body#',
			Category = '#u_cat#',
			SortOrder = <cfif IsNumeric(u_sort)>#u_sort#<cfelse>0</cfif>,
			Attachment =  <cfif LEN(u_attach) GT 0>'#u_attach#'<cfelse>NULL</cfif>,
			AttachmentTitle = <cfif LEN(u_attachtitle) GT 0>'#u_attachtitle#'<cfelse>NULL</cfif>,
			DisplayFlag = <cfif isDefined(u_display)>1<cfelse>0</cfif>
		Where NewsID = #url.nid#
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "addNews">
	<cfquery name="AddNews" datasource="#memberDSN#">
		Insert Into sl_news (TItle, ShortTitle, CreateDate, Body, LeagueID, Category, SortOrder, Attachment, AttachmentTitle, DisplayFlag)
		Values('#a_title#', 
				<cfif LEN(a_stitle) GT 0>'#a_stitle#'<cfelse>NULL</cfif>,
				'#DateFormat(Now(), "yyyy-mm-dd")#', '#a_body#', #url.lid#, '#a_cat#', 
				<cfif IsNumeric(a_sort)>#a_sort#<cfelse>0</cfif>, 
				<cfif LEN(a_attach) GT 0>'#a_attach#'<cfelse>NULL</cfif>, 
				<cfif LEN(a_attachtitle) GT 0>'#a_attachtitle#'<cfelse>NULL</cfif>,
				<cfif isDefined(a_display)>1<cfelse>0</cfif>)
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "deleteNews">
	<cfquery name="DeleteNews" datasource="#memberDSN#">
		Delete From sl_news
		where  NewsID = #url.nid#
	</cfquery>
	<cfset done = 1>
</cfif>
	
<cfquery name="getCategories" datasource="#memberDSN#">
	Select *
	From sl_general_purpose
	Where name = 'NewsCategory' and LeagueID = #url.lid#
	Order by Value_4
</cfquery>
<cfparam name="url.cat" default="#getCategories.Value_1#">

<cfdirectory action="list" directory="#leagueDir#files" name="filelist">

<cfset rootDir = "../../">
<cfset pageTitle = "Sports League - News Edit">
<html>
<head>
	<cfinclude template="#rootDir#ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this News?"))
			{
				document.forms(0).action.value = "deleteNews";
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

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0"<cfif done> onload="closeRefresh();"</cfif>>
<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#</cfoutput><br>
		Edit News Item
	</td>
</tr>
<tr><td align="center">
	<table><tr><td valign="top" align="center">
		<cfif ParameterExists(nid) AND action NEQ "deleteNews">
			<cfquery name="GetNewsItem" datasource="#memberDSN#">
				SELECT *
				FROM sl_news
				Where NewsID = #url.nid#
			</cfquery>
			<form action="newsedit.cfm?nid=<cfoutput>#url.nid#</cfoutput>" method="post">
			<input type="hidden" name="action" value="updateNews">
			<input type="hidden" name="u_attach" value="">
			<input type="hidden" name="u_attachtitle" value="">
			<table border="1" cellspacing="0" cellpadding="3">
				<tr><td>
				<table cellpadding="2" cellspacing="0">
					<tr>
						<td class="smallb">Title: </td>
						<td colspan="3"><input type="text" name="u_title" value="<cfoutput>#GetNewsItem.Title#</cfoutput>" class="small" size="50"></td>
					</tr>
					<tr>
						<td class="smallb">Short Title: </td>
						<td><input type="text" name="u_stitle" value="<cfoutput>#GetNewsItem.ShortTitle#</cfoutput>" class="small" maxlength="25"></td>
						<td class="smallb">Display: </td>
						<td><input name="u_display" type="checkbox" value="1"<cfif GetNewsItem.DisplayFlag EQ 1> checked></cfif></td>
					</tr>
					<tr>
						<td class="smallb">Category: </td>
						<td>
							<select name="u_cat" class="small">
							<cfoutput query="getCategories">
								<option value="#Value_1#"<cfif Value_1 EQ GetNewsItem.Category> SELECTED</cfif>>#Value_3#</option>
							</cfoutput>
							</select>
						</td>
						<td class="smallb">File Title: </td>
						<td><input type="text" name="u_attachtitle" value="<cfoutput>#GetNewsItem.AttachmentTitle#</cfoutput>" class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Sort Order: </td>
						<td><input type="text" name="u_sort" value="<cfoutput>#GetNewsItem.SortOrder#</cfoutput>" class="small"></td>
						<td class="smallb">File: </td>
						<td><!---<input type="text" name="u_attach" value="" class="small">--->
							<select name="u_attach" class="small">
								<option value=""<cfif #GetNewsItem.Attachment# EQ ""> selected</cfif>>None</option>
							<cfoutput query="filelist">
								<option value="#filelist.name#"<cfif #GetNewsItem.Attachment# EQ #filelist.name#> selected</cfif>>#filelist.name#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="smallb" valign="top">Body: </td>
						<td colspan="3"><textarea class="small" name="u_body" cols="90" rows="20"><cfoutput>#GetNewsItem.Body#</cfoutput></textarea></td>
					</tr>
					<tr><td colspan="4" align="center">
							<input type="submit" name="update" value="Update" class="small">
							<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
							<input type="reset" class="small">
					</td></tr>
				</table>
				</td></tr>
			</table>
			</form>
		<cfelse>
			<form action="newsedit.cfm?cat=<cfoutput>#url.cat#</cfoutput>" method="post">
			<input type="hidden" name="action" value="addNews">
			<input type="hidden" name="a_attach" value="">
			<input type="hidden" name="a_attachtitle" value="">
			<table border="1" cellspacing="0" cellpadding="3">
				<tr><td>
					<table cellpadding="2" cellspacing="0">
					<tr>
						<td class="smallb">Title: </td>
						<td colspan="3"><input type="text" name="a_title" value="" class="small" size="50"></td>
					</tr>
					<tr>
						<td class="smallb">Short Title: </td>
						<td><input type="text" name="a_stitle" value="" class="small" maxlength="25"></td>
						<td class="smallb">Display: </td>
						<td><input name="a_display" type="checkbox" value="1" checked></td>
					</tr>
					<tr>
						<td class="smallb">Category: </td>
						<td>
							<select name="a_cat" class="small">
							<cfoutput query="getCategories">
								<option value="#Value_1#"<cfif Value_1 EQ url.cat> SELECTED</cfif>>#Value_3#</option>
							</cfoutput>
							</select>
						</td>
						<td class="smallb">File Title: </td>
						<td><input type="text" name="a_attachtitle" value=""></td>
					</tr>
					<tr>
						<td class="smallb">Sort Order: </td>
						<td><input type="text" name="a_sort" value="0" class="small"></td>
						<td class="smallb">File: </td>
						<td>
							<select name="a_attach" class="small">
								<option value="" selected>None</option>
							<cfoutput query="filelist">
								<option value="#filelist.name#">#filelist.name#</option>
							</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="smallb" valign="top">Body: </td>
						<td colspan="3"><textarea class="small" name="a_body" cols="90" rows="20"></textarea></td>
					</tr>
						<tr><td colspan="4" align="center"><input type="submit" name="add" value="Add" class="small"></td></tr>
					</table>
				</td></tr>
			</table>
			</form>
		</cfif>
		<a href="javascript:window.close();" class="small">Close Window</a>
	</td></tr></table>
</td></TR>
</TABLE>
<br><br>

</body>
</html>
