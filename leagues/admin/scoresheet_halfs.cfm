<cfoutput>
<table border="0" cellpadding="3" cellspacing="0" width="100%"<cfif  gIndex GT 1> style="page-break-before:always"</cfif>>
<tr><td colspan="3">
<center>
	<font style="#titlemain#">1#getGames.leaguename[gIndex]# Score Sheet</font><br>
	<font style="#titlesub#">Divsion:&nbsp;&nbsp;#getGames.gender[gIndex]# #getGames.divname[gIndex]#</font><br><br>
</center>
</td></tr>
<tr>
	<td width="33%">
		<font style="#smallb#">Played At</font><font style="#small#">:  #getGames.shortname[gIndex]# - #getGames.courtname[gIndex]#</font>&nbsp;
	</td>
	<td width="33%" align="center"><font style="#smallb#">
		Date/Time:</font><font style="#small#">  #DateFormat(getGames.GameDate[gIndex], "MM/DD/YYYY")# - 
		#TimeFormat(getGames.gametime[gIndex], "h:mm tt")#</font>
	</td>
	<td width="34%" align="right"><font style="#smallb#">Referees:</font><font style="#small#"> ______________________</font></td>
</tr>
<tr>
	<td align="left" colspan="2"><font style="#smallb#">
		Final Score:</font><font style="#small#"> #getGames.vteam[gIndex]# ______  
		#getGames.hteam[gIndex]# ______</font>
	</td>
	<td align="right"><font style="#small#"> ______________________</font></td>
</tr>
<tr><td colspan="3">

<table border="1" cellpadding="2" cellspacing="0" width="100%" bordercolor="##000000">
<tr>
	<td colspan="3" nowrap><font style="#xsmall#">Visitors:<br><b>#getGames.vteam[gIndex]#</b></font></td>
	<td colspan="11">
	<font style="#xsmall#">
	<cfloop from="1" to="100" index="sCount">
		#sCount#&nbsp;
	</cfloop>
	</font>
	</td>
</tr>
<tr>
	<td colspan="3" nowrap><font style="#xsmall#">Home:<br><b>#getGames.hteam[gIndex]#</b></font></td>
	<td colspan="11">
	<font style="#xsmall#">
	<cfloop from="1" to="100" index="sCount">
		#sCount#&nbsp;
	</cfloop>
	</font>
	</td>
</tr>
<tr>
	<td colspan="3" align="right" bgcolor = "CCCCCC"><font style="#smallb#">Alternate Possession&nbsp;</font></td>
	<td colspan="11"><font style="#small#">
		<cfloop from="1" to="18" index="apIndex">&nbsp;&nbsp;H&nbsp;&nbsp;V</cfloop>
		</font>
	</td>
</tr>
<tr>
	<td colspan="7" width="50%">
		<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td><font style="#titlesub#">#getGames.vteam[gIndex]#</font></td>
		<cfif getGames.gametos[gIndex] GT 0>
			<td><font style="#xsmallb#">TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.gametos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		<cfif getGames.game30tos[gIndex] GT 0>
			<td><font style="#xsmallb#">30 sec TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.game30tos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		<cfif getGames.periodtos[gIndex] GT 0>
			<td><font style="#xsmallb#">1st Half TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.periodtos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
			<td><font style="#xsmallb#">2nd Half TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.periodtos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		<cfif getGames.period30tos[gIndex] GT 0>
			<td><font style="#xsmallb#">1st Half 30 sec TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.period30tos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
			<td><font style="#xsmallb#">2nd Half 30 sec TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.period30tos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		<cfif getGames.overtimetos[gIndex] GT 0>
			<td><font style="#xsmallb#">OT</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.overtimetos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		</tr>
		</table>
	</td>
	<td colspan="7" width="50%">
		<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td><font style="#titlesub#">#getGames.hteam[gIndex]#</font></td>
		<cfif getGames.gametos[gIndex] GT 0>
			<td><font style="#xsmallb#">TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.gametos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		<cfif getGames.game30tos[gIndex] GT 0>
			<td><font style="#xsmallb#">30 sec TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.game30tos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		<cfif getGames.periodtos[gIndex] GT 0>
			<td><font style="#xsmallb#">1st Half TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.periodtos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
			<td><font style="#xsmallb#">2nd Half TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.periodtos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		<cfif getGames.period30tos[gIndex] GT 0>
			<td><font style="#xsmallb#">1st Half 30 sec TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.period30tos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
			<td><font style="#xsmallb#">2nd Half 30 sec TOs</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.period30tos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		<cfif getGames.overtimetos[gIndex] GT 0>
			<td><font style="#xsmallb#">OT</font><font style="#xsmall#">
			 <cfloop from="1" to="#getGames.overtimetos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</font>
			</td>
		</cfif>
		</tr>
		</table>
	</td>
</tr>
<tr bgcolor = "CCCCCC">
	<td width="2%" align="center"><font style="#xsmallb#">##</font></td>
	<td width="10%" align="center"><font style="#xsmallb#">Player's Name</font></td>
	<td width="5%" align="center"><font style="#xsmallb#">Fouls</font></td>
	<td width="13%" align="center"><font style="#xsmallb#">First Half</font></td>
	<td width="13%" align="center"><font style="#xsmallb#">Second Half</font></td>
	<td width="4%" align="center"><font style="#xsmallb#">OT</font></td>
	<td width="3%" align="center"><font style="#xsmallb#">Totals</font></td>
	<td width="2%" align="center"><font style="#xsmallb#">##</font></td>
	<td width="10%" align="center"><font style="#xsmallb#">Player's Name</font></td>
	<td width="5%" align="center"><font style="#xsmallb#">Fouls</font></td>
	<td width="13%" align="center"><font style="#xsmallb#">First Half</font></td>
	<td width="13%" align="center"><font style="#xsmallb#">Second Half</font></td>
	<td width="4%" align="center"><font style="#xsmallb#">OT</font></td>
	<td width="3%" align="center"><font style="#xsmallb#">Totals</font></td>
</tr>
<cfset bgcolor = "FFFFFF">
<cfset h_alt = 0>
<cfset v_alt = 0>
<cfloop from="1" to="15" index="playerrow">
<tr bgcolor="#bgcolor#">
	<cfif getVTeam.RecordCount GTE (playerrow - v_alt)>
		<cfif getVTeam.alternate[playerrow] EQ 1 AND v_alt EQ 0>
			<td><font style="#small#">&nbsp;</font></td>
			<td><font style="#xsmall#">Alternates</font></td>
			<cfset v_alt = 1>
		<cfelse>
			<td><font style="#xsmall#"><cfif getVTeam.jerseynbr[playerrow - v_alt] LT 999>#getVTeam.jerseynbr[playerrow - v_alt]#<cfelse>&nbsp;</cfif></font></td>
			<td><font style="#xsmall#">#getVTeam.playername[playerrow - v_alt]#</font></td>
		</cfif>
	<cfelse>
		<td><font style="#small#">&nbsp;</font></td>
		<td><font style="#small#">&nbsp;</font></td>
	</cfif>
	<td nowrap><font style="#xsmall#">1 2 3 4 5</font></td>
	<td><font style="#small#">&nbsp;</font></td>
	<td><font style="#small#">&nbsp;</font></td>
	<td><font style="#small#">&nbsp;</font></td>
	<td><font style="#small#">&nbsp;</font></td>
	<cfif getHTeam.RecordCount GTE (playerrow - h_alt)>
		<cfif getHTeam.alternate[playerrow] EQ 1 AND h_alt EQ 0>
			<td><font style="#small#">&nbsp;</font></td>
			<td><font style="#xsmall#">Alternates</font></td>
			<cfset h_alt = 1>
		<cfelse>
			<td><font style="#xsmall#"><cfif getHTeam.jerseynbr[playerrow - h_alt] LT 999>#getHTeam.jerseynbr[playerrow - h_alt]#<cfelse>&nbsp;</cfif></font></td>
			<td><font style="#xsmall#">#getHTeam.playername[playerrow - h_alt]#</font></td>
		</cfif>
	<cfelse>
		<td><font style="#small#">&nbsp;</font></td>
		<td><font style="#small#">&nbsp;</font></td>
	</cfif>
	<td nowrap><font style="#xsmall#">1 2 3 4 5</font></td>
	<td><font style="#small#">&nbsp;</font></td>
	<td><font style="#small#">&nbsp;</font></td>
	<td><font style="#small#">&nbsp;</font></td>
	<td><font style="#small#">&nbsp;</font></td>
</tr>
<cfif bgcolor EQ "DDDDDD"><cfset bgcolor="FFFFFF"><cfelse><cfset bgcolor = "DDDDDD"></cfif>
</cfloop>
<tr>
	<td colspan="3" align="right"><font style="#xsmallb#">Totals</font></td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td colspan="3" align="right"><font style="#xsmallb#">Totals</font></td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td colspan="3" align="right"><font style="#xsmallb#">Team Fouls</font></td>
	<td align="center"><font style="#xsmall#">1 2 3 4 5 6 7 8 9 10</font></td>
	<td align="center" colspan="2"><font style="#xsmall#">1 2 3 4 5 6 7 8 9 10</font></td>
	<td>&nbsp;</td>
	<td colspan="3" align="right"><font style="#xsmallb#">Team Fouls</font></td>
	<td align="center"><font style="#xsmall#">1 2 3 4 5 6 7 8 9 10</font></td>
	<td align="center" colspan="2"><font style="#xsmall#">1 2 3 4 5 6 7 8 9 10</font></td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td colspan="3">
		<font style="#xsmallb#">Technical Fouls</font>&nbsp;&nbsp;
		<font style="#xsmall#">1&nbsp;&nbsp;2&nbsp;&nbsp;3</font>
	</td>
	<td colspan="4">
		<font style="#xsmallb#">Head Coach:</font>&nbsp;&nbsp;
		<font style="#xsmall#">#getGames.vcoach[gIndex]#</font>
	</td>
	<td colspan="3">
		<font style="#xsmallb#">Technical Fouls</font>&nbsp;&nbsp;
		<font style="#xsmall#">1&nbsp;&nbsp;2&nbsp;&nbsp;3</font>
	</td>
	<td colspan="4">
		<font style="#xsmallb#">Head Coach:</font>&nbsp;&nbsp;
		<font style="#xsmall#">#getGames.hcoach[gIndex]#</font>
	</td>
</tr>
<tr>
	<td colspan="3">&nbsp;</td>
	<td colspan="4"><font style="#xsmallb#">Assistant Coaches:</font>&nbsp;</td>
	<td colspan="3">&nbsp;</td>
	<td colspan="4"><font style="#xsmallb#">Assistant Coaches:</font>&nbsp;</td>
</tr>
</table>
</td></tr>
<tr><td colspan="3">&nbsp;</td></tr>
<tr><td colspan="3">
<font style="#xsmall#">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Scorer:___________________________________________________________
<br><br><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Timer:____________________________________________________________
</font>
</td></tr></table>
</cfoutput>