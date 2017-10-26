/**
 * Created by tran.binh@mulodo.com on 2017/10/25
 */
@isTest
private class SM_TriggerDoubleSkillTest {

	@IsTest static void testStudentSkillTriggerTest() {
		Student_Scoring_Skill__c conflictStudentSkill = new Student_Scoring_Skill__c(
			Active__c = true,
            Skill__c = 'OOP',
            Points__c = 500
		);
		insert conflictStudentSkill;
		Test.startTest();
		try {
			insert new Student_Scoring_Skill__c(
					Active__c = true,
					Skill__c = 'OOP',
					Points__c = 500);
		} catch(DmlException e) {
			System.assert(e.getMessage().contains('Create Skill name: SK-100045 is already existed ! Error!'));
		}
		Test.stopTest();
	}

	/** Test case that when have 2 or more conflict Student Skill in inserted simultaneously
	*/
	@isTest static void testInsertDoubleConflict() {
		Student_Scoring_Skill__c conflictStudentSkill = new Student_Scoring_Skill__c(
				Active__c = true,
				Skill__c = 'OOP',
				Points__c = 400
		);
		insert conflictStudentSkill;
		Test.startTest();
		List<Student_Scoring_Skill__c> doubleConflictList = new List<Student_Scoring_Skill__c>();
		doubleConflictList.add(new Student_Scoring_Skill__c(
				Active__c = true,
				Skill__c = 'OOP',
				Points__c = 500));
		doubleConflictList.add(new Student_Scoring_Skill__c(
				Active__c = true,
				Skill__c = 'OOP',
				Points__c = 600));
		try {
			insert doubleConflictList;
		} catch(DmlException e) {
			System.assert(e.getMessage().contains('Create Skill name: SK-100045 is already existed ! Error!'));
		}
		Test.stopTest();
	}
    
    /** Test case that when have 2 or more conflict Student Skill in inserted simultaneously
	*/
	@isTest static void testUpdateDoubleConflict() {
		Test.startTest();
		List<Student_Scoring_Skill__c> doubleConflictList = new List<Student_Scoring_Skill__c>();
		doubleConflictList.add(new Student_Scoring_Skill__c(
				Active__c = true,
				Skill__c = 'OOP',
				Points__c = 500));
		doubleConflictList.add(new Student_Scoring_Skill__c(
				Active__c = true,
				Skill__c = 'Oracle DB',
				Points__c = 600));
		try {
			insert doubleConflictList;
            List< Student_Scoring_Skill__c > listSkill = [SELECT Id, Name, Skill__c FROM Student_Scoring_Skill__c 
                                                         WHERE Skill__c =: 'Oracle DB'];
            listSkill.get(0).Skill__c = 'OOP';
            update listSkill;
		} catch(DmlException e) {
			System.assert(e.getMessage().contains('Skill name: SK-100045 is already existed ! Error!'));
		}
		Test.stopTest();
	}
}