<cfparam name="url.format" default="pdf">


<cfdocument format="#url.format#" margintop=".5" marginbottom=".25" marginright=".25" marginleft=".25" orientation="landscape" unit="in" backgroundvisible="yes" overwrite="no" fontembed="yes">

<cfinclude template="scoresheet_bb.cfm">

</cfdocument>

