@isTest
public class SM_ListStudentPageTest {
    // set up student data for pagination test
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
    
    @isTest static void testConstructor() {
		Test.startTest();
		SM_ListStudentPage student = new SM_ListStudentPage();
		Test.stopTest();
        System.assert(student.totalSize == 10, 'Should return exact number of inserted students');
        System.assertEquals( 0, student.count );
		System.assertEquals( 5, student.customListSize );
       
	}
    
    @isTest static void testSelectAction() {
		Test.startTest();
		SM_ListStudentPage student = new SM_ListStudentPage();
        System.assertEquals( 0, student.count );
		System.assertEquals( null, student.selectAction() );
	}
    
    @isTest static void testGetDisablePrevious() {
		Test.startTest();
		SM_ListStudentPage student = new SM_ListStudentPage();
		Test.stopTest();
        System.assertEquals( true, student.getDisablePrevious() );
	}
    
    @isTest static void testGetDisableNext() {
		Test.startTest();
		SM_ListStudentPage student = new SM_ListStudentPage();
		Test.stopTest();
        System.assertEquals( false, student.getDisableNext() );
	}
    
    // This will get current page
    @isTest static void testGetCurrentPage() {
		Test.startTest();
		SM_ListStudentPage student = new SM_ListStudentPage();
		Test.stopTest();
        System.assertEquals( 1, student.getCurrentPage() );
	}
    
    // This will get total page
    @isTest static void testGetCurrentPage1() {
		Test.startTest();
        List<Student__c> listStudent = [SELECT Id FROM Student__c];
        Database.delete(listStudent);
        SM_ListStudentPage student   = New SM_ListStudentPage();
		Test.stopTest();
        System.assertEquals( 0, student.getCurrentPage() );
	}
    
    // This will get total page
    @isTest static void testGetTotalPage() {
        List<Student__c> listStudent = [SELECT Id FROM Student__c];
        delete listStudent;
        system.debug(listStudent);
        dataFactory();
		Test.startTest();
		SM_ListStudentPage student = new SM_ListStudentPage();
        System.assertEquals( 2, student.getTotalPage() );
		Test.stopTest();
        
	}
    
    // This will get total page
    @isTest static void testGetTotalPage1() {
		Test.startTest();
        List<Student__c> studentList = [SELECT Id FROM Student__c];
        Database.delete(studentList);
		SM_ListStudentPage student   = new SM_ListStudentPage();
        studentList = new List<Student__c>();
        System.assertEquals( 0, student.getTotalPage() );
		Test.stopTest();
	}
    
    // This will get total page
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
        SM_ListStudentPage student   = new SM_ListStudentPage();
        System.assertEquals( 1, student.getTotalPage() );
		Test.stopTest();
	}
    
    // This will get total page
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
        SM_ListStudentPage student   = new SM_ListStudentPage();
        System.assertEquals( 2, student.getTotalPage() );
		Test.stopTest();
	}
    
     // This will get total page
    @isTest static void testGetTotalPage4() {
		Test.startTest();
        List<Student__c> listStudent = [SELECT Id FROM Student__c];
        Database.delete(listStudent);
        dataFactory();
        SM_ListStudentPage student   = new SM_ListStudentPage();
        System.assertEquals( 2, student.getTotalPage() );
		Test.stopTest();
	}
    
    // This will get total page
    @isTest static void testGetTotalRecord() {
		Test.startTest();
		SM_ListStudentPage student = new SM_ListStudentPage();
		Test.stopTest();
        System.assertEquals( 10, student.getTotalRecord() );
	}
    
    // test get Status Pick List
	@isTest static void testGetStatusPickList() {
		Test.startTest();
		String returnPickList = SM_ListStudentPage.getStatusPickList();
		Test.stopTest();
		List<Schema.PicklistEntry> statusPickList = (List<Schema.PicklistEntry>)JSON.deserialize(returnPickList, List<Schema.PicklistEntry>.class);
		System.assert(returnPickList.length() > 0 , 'JSON String Pick List should has more than 1 symbols');
		System.assert(statusPickList.size() > 0 , 'Status Pick List should contain more than 1 pick List');
	}
}