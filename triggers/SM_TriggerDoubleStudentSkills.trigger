trigger SM_TriggerDoubleStudentSkills on Student_Scoring_Skills__c (before insert, before update) {
    if( trigger.isBefore ) {
        List< String > listStudent = new List< String >();
        List< String > listSkillStudent = new List< String >();
                for ( Student_Scoring_Skills__c studentSkill : ( List< Student_Scoring_Skills__c> ) Trigger.New ) {
                listStudent.add( studentSkill.Student_ID__c );
                listSkillStudent.add( studentSkill.Student_Skill__c );
            }
        List< Student_Scoring_Skills__c > listStudentSkill = [SELECT Id, Name, Student_ID__c, Student_Skill__c FROM Student_Scoring_Skills__c 
                                                         WHERE Student_ID__c IN : listStudent AND Student_Skill__c In : listSkillStudent];
        
        if (trigger.isInsert) {
            for ( Student_Scoring_Skills__c studentSkill : listStudentSkill ) {
                for ( Student_Scoring_Skills__c studentSkillNew : ( List< Student_Scoring_Skills__c> ) Trigger.New ) {
                    
                    // check create id postion
                    if ( studentSkillNew.Id != studentSkill.Id && studentSkillNew.Student_ID__c == studentSkill.Student_ID__c && studentSkillNew.Student_Skill__c == studentSkill.Student_Skill__c) {
                        studentSkillNew.addError( 'Create student skill name: ' + studentSkill.Name + ' is already existed ! Error!' );
                    }
                }
            }      
        } else if (trigger.isUpdate) {
          
            for ( Student_Scoring_Skills__c studentSkill : listStudentSkill ) {
                for ( Student_Scoring_Skills__c studentSkillNew : ( List< Student_Scoring_Skills__c> ) Trigger.New ) {
                    
                    // Check update id postion
                    if ( studentSkillNew.Id != studentSkill.Id && studentSkillNew.Student_ID__c == studentSkill.Student_ID__c && studentSkillNew.Student_Skill__c == studentSkill.Student_Skill__c ) {
                       
                        studentSkillNew.addError( 'Student Skill name: ' + studentSkill.Name + ' is already existed ! Error!' );
                    }
                }
            }
        }          
    }
}