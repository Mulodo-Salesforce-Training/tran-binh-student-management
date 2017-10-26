@isTest
private class SM_RegisterStudentTest {
   /* @isTest static void testRegisterStudent01() {
        String  firstName          = 'Tran Hung';
        String  lastName           = 'Binh';
        String  birthday      	   = '1989-01-01 00:00:00';
        String  phone              = '0123456789';
        String  email              = 'tran.binh@mulodo.com';
        String  street             = 'Ly Chinh Thang';
        String  city               = 'HCM';
        String  stateProvince      = '3';
        String  zipPostalCode      = '13';
        String  country            = 'Albania';
        String  Skills             = 'mySQL';
        String  level              = 'leader';
		String  status             = 'working';
        // Implement test code
        Id id                      = MR_CandidateRegister.toRegister(firstName, lastName, birthday, phone, email, street, city, stateProvince, zipPostalCode,
                                                              country, currentCompany, currentlyEmployed, yearsOfExperience, education);
        Candidate__c listCandidate = [SELECT First_Name__c, Last_Name__c, Birthday__c, Phone__c, Email__c, Street__c, City__c, State_Province__c,
                                            Zip_Postal_Code__c, Country__c, Current_Employer__c, Currently_Employed__c, Years_of_Experience__c, Education__c
                                            FROM Candidate__c WHERE Candidate__c.Id =: id];
        System.assertEquals('Tran Hung', listCandidate.First_Name__c);
        System.assertEquals('Binh', listCandidate.Last_Name__c);
        System.assertEquals(Date.parse('01/01/1989'), listCandidate.Birthday__c);
        System.assertEquals('0123456789', listCandidate.Phone__c);
        System.assertEquals('tran.binh@mulodo.com', listCandidate.Email__c);
        System.assertEquals('Ly Chinh Thang', listCandidate.Street__c);
        System.assertEquals('HCM', listCandidate.City__c);
        System.assertEquals('3', listCandidate.State_Province__c);
        System.assertEquals('13', listCandidate.Zip_Postal_Code__c);
        System.assertEquals('Albania', listCandidate.Country__c);
        System.assertEquals('Mulodo', listCandidate.Current_Employer__c);
        System.assertEquals(true, listCandidate.Currently_Employed__c);
        System.assertEquals(3, listCandidate.Years_of_Experience__c);
        System.assertEquals('HS Diploma', listCandidate.Education__c);
    }*/
}