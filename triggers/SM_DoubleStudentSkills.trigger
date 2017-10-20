trigger SM_DoubleStudentSkills on Student_Scoring_Skills__c(before insert, before update) {
    List< String > listStudent = new List< String >();
    List< String > listSkillStudent = new List< String >();
            for ( Student_Scoring_Skills__c pos : ( List< Student_Scoring_Skills__c> ) Trigger.New ) {
            listStudent.add( pos.Student_ID__c );
            listSkillStudent.add( pos.Student_Skill__c );
        }
    List< Student_Scoring_Skills__c > listPossion = [SELECT Id, Name, Student_ID__c, Student_Skill__c FROM Student_Scoring_Skills__c 
                                                     WHERE Student_ID__c IN : listStudent AND Student_Skill__c In : listSkillStudent];
    
    if (trigger.isInsert) {
        for ( Student_Scoring_Skills__c pos : listPossion ) {
            for ( Student_Scoring_Skills__c posNew : ( List< Student_Scoring_Skills__c> ) Trigger.New ) {
                
                // check create id postion
                if ( posNew.Id != pos.Id && posNew.Student_ID__c == pos.Student_ID__c && posNew.Student_Skill__c == pos.Student_Skill__c) {
                    posNew.addError( 'Create Position name: ' + pos.Name + ' is already existed ! Error!' );
                }
            }
        }      
    } else if (trigger.isUpdate) {
      
        for ( Student_Scoring_Skills__c pos : listPossion ) {
            for ( Student_Scoring_Skills__c posNew : ( List< Student_Scoring_Skills__c> ) Trigger.New ) {
                
                // Check update id postion
                if ( posNew.Id != pos.Id && posNew.Student_ID__c == pos.Student_ID__c && posNew.Student_Skill__c == pos.Student_Skill__c ) {
                   
                    posNew.addError( 'Position name: ' + pos.Name + ' is already existed ! Error!' );
                }
            }
        }
    }
}