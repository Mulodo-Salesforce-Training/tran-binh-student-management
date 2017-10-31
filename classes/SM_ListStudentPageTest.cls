/**
 * List student for test class
 * Created by tran.binh@mulodo.com on 10/31/2017.
 */
@isTest
public class SM_ListStudentPageTest {
    /**
     * set up student data for list student
     */
	@testSetup static void dataFactory() {
		List<Student__c> studentList = new List<Student__c>();
		for (Integer i = 0; i < 10; i++) {
			studentList.add(new Student__c(
				First_Name__c = 'Tran' + i,
				Last_Name__c  = 'Binh' + i,
                Phone__c      = '01656259452',
				Email__c      = 'tran.binh@mulodo.com'
			));
		}
		insert studentList;
	}

    /**
     * test case constructor for record of page
     */
    @isTest static void testConstructor() {
        Test.startTest();
		SM_ListStudentCC student = new SM_ListStudentCC();
        Test.stopTest();
        System.assert(student.totalSize == 10, 'Should return exact number of inserted students');
        System.assertEquals( 0, student.count );
		System.assertEquals( 5, student.customListSize );
	}

    /**
     * test case test button next, previous
     */
    @isTest static void testSelectAction() {
		SM_ListStudentCC student = new SM_ListStudentCC();
        System.assertEquals( 0, student.count );
		System.assertEquals( null, student.selectAction() );
	}

    /**
     * test case test function Get Disable of button Previous
     */
    @isTest static void testGetDisablePrevious() {
		SM_ListStudentCC student = new SM_ListStudentCC();
        System.assertEquals( true, student.getDisablePrevious() );
	}

    /**
     * test case test function Get Disable of button Next
     */
    @isTest static void testGetDisableNext() {
		SM_ListStudentCC student = new SM_ListStudentCC();
        System.assertEquals( false, student.getDisableNext() );
	}

    /**
     * This will get current page when constructor
     */
    @isTest static void testGetCurrentPage() {
		SM_ListStudentCC student = new SM_ListStudentCC();
        System.assertEquals( 1, student.getCurrentPage() );
	}

    /**
     * This will get current page when list student is 0 record
     */
    @isTest static void testGetCurrentPage1() {
		Test.startTest();
        List<Student__c> listStudent = [SELECT Id FROM Student__c];
        Database.delete(listStudent);
        SM_ListStudentCC student   = New SM_ListStudentCC();
		Test.stopTest();
        System.assertEquals( 0, student.getCurrentPage() );
	}

    /**
     * This will get total page when totalSize equals customListSize
     */
    @isTest static void testGetTotalPage() {
        List<Student__c> listStudent = [SELECT Id FROM Student__c];
        delete listStudent;
        system.debug(listStudent);
        dataFactory();
		Test.startTest();
		SM_ListStudentCC student = new SM_ListStudentCC();
        System.assertEquals( 2, student.getTotalPage() );
		Test.stopTest();
	}

    /**
     * This will get total page when record number is 0.
     */
    @isTest static void testGetTotalPage1() {
		Test.startTest();
        List<Student__c> studentList = [SELECT Id FROM Student__c];
        Database.delete(studentList);
		SM_ListStudentCC student   = new SM_ListStudentCC();
        studentList = new List<Student__c>();
        System.assertEquals( 0, student.getTotalPage() );
		Test.stopTest();
	}

    /**
     * This will get total page when totalSize less than customListSize.
     */
    @isTest static void testGetTotalPage2() {
		Test.startTest();
        List<Student__c> listStudent = [SELECT Id FROM Student__c];
        Database.delete(listStudent);
        listStudent = new List<Student__c>();
        for (Integer i = 0; i < 2; i++) {
			listStudent.add(new Student__c(
				First_Name__c = 'Tran' + i,
				Last_Name__c  = 'Binh' + i,
                Phone__c      = '01656259452',
				Email__c      = 'tran.binh@mulodo.com'
			));
		}
		insert listStudent;
        SM_ListStudentCC student   = new SM_ListStudentCC();
        System.assertEquals( 1, student.getTotalPage() );
		Test.stopTest();
	}

    /**
     * This will get total page when mod of totalSize and customListSize not equals 0
     */
    @isTest static void testGetTotalPage3() {
		Test.startTest();
        List<Student__c> listStudent = [SELECT Id FROM Student__c];
        Database.delete(listStudent);
        listStudent = new List<Student__c>();
        for (Integer i = 0; i < 6; i++) {
			listStudent.add(new Student__c(
				First_Name__c = 'Tran' + i,
				Last_Name__c  = 'Binh' + i,
                Phone__c      = '01656259452',
				Email__c      = 'tran.binh@mulodo.com'
			));
		}
		insert listStudent;
        SM_ListStudentCC student   = new SM_ListStudentCC();
        System.assertEquals( 2, student.getTotalPage() );
		Test.stopTest();
	}

    /**
     * This will get total Record of list student
     */
    @isTest static void testGetTotalRecord() {
		SM_ListStudentCC student = new SM_ListStudentCC();
        System.assertEquals( 10, student.getTotalRecord() );
	}

    /**
     * This will test get Status Pick List
     */
	@isTest static void testGetStatusPickList() {
		Test.startTest();
		String returnPickList = SM_ListStudentCC.getStatusPickList();
		Test.stopTest();
		List<Schema.PicklistEntry> statusPickList = (List<Schema.PicklistEntry>)JSON.deserialize(returnPickList, List<Schema.PicklistEntry>.class);
		System.assert(returnPickList.length() > 0 , 'JSON String Pick List should has more than 1 symbols');
		System.assert(statusPickList.size() > 0 , 'Status Pick List should contain more than 1 pick List');
	}
}