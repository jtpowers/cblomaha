<cfcookie name="lynxbbsid" expires="now">
<cfparam name="url.lid" default="1">
<cfset rootdir = "">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfinclude template="#rootdir#ssi/header.cfm">

<cfif isDefined("form.addButton")>
	<cfset addMember = assocObj.addMember(#form#)>
	<cfset msg = addMember>
<cfelseif isDefined("form.updateButton")>
	<cfset updateMember = assocObj.updateMember(#form#)>
	<cfset msg = updateMember>
<cfelseif isDefined("form.deleteButton")>
	<cfset msg = assocObj.deleteMember(#form.cid#)>
<cfelse>
	<!--- <cfdump var="#form#"> --->
</cfif>

<script>
	alert('<cfoutput>#msg#</cfoutput>');
	window.location.href="index.cfm";
</script>

<cfinclude template="#rootdir#ssi/footer.cfm">
