/**
 * List Student Scoring Skills class test
 * Created by tran.binh@mulodo.com on 2017/10/31.
 */
@isTest
public class SM_ListStudentScoringSkillsCCTest {
    // set up student data for pagination test
	@testSetup static void dataFactory() {
		List<Student_Scoring_Skills__c> skillList = new List<Student_Scoring_Skills__c>();
        for (Integer i = 0; i < 1; i++) {
			skillList.add(new Student_Scoring_Skills__c(
				Student_ID__c = 'S-00061',
				Student_Skill__c  = 'SK-00029'
			));
		}
        system.debug(skillList);
		insert skillList;
	}

    /**
     * Get number record Student when constructor
     */
    @isTest static void testGetStudent() {
        Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        system.debug(skill.students.size());
        Test.stopTest();
        System.assertEquals( 5, skill.students.size() );
	}

    /**
     * Test case get total size of Student when constructor
     */
    @isTest static void testConstructor() {
        Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assert(skill.totalSize == 10, 'Should return exact number of inserted students');
        System.assertEquals( 0, skill.count );
		System.assertEquals( 5, skill.customListSize );
	}

    /**
     * Test case when Select Action: next, previous,...
     */
    @isTest static void testSelectAction() {
		Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assertEquals( 0, skill.count );
		System.assertEquals( null, skill.selectAction() );
	}

    /**
     * Test case Get Disable Previous
     */
    @isTest static void testGetDisablePrevious() {
		Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assertEquals( true, skill.getDisablePrevious() );
	}

    /**
     * Test case This will get Enable Next
     */
    @isTest static void testGetEnableNext() {
		Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assertEquals( false, skill.getDisableNext() );
	}

    /**
     * Test case This will get Disable Next
     */
    @isTest static void testGetDisableNext() {
		 List<Student_Scoring_Skills__c> listSkill = [SELECT Id FROM Student_Scoring_Skills__c];
        Database.delete(listSkill);
        listSkill = new List<Student_Scoring_Skills__c>();
        for (Integer i = 0; i < 2; i++) {
			listSkill.add(new Student_Scoring_Skills__c(
				Student_ID__c = 'Mai'+ i,
				Student_Skill__c  = 'mySQL',
				Points__c = 50
			));
		}
		insert listSkill;
        Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assertEquals( true, skill.getDisableNext() );
	}

    /**
     * Test case This will Get Current Page Not 0 Record
     */
    @isTest static void testGetCurrentPageNot0Record() {
		Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assertEquals( 1, skill.getCurrentPage() );
	}

    /**
     * Test case This will Get Current Page 0 Record
     */
    @isTest static void testGetCurrentPageZeroRecord() {
        Test.startTest();
        List<Student_Scoring_Skills__c> listSkill = [SELECT Id FROM Student_Scoring_Skills__c];
        Database.delete(listSkill);
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assertEquals( 0, skill.getCurrentPage() );
	}

    /**
     * Test case This will Get Total Page 0 Record
     */
    @isTest static void testGetTotalPageZeroRecord() {
        List<Student_Scoring_Skills__c> listSkill = [SELECT Id FROM Student_Scoring_Skills__c];
        Database.delete(listSkill);
		Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        listSkill = new List<Student_Scoring_Skills__c>();
        System.assertEquals( 0, skill.getTotalPage() );
	}

    /**
     * Test case This will Get Total Page One Page
     */
    @isTest static void testGetTotalPageOnePage() {
        List<Student_Scoring_Skills__c> listSkill = [SELECT Id FROM Student_Scoring_Skills__c];
        Database.delete(listSkill);
        listSkill = new List<Student_Scoring_Skills__c>();
        for (Integer i = 0; i < 2; i++) {
			listSkill.add(new Student_Scoring_Skills__c(
				Student_ID__c = 'Mai'+ i,
				Student_Skill__c  = 'mySQL',
				Points__c = 50
			));
		}
		insert listSkill;
        Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assertEquals( 1, skill.getTotalPage() );
	}

    /**
     * Test case This will Get Total Page Greater Than One Page
     */
    @isTest static void testGetTotalPageGreaterThanOnePage() {
        List<Student_Scoring_Skills__c> listSkill = [SELECT Id FROM Student_Scoring_Skills__c];
        Database.delete(listSkill);
        listSkill = new List<Student_Scoring_Skills__c>();
        for (Integer i = 0; i < 6; i++) {
			listSkill.add(new Student_Scoring_Skills__c(
				Student_ID__c = 'Mai'+ i,
				Student_Skill__c  = 'mySQL',
				Points__c = 50
			));
		}
		insert listSkill;
        Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assertEquals( 2, skill.getTotalPage() );
	}

    /**
     * Test case This will Get Total Page Equals Number Of Page
     */
    @isTest static void testGetTotalPageEqualsNumberOfPage() {
        List<Student_Scoring_Skills__c> listSkill = [SELECT Id FROM Student_Scoring_Skills__c];
        Database.delete(listSkill);
        dataFactory();
        Test.startTest();
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        Test.stopTest();
        System.assertEquals( 2, skill.getTotalPage() );
	}

    /**
     * Test case This will Get Total Record
     */
    @isTest static void testGetTotalRecord() {
		SM_ListStudentScoringSkillsCC skill = new SM_ListStudentScoringSkillsCC();
        System.assertEquals( 10, skill.getTotalRecord() );
	}
}