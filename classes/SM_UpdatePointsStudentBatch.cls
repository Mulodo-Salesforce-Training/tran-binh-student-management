/**
 * Batch update points for student
 * Created by tran.binh@mulodo.com on 10/31/2017.
 */
global class SM_UpdatePointsStudentBatch implements Database.Batchable<sObject> {

    /**
     * get all skill of Student_Scoring_Skill__c
     */
	public Map<String, Student_Scoring_Skill__c> getAllSkills() {
		Map<String, Student_Scoring_Skill__c> skillMap = new Map<String, Student_Scoring_Skill__c>();
		List<Student_Scoring_Skill__c> allSkills       = [SELECT  Id, Skill__c, Points__c FROM Student_Scoring_Skill__c];
		// init skillMap when create a batch
		for( Student_Scoring_Skill__c skill: allSkills ) {
			skillMap.put(skill.Skill__c, skill);
		}
		return skillMap;
	}

	/**
     * start run query on database
     * @param: jobId (type: Database.BatchableContext)
     */
	public System.Iterable<sObject> start(Database.BatchableContext jobId) {
        //Return student have Skills__c not null
		return [SELECT Id, Skills__c, (SELECT  Student_Scoring_Skills__c.Student_ID__c, Student_Scoring_Skills__c.Student_Skill__c FROM Student_Scoring_Skills__r)  FROM Student__c WHERE Skills__c != NULL];
	}

	/**
     * execute batch for insert record to Student Scoring Skills
     * @param: jobId (type: Database.BatchableContext)
     * @param: recordList (type: List<sObject>)
     */
	public void execute(Database.BatchableContext jobId, List<sObject> recordList) {
        // skill Map to get skill by skillName
		Map<String, Student_Scoring_Skill__c> skillMap = getAllSkills();
		// scoring list going to be inserted
		List<Student_Scoring_Skills__c> insertStudentSkill = new List<Student_Scoring_Skills__c>();

		for(Student__c student: (List<Student__c>)recordList) {
            // seperate multiPickList student skill values
			List<String> studentSkill  = student.Skills__c.split('\\;');
            Set<String> needToAddSkill = new Set<String>(studentSKill);

			if (studentSkill.size() > 0) {
				if (student.Student_Scoring_Skills__r.size() > 0 ) {
					for(String skill: studentSkill) {
						// Check Student exist on Student scoring skills
						for(Student_Scoring_Skills__c studentScoring: Student.Student_Scoring_Skills__r) {
							if (studentScoring.Student_Skill__c == skillMap.get(skill).Id) {
								// Remove skill existed from needToAddSkill list
								needToAddSkill.remove(skill);
							}
						}
					}
					// Add record with skill is insert list.
					for(String skillInsert: needToAddSkill) {
                        if( student.Id != null && skillMap.get(skillInsert).Id != null ){
                            insertStudentSkill.add(new Student_Scoring_Skills__c(
							Student_ID__c = student.Id,
							Student_Skill__c = skillMap.get(skillInsert).Id,
                            Points__c = skillMap.get(skillInsert).Points__c
						));
                        }
					}
				} else {
					// Add new Student.
					for(String skill: studentSkill) {

                        if( student.Id != null && skillMap.get(skill).Id != null ){
                            insertStudentSkill.add(new Student_Scoring_Skills__c(
                            Student_ID__c = student.Id,
                            Student_Skill__c = skillMap.get(skill).Id,
                            Points__c = skillMap.get(skill).Points__c
                            ));
                        }
                    }
				}
			}

            try {
                //Insert record to Student Scoring Skills
                insert insertStudentSkill;
            } catch (DmlException e) {

                //Error message of DmlException when insert error.
                system.debug('error:' + e.getMessage());
            }
		}
	}

    /**
     * finish run batch
     * @param: jobId (type: Database.BatchableContext)
     */
	public Void finish(Database.BatchableContext jobId) {
	}
}