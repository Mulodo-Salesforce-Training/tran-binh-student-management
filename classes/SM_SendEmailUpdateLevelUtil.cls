/**
 * Send Email when click button update Level
 * Created by tran.binh@mulodo.com on 2017/10/25.
 */
public class SM_SendEmailUpdateLevelUtil {

    /**
     * Send Mail Admin Method using Template from SF
     */
	public static void sendMailAdminUsingSFTemplate(User user, String templateName) {
		if (user == null) {
            return;
        }
        // skipped if student is null
		EmailTemplate emailTemplate;

		try {
            // select Id of template Email
			emailTemplate = [SELECT Id FROM EmailTemplate WHERE Name=: templateName];
		} catch(QueryException e) {
            system.debug('Load template error: ' + e.getMessage());
		}
		// select a dummy contact
		Contact contact = [select id, Email from Contact where email <> null limit 1];
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); // mail content will be sent
		List<Messaging.SingleEmailMessage>  willRollBackMailList = new List<Messaging.SingleEmailMessage>(); // email in this list will not be sent
		List<Messaging.SingleEmailMessage>  willSendMailList = new List<Messaging.SingleEmailMessage>();
		//Add information of user send email
		mail.setToAddresses(new List<String> {user.Email});
		mail.setTargetObjectId(contact.Id);
		mail.setTemplateID(emailTemplate.Id);
		mail.setSaveAsActivity(false);
		willRollBackMailList.add(mail);
		sendEmailUsingTemplateAfterRollBack(willRollBackMailList);
	}

    /**
     * Send Mail To Student Using SF Template Method
     */
	public static void sendMailToStudentUsingSFTemplate(List<Student__c> students, String templateName) {
		// skipped if students == null
        if (students == null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email will not be sent because of empty student List'));
			return;
		}
		EmailTemplate emailTemplate;
        // email in this list will not be sent
		List<Messaging.SingleEmailMessage>  willRollBackMailList = new List<Messaging.SingleEmailMessage>();
		List<Messaging.SingleEmailMessage>  willSendMailList = new List<Messaging.SingleEmailMessage>();
		try {
			emailTemplate = [SELECT Id FROM EmailTemplate WHERE Name=: templateName];
		} catch(QueryException e) {
			system.debug('Load template error: ' + e.getMessage());
		}

		for(Student__c receiver: students) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); // mail content will be sent
			// Select a dummy contact
			Contact contact = [select id, Email from Contact where email <> null limit 1];
			mail.setToAddresses(new List<String> {receiver.Email__c});
			mail.setTargetObjectId(contact.Id);
			mail.setTemplateID(emailTemplate.Id);
			mail.setSaveAsActivity(false);
			mail.setWhatId(receiver.Id); // Id Of Student assign
			willRollBackMailList.add(mail);
		}
		//Rollback mail list
		sendEmailUsingTemplateAfterRollBack(willRollBackMailList);
	}

    /**
     * Send Mail Using Template After RollBack Method
     */
	private static void sendEmailUsingTemplateAfterRollBack(List<Messaging.SingleEmailMessage> emails) {
		Savepoint savepoints = Database.setSavepoint();
		Messaging.sendEmail(emails);
		Database.rollback(savepoints);
		List<Messaging.SingleEmailMessage> willSendMailList = new List<Messaging.SingleEmailMessage>();
		for(Messaging.SingleEmailMessage emailList: emails) {
			Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
			emailToSend.setToAddresses(emailList.getToAddresses());
			emailToSend.setPlainTextBody(emailList.getPlainTextBody());
			emailToSend.setHtmlBody(emailList.getHtmlBody());
			emailToSend.setSubject(emailList.getSubject());
			willSendMailList.add(emailToSend);
		}
		Messaging.sendEmail(willSendMailList);
	}
}