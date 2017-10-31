/**
 * Batch update Level for student
 * Created by tran.binh@mulodo.com on 10/31/2017.
 */
public class SM_LevelStudentBatch implements Database.Batchable<sObject>{

	/**
     * start run query on database
     * @param: jobId (type: Database.BatchableContext)
     */
	public System.Iterable<sObject> start(Database.BatchableContext jobId) {
		return [SELECT Scores__c, Level__c FROM Student__c];
	}

	/**
     * execute batch for check condition to  Level of Student__c
     * @param: jobId (type: Database.BatchableContext)
     * @param: listLevel (type: List<sObject>)
     */
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

	/**
     * finish run batch
     * @param: jobId (type: Database.BatchableContext)
     */
	public Void finish(Database.BatchableContext jobId) {
        AsyncApexJob job = [SELECT Id, CreatedById, TotalJobItems FROM AsyncApexJob WHERE  Id =: jobId.getJobId()];
        User user   = [SELECT Id, Email FROM User WHERE Id =: job.CreatedById];
        List<Student__c> listStudents  = [SELECT Email__c FROM Student__c];
        String emailTemplate = 'Send Email Students';
        try {
            SM_SendEmailUpdateLevelUtil.sendMailAdminUsingSFTemplate(user, emailTemplate);
            SM_SendEmailUpdateLevelUtil.sendMailToStudentUsingSFTemplate(listStudents, emailTemplate);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured: '+ e.getMessage()));
        }
	}
}