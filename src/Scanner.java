import java.io.*;
import java.lang.reflect.*;
import java.nio.charset.StandardCharsets;

public class Scanner {
    private static String getTokenName(int token){
        try{
            Field[] tokenNames = sym.class.getFields();
            for(Field tokenName : tokenNames){
                if(tokenName.getInt(null)== token){
                    return tokenName.getName();
                }
            }
        }catch (Exception e){
            e.printStackTrace(System.err);
        }
        return "Unknown Token";
    }
    public static String vcScanFile(File file) throws Exception{
        VCScanner scanner;
        String output = "";
        try {
            FileInputStream stream = new FileInputStream(file);
            Reader reader = new InputStreamReader(stream, StandardCharsets.US_ASCII);
            scanner = new VCScanner(reader);
            while (!scanner.yyatEOF()) {// not end

                VCSymbol s = (VCSymbol) scanner.next_token();
                if (s.sym == 0) { // Reached end of file
                    break;
                }
                String tokenName = getTokenName(s.sym);

                output += tokenName + " " + s.getCharacter() +"\n";

            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return output;
    }


}
