<cfset rootDir = "../../">

<cfobject component="cfc.admin" name="adminObj">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfparam name="form.filetype" default="files">
<cfparam name="form.action" default="">

<cfif isDefined("form.upload")>
	<cffile action="upload"
			destination="#application.leagueDir#\#form.filetype#\#application.aid#\#url.lid#"
			filefield="filename" 
	        nameconflict="overwrite"> 
<cfelseif form.action EQ "deletefile">
	<cffile action="delete" file="#application.leagueDir#\#form.filetype#\#application.aid#\#url.lid#\#form.dFile#"> 
</cfif>

<cfdirectory action="list" directory="#application.leagueDir#\#form.filetype#\#application.aid#\#url.lid#" name="filelist">

<cfset pageTitle = "File Upload">
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

<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league_admin.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<div class="panel">
<div class="panel-heading text-center titlemain"><cfoutput>#pageTitle#</cfoutput></div>
<div class="panel-body">
	<div class="clearfix col-md-3 col-xs-hidden col-sm-hidden"></div>
    <div class="col-xs-12 col-md-6">
<table class="table table-condensed no-border">
<form action="fileupload.cfm?lid=<cfoutput>#url.lid#</cfoutput>" method="post" enctype="multipart/form-data">
<input type="hidden" name="action" value="">
<input type="hidden" name="dFile" value="">
<tr>
	<td valign="top">
		<table class="table table-condensed table-bordered">
		<tr><td>
			<table class="table table-condensed no-border">
			<tr>
				<td class="smallb">File Type:</td>
				<td>
					<select name="filetype" class="small" onChange="submit();">
					<option value="files"<cfif form.filetype EQ "files"> selected</cfif>>FILES - documents, handouts</option>
					<option value="images"<cfif form.filetype EQ "images"> selected</cfif>>IMAGES - logos, graphics, cliparts,</option>
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
					<input type="submit" value="Upload" name="upload" class="small">
				</td>
			</tr>
			</table>
		</td></tr>
		</table>
	</td>
</tr>
<tr>
	<td valign="top">
		<table class="table table-bordered table-striped table-condensed">
		<thead>
		<tr bgcolor="#0033FF">
			<th class="text-center titlesmw">Name</td>
			<th class="text-center titlesmw">Size</td>
			<th class="text-center titlesmw">Date</td>
			<th class="text-center titlesmw">&nbsp;</td>
		</tr>
		</thead>
		<tbody>
		<cfoutput query="filelist">
			<tr>
				<td>
					<a href="#rootdir##form.filetype#/#application.aid#/#url.lid#/#filelist.name#" target="_blank" class="small">#filelist.name#</a>
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
		</cfoutput>
		</tbody>
		</table>
	</td>
</tr>
</form>
</table>
    </div>
	<div class="clearfix col-md-3 col-xs-hidden col-sm-hidden"></div>
</div></div>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
