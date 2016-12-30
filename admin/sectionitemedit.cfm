<cfparam name="action" default="">
<cfset done = 0>

<cfif action EQ "updateNews">
	<cfset newOrder = 0>
	<cfif form.s_display EQ 1 and form.s_sort EQ "">
		<cfquery name="GetNextSort" datasource="#memberDSN#">
			SELECT Max(SortOrder) as lastsort
			FROM sl_news
			Where Category = '#form.s_cat#' and DisplayFlag = 1
		</cfquery>
		<cfif IsNumeric(GetNextSort.lastsort)>
			<cfset newOrder = GetNextSort.lastsort + 1> 
		<cfelse>
			<cfset newOrder = 1> 
		</cfif>
	</cfif>
	
	<cfif LEN(s_attach) GT 0><cfset nType = "F">
	<cfelseif LEN(s_url) GT 0><cfset nType = "L">
	<cfelse><cfset nType = "P">
	</cfif>
	
	<cfquery name="UpdateNews" datasource="#memberDSN#">
		Update sl_news
		Set Title = '#s_title#',
			ShortTitle = <cfif LEN(s_stitle) GT 0>'#s_stitle#'<cfelse>NULL</cfif>,
			Body = '#body#',
			Category = '#s_cat#',
			<cfif form.s_display EQ 0>
				SortOrder = NULL,
			<cfelseif newOrder GT 0>
				SortOrder = #newOrder#,
			</cfif>
			Attachment =  <cfif LEN(s_attach) GT 0>'#s_attach#'<cfelse>NULL</cfif>,
			AttachmentTitle = <cfif LEN(s_attachtitle) GT 0>'#s_attachtitle#'<cfelse>NULL</cfif>,
			DisplayFlag = #s_display#,
			NewsType = '#nType#',
			NewsURL = <cfif LEN(s_url) GT 0>'http://#s_url#'<cfelse>NULL</cfif>, 
			<cfif s_display EQ 0>SortOrder =  NULL,</cfif>
			LinkTarget = <cfif LEN(s_target) GT 0>'#s_target#'<cfelse>NULL</cfif>
		Where NewsID = #url.nid#
	</cfquery>
	<cfset done = 1>
<cfelseif action EQ "addNews">
	<cfquery name="GetNextSort" datasource="#memberDSN#">
		SELECT Max(SortOrder) as lastsort
		FROM sl_news
		Where Category = '#form.s_cat#' and DisplayFlag = 1
	</cfquery>
	<cfif IsNumeric(GetNextSort.lastsort)>
		<cfset newOrder = GetNextSort.lastsort + 1> 
	<cfelse>
		<cfset newOrder = 1> 
	</cfif>
	
	<cfif LEN(s_attach) GT 0><cfset nType = "F">
	<cfelseif LEN(s_url) GT 0><cfset nType = "L">
	<cfelse><cfset nType = "P">
	</cfif>

	<cfquery name="AddNews" datasource="#memberDSN#">
		Insert Into sl_news (Title, ShortTitle, CreateDate, Body, AssocID, Category, SortOrder, Attachment, AttachmentTitle, DisplayFlag, NewsType, NewsURL, LinkTarget)
		Values('#s_title#', 
				<cfif LEN(s_stitle) GT 0>'#s_stitle#'<cfelse>NULL</cfif>,
				'#DateFormat(Now(), "yyyy-mm-dd")#', 
				'#body#', 
				#application.aid#, 
				'#form.s_cat#', 
				#newOrder#, 
				<cfif LEN(s_attach) GT 0>'#s_attach#'<cfelse>NULL</cfif>, 
				<cfif LEN(s_attachtitle) GT 0>'#s_attachtitle#'<cfelse>NULL</cfif>,
				#s_display#,
				'#nType#',
				<cfif LEN(s_url) GT 0>'http://#s_url#'<cfelse>NULL</cfif>,
				<cfif LEN(s_target) GT 0>'#s_target#'<cfelse>NULL</cfif>)
	</cfquery>
	<cfquery name="GetLastNews" datasource="#memberDSN#">
		SELECT Max(NewsID) as lastid
		FROM sl_news
		Where Category = '#form.s_cat#'
	</cfquery>
	<cfset url.nid = GetLastNews.lastid>
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
	Where name = 'MenuSection' and AssocID = #application.aid#
	Order by Value_4
</cfquery>
<cfparam name="url.cat" default="#getCategories.Value_1#">
<cfparam name="url.nid" default="">

<cfdirectory action="list" directory="#leagueDir#\files" name="filelist">

<cfif nid GT "" AND action NEQ "deleteNews">
	<cfquery name="GetNewsItem" datasource="#memberDSN#">
		SELECT *
		FROM sl_news
		Where NewsID = #url.nid#
	</cfquery>
	<cfset form.s_title = "#GetNewsItem.Title#"> 
	<cfset form.s_stitle = "#GetNewsItem.ShortTitle#"> 
	<cfset form.body = "#GetNewsItem.Body#"> 
	<cfset form.s_cat = "#GetNewsItem.Category#"> 
	<cfset form.s_sort = "#GetNewsItem.SortOrder#"> 
	<cfset form.s_attach = "#GetNewsItem.Attachment#"> 
	<cfset form.s_attachtitle = "#GetNewsItem.AttachmentTitle#"> 
	<cfset form.s_display = "#GetNewsItem.DisplayFlag#"> 
	<cfset form.s_url = "#Replace(GetNewsItem.NewsURL, 'http://', '', 'ALL')#"> 
	<cfset form.s_target = "#GetNewsItem.LinkTarget#"> 
	<cfset form.action = "updateNews">
<cfelse>
	<cfset form.s_title = ""> 
	<cfset form.s_stitle = ""> 
	<cfset form.body = ""> 
	<cfset form.s_cat = "#url.cat#"> 
	<cfset form.s_sort = 0> 
	<cfset form.s_attach = ""> 
	<cfset form.s_attachtitle = ""> 
	<cfset form.s_display = ""> 
	<cfset form.s_url = ""> 
	<cfset form.s_target = "_blank"> 
	<cfset form.action = "addNews">
</cfif>

<cfset rootDir = "../">
<cfset pageTitle = "#application.sl_name# - Website Section Page Edit">
<html>
<head>
	<cfinclude template="../ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Page?"))
			{
				document.forms(0).action.value = "deleteNews";
				document.forms(0).submit();
			} 
			else
			{
			
			}
		}	
		
		function ValidateForm(){
			var title=document.NewsForm.s_title
			var shorttitle=document.NewsForm.s_stitle
		  
			if ((title.value==null)||(title.value=="")){
				alert("Please Enter a Title.")
				title.focus()
				return false
			}
			if ((shorttitle.value==null)||(shorttitle.value=="")){
				alert("Please Enter a Short Title")
				shorttitle.focus()
				return false
			}
			return true
		}
	</script>
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#</cfoutput><br>
		Website Section Page Edit
	</td>
</tr>
<tr><td align="center">
	<table><tr><td valign="top" align="center">
		<cfform action="sectionitemedit.cfm?nid=#url.nid#" method="post" name="NewsForm">
		<input type="hidden" name="action" value="<cfoutput>#form.action#</cfoutput>">
		<input type="hidden" name="s_sort" value="<cfoutput>#form.s_sort#</cfoutput>">
		<table border="1" cellspacing="0" cellpadding="3">
			<tr><td>
			<table cellpadding="2" cellspacing="0">
				<tr>
					<td class="smallb">*Title: </td>
					<td><cfinput name="s_title" type="text" value="#form.s_title#" size="50" required="yes" message="Title is required." class="small"></td>
					<td class="smallb">Display:</td>
					<td>
						<select name="s_display" class="small">
							<option value="1"<cfif form.s_display EQ 1> SELECTED</cfif>>Yes</option>
							<option value="0"<cfif form.s_display EQ 0> SELECTED</cfif>>No</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb">*Short Title: </td>
					<td><cfinput name="s_stitle" type="text" value="#form.s_stitle#" maxlength="25" required="yes" message="Short Title is required." class="small"></td>
					<td class="smallb">Section: </td>
					<td>
						<select name="s_cat" class="small">
						<cfoutput query="getCategories">
							<option value="#Value_1#"<cfif Value_1 EQ form.s_cat> SELECTED</cfif>>#Value_3#</option>
						</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td class="smallb" valign="top" colspan="4" align="center" bgcolor="#FFFF00">** Enter Content to Webpage **</td>
				</tr>
				<tr>
					<td class="smallb" valign="top" colspan="4">Body: </td>
				</tr>
				<tr>
					<td colspan="4">
					<cfset prBody = "#form.body#">
					<cfinclude template="#rootdir#ssi/editor2.cfm">
					</td>
				</tr>
				<tr>
					<td class="smallb" colspan="4" align="center" bgcolor="#FFFF00">OR<br>** Create Link to a File You have Uploaded **</td>
				</tr>
				<tr>
					<td class="smallb">File: </td>
					<td>
						<select name="s_attach" class="small">
							<option value=""<cfif #form.s_attach# EQ ""> selected</cfif>>None</option>
						<cfoutput query="filelist">
						<cfif type EQ "File">
							<option value="#filelist.name#"<cfif #form.s_attach# EQ #filelist.name#> selected</cfif>>#filelist.name#</option>
						</cfif>
						</cfoutput>
						</select>
					<td class="smallb">File Title: </td>
					<td><input type="text" name="s_attachtitle" value="<cfoutput>#form.s_attachtitle#</cfoutput>" class="small"></td>
				</tr>
				<tr>
					<td class="smallb" colspan="4" align="center" bgcolor="#FFFF00">OR<br>** Create Link to a Different Webpage **</td>
				</tr>
				<tr>
					<td class="smallb">Link URL: </td>
					<td> 
						http://<input type="text" name="s_url" value="<cfoutput>#form.s_url#</cfoutput>" class="small" size=50>
					<td class="smallb">Target: </td>
					<td>
						<select name="s_target" class="small">
							<option value="_self"<cfif #form.s_target# EQ "_self"> selected</cfif>>Open in this window</option>
							<option value="_blank"<cfif #form.s_target# EQ "_blank"> selected</cfif>>Open in new window</option>
							<option value="_parent"<cfif #form.s_target# EQ "_self"> selected</cfif>>Open in parent window</option>
						</select>
</td>
				</tr>
			</table>
			</td></tr>
		</table>
		<cfif form.action EQ "addNews">
			<input type="submit" name="add" value="Add" class="small" onClick="return ValidateForm();">
		<cfelse>
			<input type="submit" name="update" value="Update" class="small" onClick="return ValidateForm();">
			<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
		</cfif>
			<input type="reset" class="small"><br>
			<input type="button" name="close" value="Close Window" class="small" onClick="window.opener.history.go(0);window.close();">
		<br><div class="small" align="left">*Required Field</div>
		</cfform>
	</td></tr></table>
</td></TR>
</TABLE>
<br><br>

</body>
</html>
