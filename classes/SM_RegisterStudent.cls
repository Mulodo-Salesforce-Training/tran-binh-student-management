public with sharing class SM_RegisterStudent {
  // procedure constructor
  public SM_RegisterStudent(ApexPages.StandardController controller) {

	}

  @RemoteAction
  public static String toRegister ( String  firstName,
                                    String  lastName,
                                    Date    birthday,
                                    String  phone,
                                    String  email,
                                    String  street,
                                    String  city,
                                    String  stateProvince,
                                    String  zipPostalCode,
                                    String  country,
                                    String  skills,
                                    String  level,
                                    String  status
                                    ) {

    Student__c students          = new Student__c();
    students.First_Name__c       = firstName;
    students.Last_Name__c        = lastName;
    students.Birthday__c         = birthday;
    students.Phone__c            = phone;
    students.Email__c            = email;
    students.Street__c           = street;
    students.City__c             = city;
    students.State_Province__c   = stateProvince;
    students.Zip_Postal_Code__c  = zipPostalCode;
    students.Country__c          = country;
    students.Skills__c           = skills;
    students.Level__c            = level;
    students.Status__c           = status;

    try {
        insert students;
    } catch ( DmlException ex ) {
        return ex.getMessage();
    }

    return students.First_Name__c;
  }

  @RemoteAction
	public static String getJSONStudents() {
		// serialize to JSON
		return JSON.serialize([SELECT Active__c, Skill__c, Points__c FROM Student_Scoring_Skill__c]);
	}
}