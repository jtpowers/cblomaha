<cfoutput>
<cfif  gIndex GT 1><hr style="page-break-before:always;" /></cfif>
<table border="0" cellpadding="3" cellspacing="0" width="100%">
<tr><td colspan="3">
<center>
	<span style="font-size:18px;font-weight:bold">#getGames.leaguename[gIndex]# Score Sheet</span><br>
	<span style="font-size:16px;font-weight:bold">Divsion:&nbsp;&nbsp;#getGames.gender[gIndex]# #getGames.divname[gIndex]#</span><br>
</center>
</td></tr>
<tr>
	<td width="33%">
		<span style="font-size:14px;font-weight:bold">Played At</span><span style="font-size:14px">:  #getGames.shortname[gIndex]# - #getGames.courtname[gIndex]#</span>&nbsp;
	</td>
	<td width="33%" align="center"><span style="font-size:14px;font-weight:bold">
		Date/Time:</span><span style="font-size:14px">  #DateFormat(getGames.GameDate[gIndex], "MM/DD/YYYY")# - 
		#TimeFormat(getGames.gametime[gIndex], "h:mm tt")#</span>
	</td>
	<td width="34%" align="right"><span style="font-size:14px;font-weight:bold">Referees:</span><span style="font-size:14px"> ______________________</span></td>
</tr>
<tr>
	<td align="left" colspan="2"><span style="font-size:14px;font-weight:bold">
		Final Score:</span><span style="font-size:14px"> #getGames.vteam[gIndex]# ______  
		#getGames.hteam[gIndex]# ______</span>
	</td>
	<td align="right"><span style="font-size:14px"> ______________________</span></td>
</tr>
<tr><td colspan="3">

<table border="1" cellpadding="2" cellspacing="0" width="100%" bordercolor="##000000">
<tr>
	<td colspan="3" nowrap style="min-width:150px"><span style="font-size:12px">Visitors:<br><b>#getGames.vteam[gIndex]#</b></span></td>
	<td colspan="11">
	<span style="font-size:12px">
	<cfloop from="1" to="80" index="sCount">
		#sCount#&nbsp;
	</cfloop>
	</span>
	</td>
</tr>
<tr>
	<td colspan="3" nowrap style="min-width:150px"><span style="font-size:12px">Home:<br><b>#getGames.hteam[gIndex]#</b></span></td>
	<td colspan="11">
	<span style="font-size:12px">
	<cfloop from="1" to="80" index="sCount">
		#sCount#&nbsp;
	</cfloop>
	</span>
	</td>
</tr>
<tr>
	<td colspan="3" align="right" bgcolor = "CCCCCC"><span style="font-size:14px;font-weight:bold">Alternate Possession&nbsp;</span></td>
	<td colspan="11"><span style="font-size:14px">
		<cfloop from="1" to="18" index="apIndex">&nbsp;&nbsp;H&nbsp;&nbsp;V</cfloop>
		</span>
	</td>
</tr>
<tr>
	<td colspan="7" width="50%">
		<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td><span style="font-size:16px;font-weight:bold">#getGames.vteam[gIndex]#</span></td>
		<cfif getGames.gametos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.gametos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		<cfif getGames.game30tos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">30 sec TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.game30tos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		<cfif getGames.periodtos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">1st Half TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.periodtos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
			<td><span style="font-size:12px;font-weight:bold">2nd Half TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.periodtos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		<cfif getGames.period30tos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">1st Half 30 sec TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.period30tos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
			<td><span style="font-size:12px;font-weight:bold">2nd Half 30 sec TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.period30tos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		<cfif getGames.overtimetos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">OT</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.overtimetos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		</tr>
		</table>
	</td>
	<td colspan="7" width="50%">
		<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td><span style="font-size:16px;font-weight:bold">#getGames.hteam[gIndex]#</span></td>
		<cfif getGames.gametos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.gametos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		<cfif getGames.game30tos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">30 sec TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.game30tos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		<cfif getGames.periodtos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">1st Half TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.periodtos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
			<td><span style="font-size:12px;font-weight:bold">2nd Half TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.periodtos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		<cfif getGames.period30tos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">1st Half 30 sec TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.period30tos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
			<td><span style="font-size:12px;font-weight:bold">2nd Half 30 sec TOs</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.period30tos[gIndex]#" index="toindex">
				&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		<cfif getGames.overtimetos[gIndex] GT 0>
			<td><span style="font-size:12px;font-weight:bold">OT</span><span style="font-size:12px">
			 <cfloop from="1" to="#getGames.overtimetos[gIndex]#" index="toindex">
			 	&nbsp;&nbsp;#toindex#
			</cfloop>
			</span>
			</td>
		</cfif>
		</tr>
		</table>
	</td>
</tr>
<tr bgcolor = "CCCCCC">
	<td width="2%" align="center"><span style="font-size:12px;font-weight:bold">##</span></td>
	<td width="10%" align="center"><span style="font-size:12px;font-weight:bold">Player's Name</span></td>
	<td width="5%" align="center"><span style="font-size:12px;font-weight:bold">Fouls</span></td>
	<td width="13%" align="center"><span style="font-size:12px;font-weight:bold">First Half</span></td>
	<td width="13%" align="center"><span style="font-size:12px;font-weight:bold">Second Half</span></td>
	<td width="4%" align="center"><span style="font-size:12px;font-weight:bold">OT</span></td>
	<td width="3%" align="center"><span style="font-size:12px;font-weight:bold">Totals</span></td>
	<td width="2%" align="center"><span style="font-size:12px;font-weight:bold">##</span></td>
	<td width="10%" align="center"><span style="font-size:12px;font-weight:bold">Player's Name</span></td>
	<td width="5%" align="center"><span style="font-size:12px;font-weight:bold">Fouls</span></td>
	<td width="13%" align="center"><span style="font-size:12px;font-weight:bold">First Half</span></td>
	<td width="13%" align="center"><span style="font-size:12px;font-weight:bold">Second Half</span></td>
	<td width="4%" align="center"><span style="font-size:12px;font-weight:bold">OT</span></td>
	<td width="3%" align="center"><span style="font-size:12px;font-weight:bold">Totals</span></td>
</tr>
<cfset bgcolor = "FFFFFF">
<cfset h_alt = 0>
<cfset v_alt = 0>
<cfloop from="1" to="15" index="playerrow">
<tr bgcolor="#bgcolor#">
	<cfif getVTeam.RecordCount GTE (playerrow - v_alt)>
		<cfif getVTeam.alternate[playerrow] EQ 1 AND v_alt EQ 0>
			<td><span style="font-size:10px">&nbsp;</span></td>
			<td><span style="font-size:10px">Alternates</span></td>
			<cfset v_alt = 1>
		<cfelse>
			<td><span style="font-size:10px"><cfif getVTeam.jerseynbr[playerrow - v_alt] LT 999>#getVTeam.jerseynbr[playerrow - v_alt]#<cfelse>&nbsp;</cfif></span></td>
			<td><span style="font-size:10px">#getVTeam.playername[playerrow - v_alt]#</span></td>
		</cfif>
	<cfelse>
		<td><span style="font-size:14px">&nbsp;</span></td>
		<td><span style="font-size:14px">&nbsp;</span></td>
	</cfif>
	<td nowrap><span style="font-size:12px">1 2 3 4 5</span></td>
	<td><span style="font-size:14px">&nbsp;</span></td>
	<td><span style="font-size:14px">&nbsp;</span></td>
	<td><span style="font-size:14px">&nbsp;</span></td>
	<td><span style="font-size:14px">&nbsp;</span></td>
	<cfif getHTeam.RecordCount GTE (playerrow - h_alt)>
		<cfif getHTeam.alternate[playerrow] EQ 1 AND h_alt EQ 0>
			<td><span style="font-size:10px">&nbsp;</span></td>
			<td><span style="font-size:10px">Alternates</span></td>
			<cfset h_alt = 1>
		<cfelse>
			<td><span style="font-size:10px"><cfif getHTeam.jerseynbr[playerrow - h_alt] LT 999>#getHTeam.jerseynbr[playerrow - h_alt]#<cfelse>&nbsp;</cfif></span></td>
			<td><span style="font-size:10px">#getHTeam.playername[playerrow - h_alt]#</span></td>
		</cfif>
	<cfelse>
		<td><span style="font-size:14px">&nbsp;</span></td>
		<td><span style="font-size:14px">&nbsp;</span></td>
	</cfif>
	<td nowrap><span style="font-size:12px">1 2 3 4 5</span></td>
	<td><span style="font-size:14px">&nbsp;</span></td>
	<td><span style="font-size:14px">&nbsp;</span></td>
	<td><span style="font-size:14px">&nbsp;</span></td>
	<td><span style="font-size:14px">&nbsp;</span></td>
</tr>
<cfif bgcolor EQ "DDDDDD"><cfset bgcolor="FFFFFF"><cfelse><cfset bgcolor = "DDDDDD"></cfif>
</cfloop>
<tr>
	<td colspan="3" align="right"><span style="font-size:12px;font-weight:bold">Totals</span></td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td colspan="3" align="right"><span style="font-size:12px;font-weight:bold">Totals</span></td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td colspan="3" align="right"><span style="font-size:12px;font-weight:bold">Team Fouls</span></td>
	<td align="center"><span style="font-size:12px">1 2 3 4 5 6 7 8 9 10</span></td>
	<td align="center" colspan="2"><span style="font-size:12px">1 2 3 4 5 6 7 8 9 10</span></td>
	<td>&nbsp;</td>
	<td colspan="3" align="right"><span style="font-size:12px;font-weight:bold">Team Fouls</span></td>
	<td align="center"><span style="font-size:12px">1 2 3 4 5 6 7 8 9 10</span></td>
	<td align="center" colspan="2"><span style="font-size:12px">1 2 3 4 5 6 7 8 9 10</span></td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td colspan="3">
		<span style="font-size:12px;font-weight:bold">Technical Fouls</span>&nbsp;&nbsp;
		<span style="font-size:12px">1&nbsp;&nbsp;2&nbsp;&nbsp;3</span>
	</td>
	<td colspan="4">
		<span style="font-size:12px;font-weight:bold">Head Coach:</span>&nbsp;&nbsp;
		<span style="font-size:12px">#getGames.vcoach[gIndex]#</span>
	</td>
	<td colspan="3">
		<span style="font-size:12px;font-weight:bold">Technical Fouls</span>&nbsp;&nbsp;
		<span style="font-size:12px">1&nbsp;&nbsp;2&nbsp;&nbsp;3</span>
	</td>
	<td colspan="4">
		<span style="font-size:12px;font-weight:bold">Head Coach:</span>&nbsp;&nbsp;
		<span style="font-size:12px">#getGames.hcoach[gIndex]#</span>
	</td>
</tr>
<tr>
	<td colspan="3">&nbsp;</td>
	<td colspan="4"><span style="font-size:12px;font-weight:bold">Assistant Coaches:</span>&nbsp;</td>
	<td colspan="3">&nbsp;</td>
	<td colspan="4"><span style="font-size:12px;font-weight:bold">Assistant Coaches:</span>&nbsp;</td>
</tr>
</table>
</td></tr>
<!---<tr><td colspan="3">&nbsp;</td></tr>
<tr><td colspan="3">
<span style="font-size:12px">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Scorer:___________________________________________________________
<br><br><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Timer:____________________________________________________________
</span>
</td></tr>--->
</table>
</cfoutput>