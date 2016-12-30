<!DOCTYPE html>

<cfobject component="cfc.association" name="assocObj">

<cfset getLeagues = assocObj.getLeagues()>

<cfif getLeagues.RecordCount LT 2>
	<cflocation url="leagues/index.cfm?lid=#getLeagues.leagueid#">
</cfif>

<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

  <title>Bootstrap</title>
</head>
<body>
  
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>