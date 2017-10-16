trigger SM_TriggerUpdateStudentPoints on Student_Scoring_Skills__c (after insert) {
    if ( Trigger.isAfter && Trigger.isInsert ) {
        //Initialize List Id of Student_Scoring_Skills__c
        List< Id > listStatusScoreId                 = new List< Id >();
        //Initialize List Status and update points of Student_Scoring_Skills__c
        List<Student_Scoring_Skills__c> updatePoints = new List<Student_Scoring_Skills__c>();
        List<Student_Scoring_Skills__c> statusPoints = new List<Student_Scoring_Skills__c>();

        //add in list with status of student
        for ( Student_Scoring_Skills__c std: Trigger.new ) {
            listStatusScoreId.add(std.Id);
        }
        //Select Points and status for update Student_Scoring_Skills__c
        statusPoints = [SELECT Points__c, Student_Skill__r.Active__c, Student_Skill__r.Points__c, Student_ID__r.Status__c 
                        FROM Student_Scoring_Skills__c WHERE Id IN :listStatusScoreId];
        
        for ( Student_Scoring_Skills__c statusScore : statusPoints ) {
            if ( statusScore.Student_Skill__r.Active__c && !statusScore.Student_ID__r.Status__c.equalsIgnoreCase('Disabled') ) {
                statusScore.Points__c = statusScore.Student_Skill__r.Points__c;
                updatePoints.add( statusScore );
            }
        }
        update updatePoints;
    }
}