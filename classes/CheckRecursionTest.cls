@isTest
public class CheckRecursionTest 
{
    static testMethod void testCheckRecursion()
    {
        system.assert(CheckRecursion.runOnce());
        system.assert(!CheckRecursion.runOnce());
    }

}