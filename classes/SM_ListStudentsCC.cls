global with sharing class SM_ListStudentsCC {
	public Integer totalRecord { get; set; }
	public SM_ListStudentsCC() {
		totalRecord = [SELECT Count() FROM Student__c]; // init total record to show on visualforce page
	}
	// using in SM_StudentListPage
	@RemoteAction
	global static List<Student__c> queryStudentPagination(Integer pageSize, Integer pageNum) {
		pageNum *= pageSize;
		return [SELECT Name, First_Name__c, Last_Name__c, Birthday__c, Country__c, Phone__c, Email__c, Level__c, Scores__c, Status__c FROM Student__c LIMIT :pageSize OFFSET :pageNum];
	}
    // @RemoteAction
	global static String getStatusPickList() {
		Schema.DescribeFieldResult statusField = Student__c.Status__c.getDescribe();
		List<Schema.PicklistEntry> skillPickList = statusField.getPicklistValues();
		return JSON.serialize(skillPickList);
	}

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
    
    // method to execute batch in VF Page
	global static void batchStudentLevel() {
		if (System.isBatch()) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This action has already executed'));
			return;
		}

		try {
			System.scheduleBatch(new SM_LevelStudentBatch(), 'Student Level and Skill Executed',1);
		} catch (AsyncException e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This action has already been scheduled. Detail Message: ' + e.getMessage()));
			return;
		}
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Student Level and Skill will be execute'));
	}
}