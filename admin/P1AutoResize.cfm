<!---<cf_photo> by Steve Goodman 1999------>

<!----Attributes------>
<!---
imagepath="[photopath]"                   %Server path to the image directory
filefield="[filefield]"                   %Name of form field where photo is uploaded
thumbpath="[thumbnailpath]"	/optional	  %Server path to the thumbnail directory	
prefix="[prefix]"		/optional		  %Prefix added to the thumbnail. Required if thumbsize is specified.
thumbsize="[number]"	/optional 		  %Width of the generated thumbnail
maxsize="[number]"		/optional		  %Maximum width of image 
nameconflict="[text]"	/optional         %Action to take if uploaded image's name is already on the server 
--->


<!---Error Checking----->
<cfset doit = "Yes">
<cfset message = " ">

<cfif IsDefined("attributes.imagepath") is "no">
	<cfset doit = "no">
	<cfset message = "You need to specify an image path in the cf_photo attributes!">  
</cfif>

<cfif IsDefined("attributes.filefield") is "no">
	<cfset doit = "no">
	<cfset message = "You need to specify a file field in the cf_photo attributes!"> 
</cfif>

<cfif IsDefined("attributes.prefix")>
	<cfif IsDefined("attributes.thumbsize") is "no">
		<cfset doit = "no">
		<cfset message = "You need to specify a thumbnail size if you specify a thumbnail prefix in cf_photo!">
	</cfif>
	<cfset prefix = attributes.prefix>
<cfelse>
	<cfset prefix = "sm_">	
</cfif>

<cfif NOT IsDefined("attributes.nameconflict")>
	<cfset attributes.nameconflict = "makeunique">
</cfif>

<cfif #doit# is "yes">

	<!---Upload the image and set it to a variable--->
	<cffile action="upload"
			destination="#attributes.imagepath#"
			filefield="#attributes.filefield#" 
	        nameconflict="#attributes.nameconflict#"> 
	
	<cfset photo = "#file.serverFile#">

	<cfif #parameterexists(attributes.thumbsize)#>	
		<!---Generate Thumbnail--->
		<cfx_image action="iml"
			file="#attributes.imagepath#\#photo#"
			commands="
				resize #attributes.thumbsize#
				write #attributes.thumbpath#\#attributes.prefix##photo#
			">
	<cfelse>
	<!---Don't generate thumbnail--->		
	</cfif>
	
	<cfif #parameterexists(attributes.maxsize)#>		
		<!---Resize Image if too large----->
		<cfx_image action="iml"
			file="#attributes.imagepath#\#photo#"
			commands="
				resizeif #attributes.maxsize#,-1,#attributes.maxsize#
				write #attributes.imagepath#\#photo#
			">		
	<cfelse>
	<!---Don't check for image size--->		
	</cfif>
	
	<cfset Caller.photo = #photo#>
	<cfif IsDefined("attributes.prefix")>
		<cfset Caller.thumbnail = '#attributes.prefix##photo#'>
	</cfif>
<cfelse>
	<cfoutput>#message#</cfoutput>
	<cfabort>
</cfif>