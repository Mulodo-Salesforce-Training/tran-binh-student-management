trigger SM_TriggerStudentActive on Student_Scoring_Skill__c (after update) {
    if ( Trigger.isAfter ) {

        //Initialize student list
        List<Student_Scoring_Skill__c> statusActive   = new List<Student_Scoring_Skill__c>();
        List<Student_Scoring_Skill__c> statusInActive = new List<Student_Scoring_Skill__c>();
        //Initialize Student Scoring Skills list
        List<Student_Scoring_Skills__c> updatePoints  = new List<Student_Scoring_Skills__c>();
        List<Student_Scoring_Skills__c> statusPoints  = new List<Student_Scoring_Skills__c>();

        //add in list with status of student
        for ( Student_Scoring_Skill__c std: Trigger.new )
        {
            if( std.Active__c ) {
                statusActive.add(std);
            } else {
                statusInActive.add(std);
            }
        }

        //update when status is Disable on Student
        if( statusInActive.size() > 0 ) {
            statusPoints = [SELECT Points__c FROM Student_Scoring_Skills__c WHERE Student_Skill__c IN: statusInActive AND Points__c != 0];

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
        if( statusActive.size() > 0 ) {
            statusPoints = [SELECT Points__c, Student_Skill__r.Active__c, Student_Skill__r.Points__c FROM Student_Scoring_Skills__c
            WHERE Student_Skill__c IN: statusActive AND Points__c = 0 AND Student_Skill__r.Active__c = true ];

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