<cfparam name="form.filetype" default="files">
<cfparam name="form.action" default="">

<!--- <cfquery name="getFiles" datasource="#memberDSN#">
	Select FileName, FileSize, FileDate, FileID
	From sl_file
	Where leagueid = #application.lid# and FileType = '#form.filetype#'
	Order by FileName
</cfquery> --->

<cfset rootDir = "../">
<cfset pageTitle = "#application.sl_name# - File Upload">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="keywords" content="<cfoutput>#application.sl_keywords#</cfoutput>">
<META NAME=description CONTENT="<cfoutput>#application.sl_desc#</cfoutput>">
<title><cfoutput>#pageTitle#</cfoutput></title>
<cfinclude template="../ssi/webscript.htm">
	<script language="javascript">
		function verify(filename,fileid)
		{
			if (confirm("Are you sure you want to delete " + filename + " ?"))
			{
				<cfoutput>
				window.open("#application.sl_url#/admin/uploadfile.cfm?fid=" + fileid + "&action=deletefile","deleteFile","width=400,height=300,resizable=1,scrollbars=0,status=1,toolbar=0,location=0,menubar=0");
				</cfoutput>
			} 
		}	
	</script>
</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">
<cfinclude template="../ssi/header.htm">

<cfinclude template="sl_header.cfm">
<table>
<tr>
	<td class="titlemain" align="center"><cfoutput>#pageTitle#</cfoutput><br><br></td>
</tr>
<form action="fileupload.cfm" method="post">
<tr>
	<td valign="top">
		<table border="0" cellspacing="0" cellpadding="3">
		<tr>
			<td class="smallb">File Type:</td>
			<td>
				<select name="filetype" class="small" onChange="submit();">
				<option value="files"<cfif form.filetype EQ "files"> selected</cfif>>FILES - documents, handouts</option>
				<option value="images"<cfif form.filetype EQ "images"> selected</cfif>>IMAGES - logos, graphics, cliparts</option>
				</select>
			</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td valign="top">
		<cfoutput>
		<a href="javascript:fPopWindow('#application.sl_url#/admin/uploadfile.cfm?filetype=#form.filetype#', 'custom','500','200','toolbar: 0','status: 1','location: 0','menubar: 0','scrollbars: 0')" class="linksm">Upload File/Image</a>
		</cfoutput>
		<table border="1" cellspacing="0" cellpadding="3" width="100%">
		<tr bgcolor="<cfoutput>#application.sl_tbcolor#</cfoutput>">
			<td class="titlesmw">Name</td><td class="titlesmw">Size</td><td class="titlesmw">Date</td><td class="titlesmw">&nbsp;</td>
		</tr>
		<cfset rColor = "#application.sl_arcolor#">
		<cfoutput query="getFiles">
			<cfif rColor EQ "FFFFFF">
				<cfset rColor = "#application.sl_arcolor#">
			<cfelse>
				<cfset rColor = "FFFFFF">
			</cfif>
			<tr bgcolor="#rColor#">
				<td>
					<a href="#application.sl_url#/#form.filetype#/#FileName#" target="_blank" class="small">#FileName#</a>
				</td>
				<td class="small">
					#FileSize#
				</td>
				<td class="small">
					#DateFormat(FileDate, "mm/dd/yyyy")# #TimeFormat(FileDate, "hh:mm:ss tt")#
				</td>
				<td>
					<input type="button" name="delete" value="Delete" class="small" onClick="verify('#FileName#','#FileID#');">
				</td>
			</tr>
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
