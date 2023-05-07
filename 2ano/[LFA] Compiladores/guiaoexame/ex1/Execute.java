import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Scanner;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

import javax.swing.plaf.synth.SynthSpinnerUI;

public class Execute extends StrLangBaseVisitor<String> {
   private static Scanner sc;
   HashMap<String, String> map = new HashMap<>();
   @Override public String visitProgram(StrLangParser.ProgramContext ctx) {
      return visitChildren(ctx);
   }

   @Override public String visitStatDecl(StrLangParser.StatDeclContext ctx) {
      return visit(ctx.decl());
   }

   @Override public String visitStatPrint(StrLangParser.StatPrintContext ctx) {
      visit(ctx.print());
      return "";
   }

   @Override public String visitDecl(StrLangParser.DeclContext ctx) {
      String res = visit(ctx.expr());
      String ID = ctx.ID().getText();
      //System.out.printf("ID:%s | valor:%s\n",ID,res);
      if(res != null) map.put(ID,res);
      return "";
   }

   @Override public String visitPrint(StrLangParser.PrintContext ctx) {
      String elemento = visit(ctx.expr());
      if(elemento != null){
         System.out.println(elemento);
         return elemento;
      }
      return "";
   }

   @Override public String visitExprReplace(StrLangParser.ExprReplaceContext ctx) {
      String word1 = visit(ctx.expr(0));
      String word2 = visit(ctx.expr(1));
      String word3 = visit(ctx.expr(2));

      return word1.replace(word2,word3);
   }

   @Override public String visitExprString(StrLangParser.ExprStringContext ctx) {
      String res = ctx.STRING().getText();
      return res.substring(1, res.length()-1);
   }

   @Override public String visitExprParent(StrLangParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public String visitExprSub(StrLangParser.ExprSubContext ctx) {
      String word1 = visit(ctx.expr(0));
      String word2 = visit(ctx.expr(1));
      return word1.replace(word2, "");
   }

   @Override public String visitExprInput(StrLangParser.ExprInputContext ctx) {
      System.out.print(visit(ctx.expr()));
      String s =null;
      while(sc.hasNextLine()){
         s = sc.nextLine();
         return s;
      }
      return null;
   }

   @Override public String visitExprTrim(StrLangParser.ExprTrimContext ctx) {
      String elemento = visit(ctx.expr());
      return elemento.replace(" ", "");
   }
   @Override public String visitExprID(StrLangParser.ExprIDContext ctx) {
      String elemento = ctx.ID().getText();
      if(map.containsKey(elemento)){
         return map.get(elemento);
      }
      return null;
   }

   @Override public String visitExprAdd(StrLangParser.ExprAddContext ctx) {
      return visit(ctx.expr(0)) + visit(ctx.expr(1));
   }
   static{
      sc = new Scanner(System.in);
   }
}
