public with sharing class SM_RegisterStudentScoringSkillCX {
    // procedure constructor
    public SM_RegisterStudentScoringSkillCX(ApexPages.StandardController controller) {

	}

    @RemoteAction
    public static String toRegister ( Boolean  active,
                                      String   skill,
                                      Decimal  points
                                    ) {

        Student_Scoring_Skill__c studentSkills = new Student_Scoring_Skill__c();
        studentSkills.Active__c                = active;
        studentSkills.Skill__c                 = skill;
        studentSkills.Points__c                = points;

        try {
            insert studentSkills;
        } catch ( DmlException ex ) {
            return ex.getMessage();
        }

        return studentSkills.Skill__c;
    }

    @RemoteAction
	public static String getJSONStudents() {
		// serialize to JSON
		return JSON.serialize([SELECT Active__c, Skill__c, Points__c FROM Student_Scoring_Skill__c]);
	}

    @RemoteAction
	public static String getSkillPickList() {
		Schema.DescribeFieldResult fieldSkill = Student_Scoring_Skill__c.Skill__c.getDescribe();
		List<Schema.PicklistEntry> pickListSkill = fieldSkill.getPicklistValues();
		return JSON.serialize(pickListSkill);
    }
}