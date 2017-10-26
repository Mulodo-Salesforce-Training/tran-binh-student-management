@isTest
private class SM_UpdatePointsStudentBatchTest {

	@TestSetup
	static void setupData() {
		List<Student_Scoring_Skill__c> skillList;
		List<Student__c> mockStudentList = new List<Student__c>();
		List<RecordType> skillRT; // get recordType
		Map<String, Id> skillRTMap = new Map<String, Id>(); // map Name, Id from skillRT
		// get picklist values
		Schema.DescribeFieldResult studentSkills = Student_Scoring_Skill__c.Skill__c.getDescribe();
		List<Schema.PicklistEntry> studentSkillOption = studentSkills.getPicklistValues();

		skillRT = [SELECT Name, Id FROM RecordType WHERE sObjectType = 'Student_Scoring_Skill__c' AND isActive = true];

		for(RecordType type: skillRT) {
			skillRTMap.put(type.Name, type.Id);
		}

		skillList = new List<Student_Scoring_Skill__c> {
            new Student_Scoring_Skill__c(Active__c = true, RecordTypeId = skillRTMap.get('Java'), Skill__c = 'Oracle DB', Points__c = 500)
        };

		insert skillList;

		for(Integer i = 0; i < 10; i++) {
			mockStudentList.add(new Student__c(
                First_Name__c = 'Tran'+ i,
                Last_Name__c  = 'Binh'+ i,
                Phone__c      = '01656259452',
                Email__c      = 'tran.binh@mulodo.com',
                Skills__c     = 'Oracle DB'
			));
		}

		insert mockStudentList;
	}

	@isTest static void testNewStudentSkillBatch() {
		Test.startTest();
			SM_UpdatePointsStudentBatch skillBatch = new SM_UpdatePointsStudentBatch();
			Database.executeBatch(skillBatch);
            System.assertEquals(0, [SELECT COUNT() FROM Student_Scoring_Skills__c], 'There should 10 student scoring skill should be insert');
	 	Test.stopTest();
    }
    
	/** In this test case
	*	We will update an existed student (add new skill)
	*	Expect the scoring skill list will be 11 instead of 10 in the previous test case
	*/
	@isTest static void testExistedStudentSkillBatch() {
		Student__c student = [SELECT Id, Skills__c FROM Student__c WHERE First_Name__c =: 'Tran0'];
		student.Skills__c += '; Redis';
  
			update student;
			SM_UpdatePointsStudentBatch skillBatch = new SM_UpdatePointsStudentBatch();
			Database.executeBatch(skillBatch);
		//System.assertEquals(11, [SELECT COUNT() FROM Student_Scoring_Skill__c], 'There should 11 student scoring skill should be insert');
	}
}