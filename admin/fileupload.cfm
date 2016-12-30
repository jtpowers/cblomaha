<cfparam name="form.filetype" default="files">
<cfset rootDir = "../">
<cfparam name="form.action" default="">
<cfparam name="form.filename" default="">

<cfif form.filetype EQ "evfiles">
	<cfset fileDIR = "#leagueDir#\files\#form.filetype#">
	<cfset fileDestination = "files\#form.filetype#">
<cfelse>
	<cfset fileDIR = "#leagueDir#\#form.filetype#\#application.aid#">
	<cfset fileDestination = "#form.filetype#\#application.aid#">
</cfif>

<cfif isDefined("form.upload")>
	<cffile action="upload"
			destination="#fileDIR#"
			filefield="filename" 
	        nameconflict="overwrite"> 
<cfelseif form.action EQ "deletefile">
	<cffile action="delete" file="#fileDIR#\#form.dFile#"> 
</cfif>

<cfdirectory action="list" directory="#fileDIR#" name="filelist">

<cfset pageTitle = "#application.sl_name# - File Upload">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#pageTitle#</cfoutput></title>
<cfinclude template="#rootDir#ssi/webscript.htm">
	<script language="javascript">
		function verify(filename)
		{
			if (confirm("Are you sure you want to delete " + filename + " ?"))
			{
				document.forms(0).action.value = "deletefile";
				document.forms(0).dFile.value = filename;
				document.forms(0).submit();
			} 
			else
			{
			}
		}	
	</script>
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="#rootdir#ssi/header.htm">

<cfinclude template="sl_header.cfm">
<table>
<tr>
	<td class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
</tr>
<form action="fileupload.cfm" method="post" enctype="multipart/form-data">
<input type="hidden" name="action" value="">
<input type="hidden" name="dFile" value="">
<tr>
	<td valign="top">
		<table border="1" cellspacing="0" cellpadding="3" width="100%">
		<tr><td>
			<table border="0" cellspacing="0" cellpadding="3" width="100%">
			<tr>
				<td class="smallb">File Type:</td>
				<td>
					<select name="filetype" class="small" onChange="submit();">
					<option value="files"<cfif form.filetype EQ "files"> selected</cfif>>FILES - documents, handouts</option>
					<option value="images"<cfif form.filetype EQ "images"> selected</cfif>>IMAGES - logos, graphics, cliparts</option>
					<option value="evfiles"<cfif form.filetype EQ "evfiles"> selected</cfif>>Sports Event Files</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="smallb">File:</td>
				<td>
					<input name="filename" type="file" class="small" size="50">
				</td>
			</tr>
			<tr>
				<td class="small" align="center" colspan="2">
					<input type="submit" value="Upload" name="upload" class="small"><br>
				</td>
			</tr>
			</table>
		</td></tr>
		</table>
	</td>
</tr>
<tr>
	<td valign="top">
		<table border="1" cellspacing="0" cellpadding="3" width="100%">
		<tr bgcolor="#0033FF">
			<td class="titlesmw">Name</td><td class="titlesmw">Size</td><td class="titlesmw">Date</td><td class="titlesmw">&nbsp;</td>
		</tr>
		<cfoutput query="filelist">
		<cfif type EQ "File">
			<tr>
				<td>
					<a href="#rootdir##fileDestination#/#filelist.name#" target="_blank" class="linksm">#filelist.name#</a>
				</td>
				<td class="small">
					#filelist.size#
				</td>
				<td class="small">
					#filelist.datelastmodified#
				</td>
				<td>
					<input type="button" name="delete" value="Delete" class="small" onClick="verify('#filelist.name#');">
				</td>
			</tr>
		</cfif>
		</cfoutput>
		</table>
	</td>
</tr>
</form>
</table>
</td></TR>
</TABLE>
<br><br>

</body>
</html>
