<cfcookie name="lynxbbsid" expires="now">
<cfparam name="url.lid" default="1">
<cfset rootdir = "../">
<cfobject component="cfc.league" name="leagueObj">
<cfobject component="cfc.association" name="assocObj">

<cfinclude template="#rootdir#ssi/header.cfm">
<cfinclude template="#rootdir#ssi/navbar_league.cfm">
<cfinclude template="#rootdir#ssi/header_league.cfm">

<form id="signinForm">
    <div class="form-group">
        <input type="text" class="form-control" name="username" placeholder="Username" />
    </div>

    <div class="form-group">
        <input type="password" class="form-control" name="password" placeholder="Password" />
    </div>

    <!-- Do NOT use name="submit" or id="submit" for the Submit button -->
    <button type="submit" class="btn btn-default">Sign in</button>
</form>

<script>
$(document).ready(function() {
    $('#signinForm').formValidation({
        framework: 'bootstrap',
        icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            username: {
                validators: {
                    notEmpty: {
                        message: 'The username is required'
                    },
                    stringLength: {
                        min: 6,
                        max: 30,
                        message: 'The username must be more than 6 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z0-9_]+$/,
                        message: 'The username can only consist of alphabetical, number and underscore'
                    }
                }
            },
            password: {
                validators: {
                    notEmpty: {
                        message: 'The password is required'
                    }
                }
            }
        }
    });
});
</script>

<cfinclude template="#rootdir#ssi/footer_league.cfm">
<cfinclude template="#rootdir#ssi/footer.cfm">
