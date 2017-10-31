/**
 * Update Points Student Batch class test
 * Created by tran.binh@mulodo.com on 2017/10/31.
 */
@isTest
private class SM_UpdatePointsStudentBatchTest {

    /**
     * Setup data before for function test
     */
	@TestSetup
	static void setupData() {
		List<Student_Scoring_Skill__c> skillList;
		List<Student__c> mockStudentList = new List<Student__c>();
		List<RecordType> skillRecordType; // get recordType
		Map<String, Id> skillRecordTypeMap = new Map<String, Id>(); // map Name, Id from skillRT
		// get picklist values
		Schema.DescribeFieldResult studentSkills = Student_Scoring_Skill__c.Skill__c.getDescribe();
		List<Schema.PicklistEntry> studentSkillOption = studentSkills.getPicklistValues();

		skillRecordType = [SELECT Name, Id FROM RecordType WHERE sObjectType = 'Student_Scoring_Skill__c' AND isActive = true];

		for(RecordType type: skillRecordType) {
			skillRecordTypeMap.put(type.Name, type.Id);
		}

		skillList = new List<Student_Scoring_Skill__c> {
            new Student_Scoring_Skill__c(Active__c = true, RecordTypeId = skillRecordTypeMap.get('Java'), Skill__c = 'Java Basic Knowledge', Points__c = 500),
            new Student_Scoring_Skill__c(Active__c = true, RecordTypeId = skillRecordTypeMap.get('PHP'), Skill__c = 'OOP', Points__c = 500),
            new Student_Scoring_Skill__c(Active__c = true, RecordTypeId = skillRecordTypeMap.get('Salesforce'), Skill__c = 'Developer Beginner', Points__c = 500),
            new Student_Scoring_Skill__c(Active__c = true, RecordTypeId = skillRecordTypeMap.get('Java'), Skill__c = 'Caching', Points__c = 500)
        };

		insert skillList;

		for(Integer i = 0; i < 10; i++) {
			mockStudentList.add(new Student__c(
                First_Name__c = 'Tran'+ i,
                Last_Name__c  = 'Binh'+ i,
                Email__c      = 'tran.binh@mulodo.com',
                Phone__c      = '01656259452',
                Skills__c     = 'Java Basic Knowledge'
			));
		}

		insert mockStudentList;
	}

	/**
	 * In this test case
	 * We will update an existed student (add new skill)
	 * Expect the scoring skill list will be 10 instead of 10 in the previous test case
	 */
	@isTest static void testNewStudentSkillBatch() {
		Test.startTest();
			SM_UpdatePointsStudentBatch skillBatch = new SM_UpdatePointsStudentBatch();
			Database.executeBatch(skillBatch,100);
		Test.stopTest();

		System.assertEquals(10, [SELECT COUNT() FROM Student_Scoring_Skills__c], 'There should 10 student scoring skill should be insert');
	}

	/**
	 * In this test case
	 * We will update an existed student (add new skill)
	 * Expect the scoring skill list will be 11 instead of 10 in the previous test case
	 */
	@isTest static void testExistedStudentSkillBatch() {
		Student__c student = [SELECT Id, Skills__c FROM Student__c WHERE First_Name__c =: 'Tran0'];
		student.Skills__c += ';OOP';

		Test.startTest();
			update student;
			SM_UpdatePointsStudentBatch skillBatch = new SM_UpdatePointsStudentBatch();
			Database.executeBatch(skillBatch,100);
		Test.stopTest();
		System.assertEquals(11, [SELECT COUNT() FROM Student_Scoring_Skills__c], 'There should 11 student scoring skill should be insert');
	}
}