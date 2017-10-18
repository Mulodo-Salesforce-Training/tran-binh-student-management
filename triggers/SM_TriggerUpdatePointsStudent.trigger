trigger SM_TriggerUpdatePointsStudent on Student__c (after insert, after update) {
    
	if (!system.isBatch() && !system.isFuture()) {
		BatchUpdatePointsStudent executeBatchUpdatePoints = new BatchUpdatePointsStudent();
		if( trigger.isInsert && trigger.isAfter ) {
			Database.executeBatch(executeBatchUpdatePoints);
        } else if( trigger.isUpdate && trigger.isAfter ){
			Database.executeBatch(executeBatchUpdatePoints);
        }
	}
}