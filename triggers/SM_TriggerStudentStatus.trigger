trigger SM_TriggerStudentStatus on Student__c ( after insert, after update ) {

    //Initialize student list
    List<Student__c> statusDisableStudent           = new List<Student__c>();
    List<Student__c> statusEnabledStudent           = new List<Student__c>();
    //Initialize Student Scoring Skills list
    List<Student_Scoring_Skills__c> updatePoints    = new List<Student_Scoring_Skills__c>();
    List<Student_Scoring_Skills__c> statusPoints    = new List<Student_Scoring_Skills__c>();

    if ( Trigger.isAfter ) {
        //add in list with status of student
        for ( Student__c std: Trigger.new )
        {
            if( std.Status__c == 'Disabled' ) {
                statusDisableStudent.add(std);
            } else {
                statusEnabledStudent.add(std);
            }
        }

        //update when status is Disable on Student
        if( statusDisableStudent.size() > 0 ) {
            statusPoints = [SELECT Points__c FROM Student_Scoring_Skills__c WHERE Student_ID__c IN: statusDisableStudent AND Points__c != 0];

            for ( Student_Scoring_Skills__c statusScore : statusPoints ) {
                statusScore.Points__c = 0;
                updatePoints.add( statusScore );
            }

            try {
                update updatePoints;
            } catch(DmlException e) {
                e.getMessage();
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }

        //update points when status not disable.
        if( statusEnabledStudent.size() > 0 ) {
            statusPoints = [SELECT Points__c, Student_Skill__r.Active__c, Student_Skill__r.Points__c FROM Student_Scoring_Skills__c WHERE Student_ID__c IN: statusEnabledStudent AND Points__c = 0 AND Student_Skill__r.Active__c = true ];

            for ( Student_Scoring_Skills__c statusScore : statusPoints ) {
                statusScore.Points__c = statusScore.Student_Skill__r.Points__c;
                updatePoints.add( statusScore );
            }

            try {
                update updatePoints;
            } catch(DmlException e) {
                e.getMessage();
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
    }
}