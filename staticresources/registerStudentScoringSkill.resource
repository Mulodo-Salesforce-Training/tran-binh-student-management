function getRemoteAccount () {
    var active         = document.getElementById('active').checked;
    var skill          = document.getElementById('skill').value;
    var points         = document.getElementById('points').value;

    Visualforce.remoting.Manager.invokeAction (
        'SM_RegisterStudentScoringSkill.toRegister',
            active, 
            skill, 
            points,
        function ( result, event ) {
            if ( event.status ) {
                if ( event.result == skill ) {
                    document.getElementById( "responseResult" ).innerHTML = "Create success Candidates with skill: " + skill;
                } else {
                    document.getElementById( "responseResult" ).innerHTML = event.result + "<br/>";
                }
            }
        }, {
            escape: true
        }
    );
}

function getRemoteStudent () {
    var firstName     = document.getElementById('firstName').value;
    var lastName      = document.getElementById('lastName').value;
    var birthday      = document.getElementById('birthday').value;
    var phone         = document.getElementById('phone').value;
    var email         = document.getElementById('email').value;
    var street        = document.getElementById('street').value;
    var city          = document.getElementById('city').value;
    var stateProvince = document.getElementById('stateProvince').value;
    var zipPostalCode = document.getElementById('zipPostalCode').value;
    var country       = document.getElementById('country').value;
    var skills        = document.getElementById('skills').value;
    var level         = document.getElementById('level').value;
    var status        = document.getElementById('status').value;

    Visualforce.remoting.Manager.invokeAction (
        'SM_RegisterStudent.toRegister',
            firstName, 
            lastName, 
            birthday,
            phone,
            email,
            street,
            city,
            stateProvince,
            zipPostalCode,
            country,
            skills,
            level,
            status,
        
        function ( result, event ) {
            if ( event.status ) {
                if ( event.result == skill ) {
                    document.getElementById( "responseResult" ).innerHTML = "Create success Candidates with skill: " + skill;
                } else {
                    document.getElementById( "responseResult" ).innerHTML = event.result + "<br/>";
                }
            }
        }, {
            escape: true
        }
    );
}

