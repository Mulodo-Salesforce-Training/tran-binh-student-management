@isTest
public class SM_ListStudentScoringSkillCCTest {
    // set up student data for pagination test
	@testSetup static void dataFactory() {
		List<Student_Scoring_Skill__c> skillList = new List<Student_Scoring_Skill__c>();
        for (Integer i = 0; i < 10; i++) {
			skillList.add(new Student_Scoring_Skill__c(
				Active__c = true,
				Skill__c  = 'Oracle DB',
				Points__c = 400
			));
		}
		insert skillList;
	}
    
    @isTest static void testGetStudent() {
        Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        system.debug(skill.students.size());
        Test.stopTest();
        System.assertEquals( 5, skill.students.size() );
	}
    
    @isTest static void testConstructor() {
        Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assert(skill.totalSize == 10, 'Should return exact number of inserted students');
        System.assertEquals( 0, skill.count );
		System.assertEquals( 5, skill.customListSize );
	}
    
    @isTest static void testSelectAction() {
		Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assertEquals( 0, skill.count );
		System.assertEquals( null, skill.selectAction() );
	}
    
    @isTest static void testGetDisablePrevious() {
		Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assertEquals( true, skill.getDisablePrevious() );
	}
    
    //This will get Enable Next
    @isTest static void testGetEnableNext() {
		Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assertEquals( false, skill.getDisableNext() );
	}
    
    //This will get Disable Next
    @isTest static void testGetDisableNext() {
		 List<Student_Scoring_Skill__c> listSkill = [SELECT Id FROM Student_Scoring_Skill__c];
        Database.delete(listSkill);
        listSkill = new List<Student_Scoring_Skill__c>();
        for (Integer i = 0; i < 2; i++) {
			listSkill.add(new Student_Scoring_Skill__c(
				Active__c = true,
				Skill__c  = 'Oracle DB',
				Points__c = 50
			));
		}
		insert listSkill;
        Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assertEquals( true, skill.getDisableNext() );
	}
    
    // This will get current page
    @isTest static void testGetCurrentPageNot0Record() {
		Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assertEquals( 1, skill.getCurrentPage() );
	}
    
    // This will get total page
    @isTest static void testGetCurrentPageZeroRecord() {
        Test.startTest();
        List<Student_Scoring_Skill__c> listSkill = [SELECT Id FROM Student_Scoring_Skill__c];
        Database.delete(listSkill);
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assertEquals( 0, skill.getCurrentPage() );
	}
    
    // This will get total page
    @isTest static void testGetTotalPageZeroRecord() {
        List<Student_Scoring_Skill__c> listSkill = [SELECT Id FROM Student_Scoring_Skill__c];
        Database.delete(listSkill);
		Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        listSkill = new List<Student_Scoring_Skill__c>();
        System.assertEquals( 0, skill.getTotalPage() );
	}
    
    // This will get total page
    @isTest static void testGetTotalPageOnePage() {
        List<Student_Scoring_Skill__c> listSkill = [SELECT Id FROM Student_Scoring_Skill__c];
        Database.delete(listSkill);
        listSkill = new List<Student_Scoring_Skill__c>();
        for (Integer i = 0; i < 2; i++) {
			listSkill.add(new Student_Scoring_Skill__c(
				Active__c = true,
				Skill__c  = 'Oracle DB',
				Points__c = 50
			));
		}
		insert listSkill;
        Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assertEquals( 1, skill.getTotalPage() );
	}
    
    // This will get total page
    @isTest static void testGetTotalPageGreaterThanOnePage() {
        List<Student_Scoring_Skill__c> listSkill = [SELECT Id FROM Student_Scoring_Skill__c];
        Database.delete(listSkill);
        listSkill = new List<Student_Scoring_Skill__c>();
        for (Integer i = 0; i < 6; i++) {
			listSkill.add(new Student_Scoring_Skill__c(
				Active__c = true,
				Skill__c  = 'Oracle DB',
				Points__c = 50
			));
		}
		insert listSkill;
        Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assertEquals( 2, skill.getTotalPage() );
	}
    
     // This will get total page
    @isTest static void testGetTotalPageEqualsNumberOfPage() {
        List<Student_Scoring_Skill__c> listSkill = [SELECT Id FROM Student_Scoring_Skill__c];
        Database.delete(listSkill);
        dataFactory();
        Test.startTest();
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        Test.stopTest();
        System.assertEquals( 2, skill.getTotalPage() );
	}
    
    // This will get total page
    @isTest static void testGetTotalRecord() {
		SM_ListStudentScoringSkillCC skill = new SM_ListStudentScoringSkillCC();
        System.assertEquals( 10, skill.getTotalRecord() );
	}
}