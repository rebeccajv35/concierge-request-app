public class LCFormHelper {
    
    public static string fiveSpaces = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
    public static String getQuestionLine(String str)
    {
        return '<dt><br/><h3 style=\"text-align:left;font-size:13px\">' + str  + '</h3></dt>';
    }
    
    public static String getInfoLine(String str)
    {
        return '<dd><h3 style=\"text-align:left;font-size:12px\">' + fiveSpaces + str  + '</h3></dd>';
    }
    
    
    public static String getAnswerLine(String str)
    {
        return '<dd><h5 style=\"color:blue;font-size:12px\">' + fiveSpaces + fiveSpaces + str  + '</h5></dd>';
    }
}