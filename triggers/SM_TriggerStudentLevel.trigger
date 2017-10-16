trigger SM_TriggerStudentLevel on Student__c (before insert, before update ) {
    if (trigger.isInsert) {
        for (Student__c act: Trigger.new)
        {
            if(act.Scores__c > 0 && act.Scores__c < 200) {
                act.Level__c = 'Fresher';
            } else if(act.Scores__c > 199 && act.Scores__c < 300) {
                act.Level__c = 'Junior';
            } else if(act.Scores__c > 299 && act.Scores__c < 400) {
                act.Level__c = 'Senior';
            } else if(act.Scores__c > 400) {
                act.Level__c = 'Leader';
            }
        }
    } else if(trigger.isUpdate) {
        for (Student__c act: Trigger.new)
        {
            if(act.Scores__c > 0 && act.Scores__c < 200) {
                act.Level__c = 'Fresher';
            } else if(act.Scores__c > 199 && act.Scores__c < 300) {
                act.Level__c = 'Junior';
            } else if(act.Scores__c > 299 && act.Scores__c < 400) {
                act.Level__c = 'Senior';
            } else if(act.Scores__c > 400) {
                act.Level__c = 'Leader';
            }
        }
    }
}