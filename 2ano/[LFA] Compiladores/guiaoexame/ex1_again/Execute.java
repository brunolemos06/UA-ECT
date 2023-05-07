import java.util.HashMap;
import java.util.Scanner;

public class Execute extends StrLangBaseVisitor<String> {
   HashMap<String,String> mapa = new HashMap<>();
   Scanner sc = new Scanner(System.in);
   @Override public String visitPrint(StrLangParser.PrintContext ctx) {
      String word = visit(ctx.expr());
      if(word == null ) return null;
      System.out.println(word);
      return "";
   }

   @Override public String visitAssign(StrLangParser.AssignContext ctx) {
      String word = visit(ctx.expr());
      if(word.charAt(0) == '"' && word.charAt(word.length()-1) == '"')
         word = word.substring(1, word.length()-1);
      mapa.put(ctx.ID().getText(), word);
      return "";
   }

   @Override public String visitExprString(StrLangParser.ExprStringContext ctx) {
      return ctx.STRING().getText().substring(1,ctx.STRING().getText().length()-1);
   }

   @Override public String visitExprInput(StrLangParser.ExprInputContext ctx) {
      String word = ctx.STRING().getText();
      return sc.nextLine();
   }

   @Override public String visitExprParent(StrLangParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public String visitExprAdd(StrLangParser.ExprAddContext ctx) {
      String op1 = visit(ctx.expr(0));
      String op2 = visit(ctx.expr(1));
      return op1.concat(op2);
   }
   @Override public String visitExprSub(StrLangParser.ExprSubContext ctx) {
      String op1 = visit(ctx.expr(0));
      String op2 = visit(ctx.expr(1));
      return op1.replaceAll(op2,"");
   }
   @Override public String visitExprTrim(StrLangParser.ExprTrimContext ctx) {
      String op = visit(ctx.expr());
      return op.trim();
      
   }
   @Override public String visitExprSubstituicao(StrLangParser.ExprSubstituicaoContext ctx) {
      String main = visit(ctx.expr(0));
      String target = visit(ctx.expr(1));
      String replacement = visit(ctx.expr(2));
      return main.replace(target, replacement);
   }
   

   @Override public String visitExprID(StrLangParser.ExprIDContext ctx) {
      String id = ctx.ID().getText();
      if(mapa.containsKey(id)){
         return mapa.get(id);
      }
      System.err.printf("ERRO: não existe a variável \"%s\"\n",id);
      return null;
   }

}
