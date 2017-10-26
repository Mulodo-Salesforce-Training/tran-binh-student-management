public class SM_UploadStudentsCC {
    public string nameFile { get; set; }
    public Blob contentFile { get; set; }
    String[] filelines = new String[]{};
    List<Student__c> studentsUpload;

    /**This function reads the CSV file and inserts records into the Student object. **/
    public Pagereference readFile() {
        try {
            //Convert the uploaded file which is in BLOB format into a string
            nameFile  = blobToString( contentFile,'ISO-8859-1');
            //Now sepatate every row of the excel file
            filelines = nameFile.split('\n');
            //Iterate through every line and create a Student record for each row
            studentsUpload = new List<Student__c>();
            for ( Integer i=0;i<filelines.size();i++ ) {
                String[] inputValues = new String[]{};
                inputValues          = filelines[i].split(',');

                Student__c s         = new Student__c();
                s.First_Name__c      = inputValues[0];
                s.Last_Name__c       = inputValues[1];
                Date newDate         = Date.valueOf(inputValues[2]);
                s.Birthday__c        = newDate;
                s.Phone__c           = inputValues[3];
                s.Email__c           = inputValues[4];
                s.Street__c          = inputValues[5];
                s.City__c            = inputValues[6];
                s.State_Province__c  = inputValues[7];
                s.Zip_Postal_Code__c = inputValues[8];
                s.Country__c         = inputValues[9];
                s.Skills__c          = inputValues[10];
                s.Level__c           = inputValues[11];
                s.Status__c          = inputValues[12];
                studentsUpload.add(s);
            }
        } catch(Exception e) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file' + e.getMessage());
            ApexPages.addMessage(errormsg);
        }
        //Finally, insert the collected records
        try {
            insert studentsUpload;
        } catch (Exception e) {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }
        return null;
    }

   /** This function sends back to the visualforce page the list of student records that were inserted **/
    public List<Student__c> getUploadedStudents() {
        if (studentsUpload!= NULL) {
            if (studentsUpload.size() > 0)
                return studentsUpload;
            else
                return null;
        } else {
            return null;
        }
    }
    /** This function convert to String **/
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
}