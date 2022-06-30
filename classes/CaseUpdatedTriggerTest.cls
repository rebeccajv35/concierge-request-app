@isTest public class CaseUpdatedTriggerTest {
    
    @isTest static void testTriggerAfterUpdate() {
    
        Case testCase1 = new Case(Subject = 'Testing', recordtypeid = '01234000000YMxcAAG');
    	insert testCase1;
        testCase1.Description = 'test_Desc';
        update testCase1;

    }
}