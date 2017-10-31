trigger SM_UpdateStudentPointsTrigger on Student_Scoring_Skills__c (before insert, before update) {
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
                    
                    // check create id student skill
                    if ( studentSkillNew.Id != studentSkill.Id && studentSkillNew.Student_ID__c == studentSkill.Student_ID__c && studentSkillNew.Student_Skill__c == studentSkill.Student_Skill__c) {
                        studentSkillNew.addError( 'Create student skill name: ' + studentSkill.Name + ' is already existed ! Error!' );
                    }
                }
            }
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
            statusPoints = [SELECT Points__c, Student_Skill__r.Active__c, Student_Skill__r.Points__c, Student_ID__r.Status__c FROM Student_Scoring_Skills__c WHERE Id IN :listStatusScoreId];
    
            for ( Student_Scoring_Skills__c statusScore : statusPoints ) {
                if ( statusScore.Student_Skill__r.Active__c && !statusScore.Student_ID__r.Status__c.equalsIgnoreCase('Disabled') ) {
                    statusScore.Points__c = statusScore.Student_Skill__r.Points__c;
                    updatePoints.add( statusScore );
                } else {
                    statusScore.Points__c = 0;
                    updatePoints.add( statusScore );
                }
            }
    
            try {
                update updatePoints;
            } catch(DmlException e) {
                e.getMessage();
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        } else if (trigger.isUpdate) {
          
            for ( Student_Scoring_Skills__c studentSkill : listStudentSkill ) {
                for ( Student_Scoring_Skills__c studentSkillNew : ( List< Student_Scoring_Skills__c> ) Trigger.New ) {
                    
                    // Check update id student skill
                    if ( studentSkillNew.Id != studentSkill.Id && studentSkillNew.Student_ID__c == studentSkill.Student_ID__c && studentSkillNew.Student_Skill__c == studentSkill.Student_Skill__c ) {
                       
                        studentSkillNew.addError( 'Student Skill name: ' + studentSkill.Name + ' is already existed ! Error!' );
                    }
                }
            }
        }
    }
}