<!---
NAME:         	cf_securityaccess
FILE:	        securityaccess.cfm
VERSION:	  	1.0
CREATED:	 	07/26/2007
LAST MODIFIED:	

AUTHOR:      	Joseph Powers

DESCRIPTION:  	This is a custom CFML tag returns a true or false on whether the current user
						has access to update this team.

								It returns 1 for true, and 0  for false..

INPUT:			coachid - Coach ID  ** Required **
					teamid - Team ID  ** Required **
					dsn - Datasource  ** Required **
					level - Required Security Level  ** Default is 9 **

OUTPUT:		useraccesslevel - Users Access Level
					message

INSTALLATION	To make all Cold Fusion application be able to use custom tags
				like this one, cf_localtime.cfm should be copied to the
				CUSTOM TAGS directory of Cold Fusion, which is defaulted to
				"C:\CFUSION\CUSTOM TAGS\"

EXAMPLE			<cf_securityaccess userid="1" aid= "1" lid="1" dsn="datasource">
--->

<cfset doit = "yes">
<cfif IsDefined("attributes.userid") is "no">
	<cfset doit = "no">
	<cfset message = "You need to specify userid the cf_securityaccess attributes!">  
</cfif>
<cfif IsDefined("attributes.aid") is "no">
	<cfset doit = "no">
	<cfset message = "You need to specify aid the cf_securityaccess attributes!">  
</cfif>
<cfif IsDefined("attributes.dsn") is "no">
	<cfset doit = "no">
	<cfset message = "You need to specify dsn in the cf_securityaccess attributes!">  
</cfif>
<cfparam name="attributes.lid" default="0">

<cfif doit EQ "yes">
<cftry>
	<cfquery name="GetAccessInfo" datasource="#attributes.dsn#">
		Select accesslevel
		From sl_user_access
		Where userID = #attributes.userid# 
			and associd = #attributes.aid#
		<cfif attributes.lid EQ 0>
			and leagueid is null
		<cfelse>
			and leagueid = #attributes.lid#
		</cfif>
	</cfquery>
	<!--- Coach Not Found --->
	<cfif GetAccessInfo.RecordCount EQ 0>
		<cfset caller.useraccesslevel = 0>
		<cfset caller.accessname = "No Access">
		<cfset caller.message = "User Not Found">
	<!--- Security Level Too Low --->
	<cfelse>
		<cfset caller.useraccesslevel = #GetAccessInfo.AccessLevel#>
		<cfif GetAccessInfo.AccessLevel EQ 0>
			<cfset caller.accessname = "No Access">
		<cfelseif GetAccessInfo.AccessLevel EQ 7>
			<cfset caller.accessname = "League Admin">
		<cfelseif GetAccessInfo.AccessLevel EQ 5>
			<cfset caller.accessname = "Coach">
		<cfelseif GetAccessInfo.AccessLevel EQ 3>
			<cfset caller.accessname = "Menu Section">
		<cfelse>
			<cfset caller.accessname = "Administrator">
		</cfif>
		<cfset caller.message = "">
	</cfif>
<cfcatch>
		<cfset caller.useraccesslevel = 0>
		<cfset caller.accessname = "No Access">
		<cfset caller.message = "Error in Custom Tag">
</cfcatch>
</cftry>
<cfelse>
	<cfset caller.useraccesslevel = 0>
	<cfset caller.accessname = "No Access">
	<cfset caller.message = message>
</cfif>
