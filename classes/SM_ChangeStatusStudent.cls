global with sharing class SM_ChangeStatusStudent {

	@RemoteAction
	global static Boolean changeSelectedStatus(String JSONIdList, String status) {
		List<Id> idList = (List<Id>)JSON.deserialize(JSONIdList, List<Id>.class); // deserialize JSONId List
		List<Student__c> updateStudent = [SELECT Status__c FROM Student__c WHERE Id IN: idList AND Status__c !=: status]; // select list of student with id in {idList} and status not equals to {status} yes
		for(Student__c student: updateStudent) {
			student.Status__c = status;
		}
		List<Database.SaveResult> res = Database.update(updateStudent); // update after complete
		for (Database.SaveResult each: res) {
			if (each.getErrors().size() > 0 ) {
				return false;
			}
		}
		return true; // everything ok
	}
}