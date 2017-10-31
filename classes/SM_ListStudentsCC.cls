/**
 * List student for test class
 * Created by tran.binh@mulodo.com on 10/31/2017.
 */
global with sharing class SM_ListStudentsCC {
	public Integer totalRecord { get; set; }
	/**
     * test case constructor for total record of list
     */
	public SM_ListStudentsCC() {
		totalRecord = [SELECT Count() FROM Student__c]; // init total record to show on visualforce page
	}

    /**
     * test case query Student Pagination
     */
	@RemoteAction
	global static List<Student__c> queryStudentPagination(Integer pageSize, Integer pageNum) {
		pageNum *= pageSize;
		return [SELECT Name, First_Name__c, Last_Name__c, Birthday__c, Country__c, Phone__c, Email__c, Level__c, Scores__c, Status__c FROM Student__c LIMIT :pageSize OFFSET :pageNum];
	}

    /**
     * test case get Status PickList
     */
	global static String getStatusPickList() {
		Schema.DescribeFieldResult statusField = Student__c.Status__c.getDescribe();
		List<Schema.PicklistEntry> skillPickList = statusField.getPicklistValues();
		return JSON.serialize(skillPickList);
	}

    /**
     * test case change Selected Status
     */
	@RemoteAction
	global static Boolean changeSelectedStatus(String JSONIdList, String status) {
        // Deserialize JSONId List
		List<Id> idList = (List<Id>)JSON.deserialize(JSONIdList, List<Id>.class);
        // Select list of student with id in {idList} and status not equals to {status} yes
		List<Student__c> updateStudent = [SELECT Status__c FROM Student__c WHERE Id IN: idList AND Status__c !=: status];
		for(Student__c student: updateStudent) {
			student.Status__c = status;
		}
        // Update after complete
		List<Database.SaveResult> res = Database.update(updateStudent);
		for (Database.SaveResult each: res) {
			if (each.getErrors().size() > 0 ) {
				return false;
			}
		}
		return true;
	}

    /**
     * test case method to execute batch in VF Page
     */
	global static void batchStudentLevel() {
		if (System.isBatch()) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This action has already executed'));
			return;
		}

		try {
			//Call SM_LevelStudentBatch for Student Level and Skill Executed
			System.scheduleBatch(new SM_LevelStudentBatch(), 'Student Level and Skill Executed',1);
		} catch (AsyncException e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This action has already been scheduled. Detail Message: ' + e.getMessage()));
			return;
		}
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Student Level and Skill will be execute'));
	}
}