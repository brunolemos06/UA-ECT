import java.io.IOException;
import java.util.Scanner;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;


public class FracLangMain {
   public static void main(String[] args) {
      for(String file : args){
         try {
            Scanner sc = new Scanner(System.in);
            String lineText = null;
            int numLine = 1;
            if (sc.hasNextLine())
               lineText = sc.nextLine();
            FracLangParser parser = new FracLangParser(null);
            // replace error listener:
            //parser.removeErrorListeners(); // remove ConsoleErrorListener
            //parser.addErrorListener(new ErrorHandlingListener());
            Execute visitor0 = new Execute();
            while(lineText != null) {
               // create a CharStream that reads from standard input:
               CharStream input = CharStreams.fromFileName(file);
               // create a lexer that feeds off of input CharStream:
               FracLangLexer lexer = new FracLangLexer(input);
               lexer.setLine(numLine);
               lexer.setCharPositionInLine(0);
               // create a buffer of tokens pulled from the lexer:
               CommonTokenStream tokens = new CommonTokenStream(lexer);
               // create a parser that feeds off the tokens buffer:
               parser.setInputStream(tokens);
               // begin parsing at program rule:
               ParseTree tree = parser.program();
               if (parser.getNumberOfSyntaxErrors() == 0) {
                  // print LISP-style tree:
                  // System.out.println(tree.toStringTree(parser));
                  visitor0.visit(tree);
               }
               if (sc.hasNextLine())
                  lineText = sc.nextLine();
               else
                  lineText = null;
               numLine++;
            }
         }
         catch(RecognitionException e) {
            e.printStackTrace();
            System.exit(1);
         }catch(IOException e){
            System.err.printf("File %s not found!\n",file);
            System.exit(1);
         }
      }
   }
}
