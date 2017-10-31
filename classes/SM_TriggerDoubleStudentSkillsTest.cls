/**
 * Double Student Skills Trigger class test
 * Created by tran.binh@mulodo.com on 2017/10/25
 */
@isTest
private class SM_TriggerDoubleStudentSkillsTest {

	@IsTest static void testStudentSkillTriggerTest() {
		Student_Scoring_Skills__c conflictStudentSkill = new Student_Scoring_Skills__c(
			Student_ID__c    = 'S-00083',
            Student_Skill__c = 'OOP'
		);
		insert conflictStudentSkill;
		Test.startTest();
		try {
			insert new Student_Scoring_Skills__c(
				Student_ID__c    = 'S-00083',
            	Student_Skill__c = 'OOP'
            );
		} catch(DmlException e) {
            system.debug(e.getMessage());
			//System.assert(e.getMessage().contains('Create Skill name: SK-100045 is already existed ! Error!'));
		}
		Test.stopTest();
	}

	/**
     * Test case that when have 2 or more conflict Student Skill in inserted simultaneously
	 */
	@isTest static void testInsertDoubleConflict() {
		Student_Scoring_Skills__c conflictStudentSkill = new Student_Scoring_Skills__c(
            Student_ID__c = 'S-00083',
            Student_Skill__c = 'OOP'
		);
		insert conflictStudentSkill;
		Test.startTest();
		List<Student_Scoring_Skills__c> doubleConflictList = new List<Student_Scoring_Skills__c>();
		doubleConflictList.add(new Student_Scoring_Skills__c(
            Student_ID__c = 'S-00083',
            Student_Skill__c = 'OOP'));
		doubleConflictList.add(new Student_Scoring_Skills__c(
			Student_ID__c = 'S-00083',
            Student_Skill__c = 'OOP'));
		try {
			insert doubleConflictList;
		} catch(DmlException e) {
            system.debug(e.getMessage());
			//System.assert(e.getMessage().contains('Create Skill name: SK-100045 is already existed ! Error!'));
		}
		Test.stopTest();
	}

    /**
     * Test case that when have 2 or more conflict Student Skill in inserted simultaneously
	 */
	@isTest static void testUpdateDoubleConflict() {
		Test.startTest();
		List<Student_Scoring_Skills__c> doubleConflictList = new List<Student_Scoring_Skills__c>();
		doubleConflictList.add(new Student_Scoring_Skills__c(
			Student_ID__c = 'S-00083',
            Student_Skill__c = 'OOP'));
		doubleConflictList.add(new Student_Scoring_Skills__c(
			Student_ID__c = 'S-00084',
            Student_Skill__c = 'Oracle DB'));
		try {
			insert doubleConflictList;
            List< Student_Scoring_Skills__c > listSkill = [SELECT Id, Name, Student_ID__c, Student_Skill__c FROM Student_Scoring_Skills__c
                                                         WHERE Student_Skill__c =: 'Oracle DB'];
            listSkill.get(0).Student_ID__c = 'S-00083';
            listSkill.get(0).Student_Skill__c = 'OOP';
            update listSkill;
		} catch(DmlException e) {
            system.debug(e.getMessage());
			//System.assert(e.getMessage().contains('Skill name: SK-100045 is already existed ! Error!'));
		}
		Test.stopTest();
	}
}