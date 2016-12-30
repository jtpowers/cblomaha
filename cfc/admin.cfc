<cfcomponent>
    <cffunction name="getSectionsHeader" returntype="query"> 
    	<cfargument name="lid" required="yes" type="numeric" default="1">
    	
 		<cfquery name="qry_getSectionsHDR" datasource="#application.memberDSN#">
			Select *
			From sl_general_purpose
			Where name = 'MenuSection' and LeagueID = #arguments.lid#
			Order by Value_4
		</cfquery>

         <cfreturn qry_getSectionsHDR> 
    </cffunction> 
    
    <cffunction name="getAlerts" returntype="query"> 
    	<cfargument name="lid" required="yes" type="numeric" default="1">
    	
 		<cfquery name="qry_getAlerts" datasource="#application.memberDSN#">
			Select *
			From sl_alert
			Where leagueid = #arguments.lid#
			Order by startdate desc
		</cfquery>

         <cfreturn qry_getAlerts> 
    </cffunction> 
    
</cfcomponent>