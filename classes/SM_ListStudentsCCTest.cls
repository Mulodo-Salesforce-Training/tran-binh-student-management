/**
 * List students for test class
 * Created by tran.binh@mulodo.com on 10/31/2017.
 */
@isTest
private class SM_ListStudentsCCTest {

    /**
     * test case set up student data for pagination test
     */
	@testSetup static void dataFactory() {
		List<Student__c> mockStudentList = new List<Student__c>();
		for (Integer i = 0; i < 10; i++) {
			mockStudentList.add(new Student__c(
				First_Name__c = 'Tran' + i,
				Last_Name__c  = 'Binh' + i,
                Phone__c      = '01656259452',
				Email__c      = 'tran.binh@mulodo.com'
			));
		}
		insert mockStudentList;
	}

    /**
     * test case constructor for total record of list student
     */
	@isTest static void testConstructor() {
		SM_ListStudentsCC customController = new SM_ListStudentsCC();
		System.assert(customController.totalRecord == 10, 'Should return exact number of inserted students');
	}

    /**
     * test case get student by page size and number of page
     */
	@isTest static void testQueryStudentPagination() {
		List<Student__c> firstTenRow = SM_ListStudentsCC.queryStudentPagination(10, 0);
		System.assert(firstTenRow.size() == 10 , 'Should return only 10 records');
		System.assert(firstTenRow[0].First_Name__c.equals('Tran0'), 'Expect the first Records FirstName is Tran0');
		System.assert(firstTenRow[9].First_Name__c.equals('Tran9'), 'Expect the last records FirstName is Tran9');
	}

    /**
     * test case Output Of BoundException
     */
	@isTest static void testOutOfBoundException() {
		List<Student__c> thirdTenRow     = SM_ListStudentsCC.queryStudentPagination(10, 4);
		List<Student__c> secondTwentyRow = SM_ListStudentsCC.queryStudentPagination(40, 2);
		System.assert(thirdTenRow.isEmpty(), 'Should return null if outOfBound'); // must be check isEmpty instead of compare with null;
		System.assert(secondTwentyRow.isEmpty(), 'Should return null if outOfBound');
	}

    /**
     * test case test get Status Pick List
     */
	@isTest static void testGetStatusPickList() {
		Test.startTest();
		String returnPickList = SM_ListStudentsCC.getStatusPickList();
		Test.stopTest();
		List<Schema.PicklistEntry> statusPickList = (List<Schema.PicklistEntry>)JSON.deserialize(returnPickList, List<Schema.PicklistEntry>.class);
		System.assert(returnPickList.length() > 0 , 'JSON String Pick List should has more than 1 symbols');
		System.assert(statusPickList.size() > 0 , 'Status Pick List should contain more than 1 pick List');
	}

    /**
     * test case Change Selected Status
     */
	@isTest static void testChangeSelectedStatus() {
		List<Id> targetIdList = new List<Id>();
		for(Student__c student: [SELECT Status__c FROM Student__c LIMIT 1]) {
			targetIdList.add(student.Id);
		}

		SM_ListStudentsCC.changeSelectedStatus(JSON.serialize(targetIdList), 'Working');

		Student__c updateStudent = [SELECT Status__c FROM Student__c WHERE Id =: targetIdList[0]];
		System.assert(updateStudent.Status__c == 'Working', 'Student with id : ' + updateStudent.Id + ' should has status is working after update');
	}

    /**
     * test case Student Level Batch Execute
     */
	@isTest static void testStudentLevelBatchExecute() {
		SM_ListStudentsCC.batchStudentLevel();
		System.assert(!System.isBatch(), 'Batch is execute after 1 minutes');
		try {
			SM_ListStudentsCC.batchStudentLevel(); // execute 2nd time
		} catch (AsyncException e) {
			System.assert(e.getMessage() != null, 'Will error if try to execute 2nd time');
		}
	}
}