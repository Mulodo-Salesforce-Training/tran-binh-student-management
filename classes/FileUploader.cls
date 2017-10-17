public class FileUploader 
{
    public string nameFile {get;set;}
    public Blob contentFile {get;set;}
    String[] filelines = new String[]{};
    List<Student__c> stdstoupload;
    
    /***This function reads the CSV file and inserts records into the Student object. ***/
    public Pagereference ReadFile()
    {
        try {
                //Convert the uploaded file which is in BLOB format into a string
                nameFile  = blobToString( contentFile,'ISO-8859-1');
                //Now sepatate every row of the excel file
                filelines = nameFile.split('\n');
                //Iterate through every line and create a Student record for each row
                stdstoupload = new List<Student__c>();
                for ( Integer i=0;i<filelines.size();i++ )
                {
                    String[] inputvalues = new String[]{};
                    inputvalues          = filelines[i].split(',');
                    
                    Student__c s         = new Student__c();
                    s.First_Name__c      = inputvalues[0];
                    s.Last_Name__c       = inputvalues[1];  
                    Date newDate         = Date.valueOf(inputvalues[2]);
                    s.Birthday__c        = newDate; 
                    s.Phone__c           = inputvalues[3];
                    s.Email__c           = inputvalues[4];
                    s.Street__c          = inputvalues[5];
                    s.City__c            = inputvalues[6];
                    s.State_Province__c  = inputvalues[7];
                    s.Zip_Postal_Code__c = inputvalues[8];
                    s.Country__c         = inputvalues[9];
                    s.Skills__c          = inputvalues[10];
                    s.Level__c           = inputvalues[11];
                    s.Status__c          = inputvalues[12];
                    stdstoupload.add(s);
                }
         }
         catch(Exception e){
                 ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file' + e.getMessage());
                ApexPages.addMessage(errormsg);
         }       
        //Finally, insert the collected records
        try {
            insert stdstoupload;
            
        }
        catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }    
        return null;
    }
   
   /**** This function sends back to the visualforce page the list of student records that were inserted ****/ 
    public List<Student__c> getuploadedStudents()
    {
        if (stdstoupload!= NULL)
            if (stdstoupload.size() > 0)
                return stdstoupload;
            else
                return null;                    
        else
            return null;
    }  
        /**
         This function convers the input CSV file in BLOB format into a string
        @param input    Blob data representing correct string in @inCharset encoding
        @param inCharset    encoding of the Blob data (for example 'ISO 8859-1')
     */
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