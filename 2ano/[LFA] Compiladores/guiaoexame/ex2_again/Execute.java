import java.util.*;

import javax.print.attribute.HashAttributeSet;

public class Execute extends FracLangBaseVisitor<Fraction> {
   HashMap<String,Fraction> mapa = new HashMap<>();
   Scanner sc = new Scanner(System.in);
   @Override public Fraction visitDisplay(FracLangParser.DisplayContext ctx) {
      Fraction value = visit(ctx.expr());
      value.toString();
      return value;
   }

   @Override public Fraction visitAssign(FracLangParser.AssignContext ctx) {
      Fraction value = visit(ctx.expr());
      mapa.put(ctx.ID().getText(),value);
      return value;
   }

   @Override public Fraction visitExprFraction(FracLangParser.ExprFractionContext ctx) {
      String value = ctx.FRACTION().getText();
      if(value.contains("/")){
         return new Fraction(value.split("/")[0],value.split("/")[1]);
      }else{
         return new Fraction(value,"1");
      }
   }
   @Override public Fraction visitExprID(FracLangParser.ExprIDContext ctx) {
      String id = ctx.ID().getText();
      if(mapa.containsKey(id)){
         return mapa.get(id);
      }else{
         System.err.printf("ERROR: variable \"%s\" not found!\n",id);
         return null;
      }
   }
   @Override public Fraction visitExprParents(FracLangParser.ExprParentsContext ctx) {
      return visit(ctx.expr());
   }
   @Override public Fraction visitExprSubAdd(FracLangParser.ExprSubAddContext ctx) {
      Fraction op1 = visit(ctx.expr(0));
      Fraction op2 = visit(ctx.expr(1));
      String op = ctx.op.getText();
      if(op.equals("+"))          // op == '+'
         return op1.Add(op2);
      else                        // op == '-'
         return op1.Sub(op2);
   }
   @Override public Fraction visitExprMultDiv(FracLangParser.ExprMultDivContext ctx) {
      Fraction op1 = visit(ctx.expr(0));
      Fraction op2 = visit(ctx.expr(1));
      String op = ctx.op.getText();
      if(op.equals("*"))           // op == '+*'
         return op1.Mult(op2);
      else                         // op == ':'
         return op1.Div(op2);
   }
   @Override public Fraction visitExprUnary(FracLangParser.ExprUnaryContext ctx) {
      Fraction expr = visit(ctx.expr());
      return new Fraction(expr.numerador*-1,expr.denominador);
   }
   @Override public Fraction visitExprRead(FracLangParser.ExprReadContext ctx) {
      String in = ctx.STRING().getText();
      System.out.print(in.substring(1,in.length()-1) + ": ");
      String value = sc.nextLine();
      if(value.contains("/")){
         return new Fraction(value.split("/")[0],value.split("/")[1]);
      }else{
         return new Fraction(value,"1");
      }
   }
   @Override public Fraction visitExprReduce(FracLangParser.ExprReduceContext ctx) {
      Fraction fracao = visit(ctx.expr());
      int mdc = mdc(fracao.numerador,fracao.denominador);
      return new Fraction(fracao.numerador/mdc,fracao.denominador/mdc);
   }
   public int mdc(int a,int b){
      if(b == 0){
         return a;
      }else{
         return mdc(b,a%b);
      }
   }


}
