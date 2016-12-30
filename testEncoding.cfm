<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Untitled Document</title>
</head>

<body>
<cfset str = "powers">

<cfset strA = encodethis(str)>
<cfset strB = encodethis(str,1)>
<cfset strC = encrypt(str,"powersone","CFMX_COMPAT","HEX")>

<cfoutput>
#str#<br>
#strA#<br>
#strB#<br>
#strC#<br>
</cfoutput>

</body>
</html>

