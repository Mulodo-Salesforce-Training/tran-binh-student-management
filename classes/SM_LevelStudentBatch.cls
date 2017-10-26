public class SM_LevelStudentBatch implements Database.Batchable<sObject>{
	public System.Iterable<sObject> start(Database.BatchableContext jobId) {
		return [SELECT Scores__c, Level__c FROM Student__c];
	}

	public Void execute(Database.BatchableContext jobId, List<sObject> listLevel) {
		List<Student__c> updateListLevel = new List<Student__c>();
		for(Student__c student: (List<Student__c>)listLevel) {
			if (student.Scores__c >= 400) {
				student.Level__c = 'Leader';
			} else if (student.Scores__c >= 300) {
				student.Level__c = 'Senior';
			} else if (student.Scores__c >= 200) {
				student.Level__c = 'Junior';
			} else if (student.Scores__c >= 0) {
				student.Level__c = 'Fresher';
			}
			updateListLevel.add(student);
		}
		update updateListLevel;
	}
    
	public Void finish(Database.BatchableContext jobId) {
	}
}