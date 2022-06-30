public class CheckRecursion 
{
    // this is a utility class to ensure that triggers only executes one time
    
    private static boolean run  = true;
    
    public static boolean runOnce()
    {
        if(run)
        {
            run = false;
            return true;
        }
        else
        {
            return run;
        }
        
    }
    
}