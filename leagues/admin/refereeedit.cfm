<cfset rootDir = "../../">
<cfparam name="action" default="">

<cfset done = 0>
<cfset error = 0>
<cfset errormsg = "">
<cfparam name="url.rid" default="">

<cfif action EQ "updateref">
	<cfif LEN(form.u_rname) GT 0>
		<cfquery name="UpdateRef" datasource="#memberDSN#">
			Update sl_referee
			Set RefName = '#u_rname#',
				PhoneNbr = <cfif LEN(u_phone) GT 0>'#u_phone#'<cfelse>NULL</cfif>,
				CellPhone = <cfif LEN(u_cphone) GT 0>'#u_cphone#'<cfelse>NULL</cfif>,
				Address = <cfif LEN(u_addr) GT 0>'#u_addr#'<cfelse>NULL</cfif>,
				City = <cfif LEN(u_city) GT 0>'#u_city#'<cfelse>NULL</cfif>,
				State = <cfif LEN(u_state) GT 0>'#u_state#'<cfelse>NULL</cfif>,
				ZipCode = <cfif LEN(u_zip) GT 0>'#u_zip#'<cfelse>NULL</cfif>,
				Email = <cfif LEN(u_email) GT 0>'#u_email#'<cfelse>NULL</cfif>
			Where RefID = #url.rid#
		</cfquery>
		<cfset done = 1>
	<cfelse>
		<cfset error = 1>
		<cfset errormsg = "Referee must have a name.">
	</cfif>
<cfelseif action EQ "addref">
	<cfif LEN(form.u_rname) GT 0>
		<cfquery name="AddRef" datasource="#memberDSN#">
			Insert Into sl_referee (RefName, PhoneNbr, CellPhone, Address, City, State, ZipCode, Email, LeagueID)
			Values('#u_rname#', 
					<cfif LEN(u_phone) GT 0>'#u_phone#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_cphone) GT 0>'#u_cphone#'<cfelse>NULL</cfif>,
					<cfif LEN(u_addr) GT 0>'#u_addr#'<cfelse>NULL</cfif>, 
					<cfif LEN(u_city) GT 0>'#u_city#'<cfelse>NULL</cfif>,
					<cfif LEN(u_state) GT 0>'#u_state#'<cfelse>NULL</cfif>,
					<cfif LEN(u_zip) GT 0>'#u_zip#'<cfelse>NULL</cfif>,
					<cfif LEN(u_email) GT 0>'#u_email#'<cfelse>NULL</cfif>, 
					#url.lid#)
		</cfquery>
		<cfset done = 1>
	<cfelse>
		<cfset error = 1>
		<cfset errormsg = "Referee must have a name.">
	</cfif>
<cfelseif action EQ "deleteRef">
	<cfquery name="DeleteMain" datasource="#memberDSN#">
		Delete From sl_referee
		where  RefID = #url.rid#
	</cfquery>
	<cfset done = 1>
</cfif>
<cfif Not error>
	<cfif url.rid GT "" AND action NEQ "deleteRef">
		<cfquery name="GetRef" datasource="#memberDSN#">
			SELECT *
			FROM sl_referee
			Where RefID = #url.rid#
		</cfquery>
		<cfset form.u_rname = "#GetRef.RefName#">
		<cfset form.u_phone = "#GetRef.PhoneNbr#">
		<cfset form.u_cphone = "#GetRef.CellPhone#">
		<cfset form.u_addr = "#GetRef.Address#">
		<cfset form.u_state = "#GetRef.State#">
		<cfset form.u_city = "#GetRef.City#">
		<cfset form.u_zip = "#GetRef.ZipCode#">
		<cfset form.u_email = "#GetRef.Email#">
		<cfset form.action = "updateRef">
		<cfquery name="GetRefGames" datasource="#memberDSN#">
			SELECT Count(*) as gameCount
			FROM sl_game
			Where RefID_1 = #url.rid# OR RefID_2 = #url.rid#
		</cfquery>
	<cfelse>
		<cfset url.rid = "">
		<cfset form.u_rname = "">
		<cfset form.u_phone = "">
		<cfset form.u_cphone = "">
		<cfset form.u_addr = "">
		<cfset form.u_state = "">
		<cfset form.u_city = "">
		<cfset form.u_zip = "">
		<cfset form.u_email = "">
		<cfset form.action = "addRef">
	</cfif>
</cfif>

<cfset pageTitle = "#application.sl_name# - Umpire/Referee Edit">

<html>
<head>
	<cfinclude template="#rootDir#ssi/webscript.htm">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<script language="javascript">
		function verify()
		{
			if (confirm("Are you sure you want to delete this Umpire/Referee?"))
			{
				document.forms(0).action.value = "deleteRef";
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
	<cfset onloadattr = "document.forms(0).u_rname.focus();">
</cfif>
<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" onLoad="<cfoutput>#onloadattr#</cfoutput>">
<cfif Not done>
<table cellpadding="5" cellspacing="0" width="100%">
<tr bgcolor="<cfoutput>#application.sl_hdcolor#</cfoutput>">
	<td class="titlesubw" align="center">
		<cfoutput>#application.sl_name#<br>
		#application.sl_leaguename#</cfoutput><br>
		Edit Umpire/Referee
	</td>
</tr>
<tr>
	<td class="smallr" align="center"><cfoutput>#errormsg#</cfoutput>&nbsp;</td>
</tr>
<tr><td align="center">
<cfoutput>
	<cfform action="refereeedit.cfm?lid=#url.lid#&rid=#url.rid#" method="post">
	<input type="hidden" name="action" value="#form.action#">
	<table>
		<tr><td valign="top" align="center" class="smallb">
			<table border="1" cellspacing="0" cellpadding="3">
				<tr><td>
				<table cellpadding="2" cellspacing="0">
					<tr>
						<td class="smallb">*Name: </td>
						<td><cfinput name="u_rname" type="text" value="#form.u_rname#" size="35" required="yes" message="Name is required." class="small"></td>
					</tr>
					<tr>
						<td class="smallb">Phone: </td>
						<td><input type="text" name="u_phone" value="#form.u_phone#" class="small" size="15"></td>
					</tr>
					<tr>
					<tr>
						<td class="smallb">Cell Phone: </td>
						<td><input type="text" name="u_cphone" value="#form.u_cphone#" class="small" size="15"></td>
					</tr>
						<td class="smallb">Address: </td>
						<td><input type="text" name="u_addr" size="35" value="#form.u_addr#" class="small"></td>
					</tr>
					</tr>
						<td class="smallb">City: </td>
						<td><input type="text" name="u_city" value="#form.u_city#" class="small"></td>
					</tr>
					</tr>
						<td class="smallb">State: </td>
						<td>
							<input type="text" name="u_state" size="2" value="#form.u_state#" class="small">
							<span class="smallb">Zip Code:</span>
							<input type="text" name="u_zip" size="10" value="#form.u_zip#" class="small">
						</td>
					</tr>
					<tr>
						<td class="smallb">Email: </td>
						<td><input type="text" name="u_email" size="35" value="#form.u_email#" class="small"></td>
					</tr>
				</table>
				</td></tr>
			</table>
		</td>	</tr>
		<tr><td align="center">
			<cfif form.action EQ "updateRef">
				<input type="submit" name="Update" value="Update" class="small">
				<cfif url.rid GT "" AND GetRefGames.gameCount EQ 0>
					<input type="button" name="delete" value="Delete" class="small" onClick="verify();">
				</cfif>
			<cfelse>
				<input type="Submit" name="Add" value="Add" class="small">
			</cfif>
			<input type="reset" class="small"><br>
			<input type="button" name="close" value="Close Window" class="small" onClick="window.close();">
		</td></tr>
		<tr> 
			<td class="small">* Required Field</td>
		</tr>
	</table>
	</cfform>
</cfoutput>
</td></tr>
</table>
</cfif>
</body>
</html>
