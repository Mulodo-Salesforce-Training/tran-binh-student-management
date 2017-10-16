trigger SM_TriggerStudentStatus on Student__c ( after update ) {
    if ( Trigger.isUpdate && Trigger.isAfter ) {
        //Initialize student list
        List<Student__c> statusDisable                  = new List<Student__c>();
        List<Student__c> statusNotDisable               = new List<Student__c>();
        //Initialize Student Scoring Skills list
        List<Student_Scoring_Skills__c> updatePoints    = new List<Student_Scoring_Skills__c>();
        List<Student_Scoring_Skills__c> statusPoints    = new List<Student_Scoring_Skills__c>();

        //add in list with status of student
        for ( Student__c std: Trigger.new )
        {
            if( std.Status__c == 'Disabled' ) {
                statusDisable.add(std);
            } else {
                statusNotDisable.add(std);
            }
        }

        //update when status is Disable on Student
        if( statusDisable.size() > 0 ) {
            statusPoints = [SELECT Points__c FROM Student_Scoring_Skills__c WHERE Student_ID__c IN: statusDisable AND Points__c != 0];

            for ( Student_Scoring_Skills__c statusScore : statusPoints ) {
                statusScore.Points__c = 0;
                updatePoints.add( statusScore );
            }

            update updatePoints;
        }

        //update points when status not disable.
        if( statusNotDisable.size() > 0 ) {
            statusPoints = [SELECT Points__c, Student_Skill__r.Active__c, Student_Skill__r.Points__c FROM Student_Scoring_Skills__c
            WHERE Student_ID__c IN: statusNotDisable AND Points__c = 0 AND Student_Skill__r.Active__c = true ];


            for ( Student_Scoring_Skills__c statusScore : statusPoints ) {
                statusScore.Points__c = statusScore.Student_Skill__r.Points__c;
                updatePoints.add( statusScore );
            }

            update updatePoints;
        }
    }
}