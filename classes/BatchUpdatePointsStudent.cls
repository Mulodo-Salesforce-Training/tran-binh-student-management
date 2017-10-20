global class BatchUpdatePointsStudent implements Database.Batchable<sObject> {
	public Map<String, Student_Scoring_Skill__c> getAllSkills() {
		Map<String, Student_Scoring_Skill__c> skillMap = new Map<String, Student_Scoring_Skill__c>();
		List<Student_Scoring_Skill__c> allSkills = [SELECT  Id, Skill__c, Points__c FROM Student_Scoring_Skill__c];
		// init skillMap when create a batch
		for( Student_Scoring_Skill__c skill: allSkills ) {
			skillMap.put(skill.Skill__c, skill);
		}
		return skillMap;
	}

	public System.Iterable<sObject> start(Database.BatchableContext jobId) {
		return [SELECT Id, Skills__c, (SELECT  Student_Scoring_Skills__c.Student_ID__c, Student_Scoring_Skills__c.Student_Skill__c FROM Student_Scoring_Skills__r)  FROM Student__c WHERE Skills__c != NULL];
	}

	public void execute(Database.BatchableContext jobId, List<sObject> recordList) {
        // skill Map to get skill by skillName
		Map<String, Student_Scoring_Skill__c> skillMap = getAllSkills();
		// scoring list going to be inserted
		List<Student_Scoring_Skills__c> insertStudentSkill = new List<Student_Scoring_Skills__c>();

		for(Student__c student: (List<Student__c>)recordList) {
            // seperate multiPickList student skill values
			List<String> studentSkill = student.Skills__c.split('\\;');
            Set<String> needToAddSkill = new Set<String>(studentSKill);

			if (studentSkill.size() > 0) {
				if (student.Student_Scoring_Skills__r.size() > 0 ) {
					for(String skill: studentSkill) {
						// CHECK IF STUDENT SCORING SKILL EQUALS SKILLMAP MEANS THAT SCORING ALREADY EXIST
						for(Student_Scoring_Skills__c studentScoring: Student.Student_Scoring_Skills__r) {
							if (studentScoring.Student_Skill__c == skillMap.get(skill).Id) {
								// REMOVE ALL EXISTED SCORING FROM NEED TO ADD SKILL LIST
								needToAddSkill.remove(skill);
							}
						}
					}
					// ADD EACH ITEM TO THE INSERT LIST
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
					// IF STUDENT NOT HAS SCORING SKILL
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
                insert insertStudentSkill;
            } catch (DmlException e) {
                system.debug('error:' + e.getMessage());
            }
		}
	}

	public Void finish(Database.BatchableContext jobId) {
	}
}