trigger SM_TriggerDoubleSkill on Student_Scoring_Skill__c (before insert, before update) {
    if( trigger.isBefore ) {
        List< String > listSkillStudent = new List< String >();
                for ( Student_Scoring_Skill__c skill : ( List< Student_Scoring_Skill__c> ) Trigger.New ) {
                listSkillStudent.add( skill.Skill__c );
            }
        List< Student_Scoring_Skill__c > listSkill = [SELECT Id, Name, Skill__c FROM Student_Scoring_Skill__c 
                                                         WHERE Skill__c IN : listSkillStudent];
        
        if (trigger.isInsert) {
            for ( Student_Scoring_Skill__c skill : listSkill ) {
                for ( Student_Scoring_Skill__c skillNew : ( List< Student_Scoring_Skill__c> ) Trigger.New ) {
                    
                    // check create id postion
                    if ( skillNew.Id != skill.Id && skillNew.Skill__c == skill.Skill__c) {
                        skillNew.addError( 'Create Skill name: ' + skill.Name + ' is already existed ! Error!' );
                    }
                }
            }      
        } else if (trigger.isUpdate) {
          
            for ( Student_Scoring_Skill__c skill : listSkill ) {
                for ( Student_Scoring_Skill__c skillNew : ( List< Student_Scoring_Skill__c> ) Trigger.New ) {
                    
                    // Check update id postion
                    if ( skillNew.Id != skill.Id && skillNew.Skill__c == skill.Skill__c ) {
                       
                        skillNew.addError( 'Skill name: ' + skill.Name + ' is already existed ! Error!' );
                    }
                }
            }
        }          
    }
}