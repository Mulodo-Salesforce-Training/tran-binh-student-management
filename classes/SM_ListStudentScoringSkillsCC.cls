public with sharing class SM_ListStudentScoringSkillsCC {
     // the size of list per page
    public final Integer LIST_SIZE_PAGE = 5;
    public Integer count { get; set; }
    public Integer totalSize { get; set; }
    public String action { get; set; }
    
    // custom size of list per page will be changed be user
    public Integer customListSize { get; set; }
    public List< Student_Scoring_Skills__c > students {
        get {
            //Correct count after change size of list
            if ( math.mod( count, customListSize ) != 0 ) {
                count -= math.mod( count, customListSize );
            }
            return [SELECT Name, Points__c, Student_ID__r.Name, Student_ID__r.Last_Name__c, Student_Skill__r.Name, Student_Skill__r.Skill__c
                    FROM Student_Scoring_Skills__c
                    LIMIT: customListSize
                    OFFSET: count];
        }
    }

    // Set the total size in the constructor
    public SM_ListStudentScoringSkillsCC () {
        totalSize      = [SELECT count() FROM Student_Scoring_Skills__c];
        count          = 0;
        customListSize = LIST_SIZE_PAGE;
    }

    //result when click button First, Previous, Next, End
     public PageReference selectAction () {

         //get paramater from apex with action click
         String action = Apexpages.currentPage().getParameters().get('paramValue');

        if(action == 'First') {
            count = 0;
        } else if(action == 'Previous') {
            count -= customListSize;
        } else if(action == 'Next') {
            count += customListSize;
        } else if(action == 'End') {
            Integer mod = math.mod( totalSize, customListSize );
        	count = mod != 0 ? totalSize - mod : totalSize - customListSize;
        }
        return null;
    }

    // This will disable the previous and first buttons
    public Boolean getDisablePrevious () {
        return count > 0 ? false : true;
    }

    // This will disable the next and end buttons
    public Boolean getDisableNext () {
        if ( count + customListSize < totalSize ) {
            return false;
        }
            return true;
    }

    // This will get current page
    public Integer getCurrentPage () {
        if( totalSize == 0 ){
            return 0;
        }
        return count / customListSize + 1;
    }

    // This will get current page
    public Integer getTotalPage () {
        if( totalSize == 0){
            return 0;
        } else if( customListSize >= totalSize ) {
            return 1;
        } else if( math.mod( totalSize, customListSize ) != 0) {
        	return totalSize / customListSize + 1;
        }
        return totalSize / customListSize;
    }

    //This will get total record
    public Integer getTotalRecord () {
        return totalSize;
    }
}