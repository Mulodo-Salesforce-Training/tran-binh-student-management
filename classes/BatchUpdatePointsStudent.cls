global class BatchUpdatePointsStudent implements Database.Batchable<sObject> {
	public Map<String, Student_Scoring_Skill__c> getAllSkills() {
		Map<String, Student_Scoring_Skill__c> skillMap = new Map<String, Student_Scoring_Skill__c>();
		List<Student_Scoring_Skill__c> allSkills = [SELECT  Id, Skill__c FROM Student_Scoring_Skill__c];
		// init skillMap when create a batch
		for(Student_Scoring_Skill__c skill: allSkills) {
			skillMap.put(skill.Skill__c, skill);
		}
        system.debug(skillMap);
		return skillMap;
	}

	public System.Iterable<sObject> start(Database.BatchableContext jobId) {
		return [SELECT Id, Skills__c, (SELECT  Student_Scoring_Skills__c.Student_ID__c, Student_Scoring_Skills__c.Student_Skill__c 
                                       FROM Student_Scoring_Skills__r)  FROM Student__c WHERE Skills__c != NULL];
	}

	public void execute(Database.BatchableContext jobId, List<sObject> recordList) {
		Map<String, Student_Scoring_Skill__c> skillMap = getAllSkills(); // skill Map to get skill by skillName

		List<Student_Scoring_Skills__c> insertStudentSkill = new List<Student_Scoring_Skills__c>(); // scoring list going to be inserted

		for(Student__c student: (List<Student__c>)recordList) {
			List<String> studentSkill = student.Skills__c.split('\\;'); // seperate multiPickList student skill values
			if (studentSkill.size() > 0) {
				// IF STUDENT ALREADY HAS SCORING SKILL IN LIST NEED TO CHECK EXISTED SKILL IN SCORING
				if (student.Student_Scoring_Skills__r.size() > 0 ) {
					Set<String> needToAddSkill = new Set<String>(studentSKill); // Set to control which skill need to be added
					for(String skill: studentSkill) {
						// CHECK IF STUDENT SCORING SKILL == SKILLMAP MEANS THAT SCORING ALREADY EXIST
						for(Student_Scoring_Skills__c studentScoring: Student.Student_Scoring_Skills__r) {
							if (studentScoring.Student_Skill__c == skillMap.get(skill).Id) {
								// REMOVE ALL EXISTED SCORING FROM NEED TO ADD SKILL LIST
								needToAddSkill.remove(skill);
							}
						}
					}
					// ADD EACH ITEM TO THE INSERT LIST
					for(String skillInsert: needToAddSkill) {
                        system.debug(student.Id);
                        system.debug(skillMap.get(skillInsert).Id);
						insertStudentSkill.add(new Student_Scoring_Skills__c(
							Student_ID__c = student.Id,
							Student_Skill__c = skillMap.get(skillInsert).Id
						));
					}

				} else {
					// IF STUDENT NOT HAS SCORING SKILL
					for(String skill: studentSkill) {
                        system.debug(student.Id);
                        system.debug(skillMap.get(skill).Id);
						insertStudentSkill.add(new Student_Scoring_Skills__c(
								Student_ID__c = student.Id,
								Student_Skill__c = skillMap.get(skill).Id
						));				
                        system.debug(insertStudentSkill);
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
	public Void finish(Database.BatchableContext jobId) {
	}
}