/**
 * Upload Image for Student
 * Created by tran.binh@mulodo.com on 2017/10/31.
 */
public with sharing class SM_UploadImageCX {

    Private Static FINAL String fixedFileName = 'download.jpg';

    public boolean displaying { get; set; }
    public Student__c pageStudent;
    public transient Blob profilePicFile { get; set; }
    public Id currentPicture { get; set; }

    /**
     * Constructor, grab record, and check/load an existing photo
     */
    public SM_UploadImageCX(ApexPages.StandardController controller) {
        pageStudent = (Student__c)controller.getRecord();
        List<attachment> currentPictures = [SELECT Id FROM Attachment WHERE parentId = :pageStudent.Id AND name = :fixedFileName LIMIT 1];
        if(currentPictures.size() != 0) {
            currentPicture = currentPictures.get(0).Id;
        }

        displaying = true;
    }

    /**
     * toggle switches between the photo display and photo upload form
     */
    public void toggle() {
        displaying = !displaying;
    }

    /**
     * saveFile clears any existing profile picture, retrieves the data from the form
     * and saves it under the relevant filename
     */
    Public Pagereference saveFile() {

        // first, we cannot have any conflicting files
        List<attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :pageStudent.Id AND name = :fixedFileName];
        if(savedPicture.size() > 0) {
            delete savedPicture;
        }

        // Now, we save the new blob
        Attachment attachment = new Attachment(parentId = pageStudent.Id, name = fixedFileName, body = profilePicFile);
        try{
            insert attachment;
            currentPicture = attachment.Id;
            displaying = true;
        } catch(DmlException e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records(Note:only upload file image)'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }
        return null;
    }

    /**
     * get Strings Url of Image
     */
    public String[] getStrings() {
        List<string> imgUrls = new list<string>();
        List<Attachment> attachment = [SELECT id, ContentType FROM Attachment WHERE parentId = :pageStudent.Id AND name = :fixedFileName];
        for(Attachment att : attachment) {
            imgUrls.add('/servlet/servlet.FileDownload?file=' + att.id);
        }
        return imgUrls;
    }
}