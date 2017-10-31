trigger SM_StudentActiveTrigger on Student_Scoring_Skill__c (before insert, before update, after update) {
    if ( Trigger.isAfter ) {

        //Initialize student list
        List<Student_Scoring_Skill__c> statusActiveSkill   = new List<Student_Scoring_Skill__c>();
        List<Student_Scoring_Skill__c> statusInActiveSkill = new List<Student_Scoring_Skill__c>();
        //Initialize Student Scoring Skills list
        List<Student_Scoring_Skills__c> updatePoints       = new List<Student_Scoring_Skills__c>();
        List<Student_Scoring_Skills__c> statusPoints       = new List<Student_Scoring_Skills__c>();

        //add in list with status of student
        for ( Student_Scoring_Skill__c std: Trigger.new ) {

            if( std.Active__c ) {
                statusActiveSkill.add(std);
            } else {
                statusInActiveSkill.add(std);
            }
        }

        //update when status is Disable on Student
        if( statusInActiveSkill.size() > 0 ) {
            statusPoints = [SELECT Points__c FROM Student_Scoring_Skills__c WHERE Student_Skill__c IN: statusInActiveSkill AND Points__c != 0];

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
        if( statusActiveSkill.size() > 0 ) {
            statusPoints = [SELECT Points__c, Student_Skill__r.Active__c, Student_Skill__r.Points__c FROM Student_Scoring_Skills__c WHERE Student_Skill__c IN: statusActiveSkill AND Points__c = 0 AND Student_Skill__r.Active__c = true ];

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
    } else if( trigger.isBefore ) {
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