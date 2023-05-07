import java.text.spi.NumberFormatProvider;
import java.util.HashMap;
import java.util.Scanner;

public class Execute extends FracLangBaseVisitor<Fraction> {
   HashMap<String,Fraction> map = new HashMap<>();
   Scanner sc = new Scanner(System.in);
   @Override public Fraction visitProgram(FracLangParser.ProgramContext ctx) {
      return visitChildren(ctx);
   }

   @Override public Fraction visitExprPositiveNegative(FracLangParser.ExprPositiveNegativeContext ctx){
      String op = ctx.op.getText();
      Fraction exp1 = visit(ctx.expr());
      if(op.equals("+")){
         return exp1.Mul(new Fraction(1,1));
      }else if(op.equals("-")){
         return exp1.Mul(new Fraction(-1,1));
      }
      return null;
   }

   @Override public Fraction visitExprAddSub(FracLangParser.ExprAddSubContext ctx) {
      String op = ctx.op.getText();
      Fraction exp1 = visit(ctx.expr(0));
      Fraction exp2 = visit(ctx.expr(1));
      if(op.equals("+")){
         return exp1.Add(exp2);
      }else if(op.equals("-")){
         return exp1.Sub(exp2);
      }
      return null;
   }

   @Override public Fraction visitExprParent(FracLangParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public Fraction visitExprNumber(FracLangParser.ExprNumberContext ctx) {
      String valor = ctx.NUMBER().getText();
      int out = Integer.parseInt(valor);
      return new Fraction(out,1);
   }

   @Override public Fraction visitExprMultDiv(FracLangParser.ExprMultDivContext ctx) {
      String op = ctx.op.getText();
      Fraction exp1 = visit(ctx.expr(0));
      Fraction exp2 = visit(ctx.expr(1));
      if(op.equals("*")){
         return exp1.Mul(exp2);
      }else if(op.equals(":")){
         return exp1.Div(exp2);
      }
      return null;
   }

   @Override public Fraction visitExprID(FracLangParser.ExprIDContext ctx) {
      String id = ctx.ID().getText();
      if(map.containsKey(id)){
         return map.get(id);
      }
      return null;
   }

   @Override public Fraction visitExprRead(FracLangParser.ExprReadContext ctx) {
      String out = ctx.STRING().getText();
      System.out.print(out+": ");
      String s = sc.nextLine();
      String[]sep = s.split("/");
      if(sep.length == 2){
         try{
            int op1 = Integer.parseInt(sep[0]);
            int op2 = Integer.parseInt(sep[1]);
            return new Fraction(op1,op2);
         }catch(Exception e){
            System.err.printf("Erro na leitura de fracao!\n");
            return null;
         }
      }
      System.err.printf("Erro na leitura de fracao!\n");
      return null;
   }

   @Override public Fraction visitExprFraction(FracLangParser.ExprFractionContext ctx) {
      String valor1 = ctx.NUMBER(0).getText();
      String valor2 = ctx.NUMBER(1).getText();
      int out1 = Integer.parseInt(valor1);
      int out2 = Integer.parseInt(valor2);
      return new Fraction(out1,out2);
   }

   @Override public Fraction visitDisplay(FracLangParser.DisplayContext ctx) {
      Fraction out = visit(ctx.expr());
      if(out == null)return null;
      out.toString();
      return out;
   }

   @Override public Fraction visitDecl(FracLangParser.DeclContext ctx) {
      String id = ctx.ID().getText();
      Fraction valor = visit(ctx.expr());
      map.put(id,valor);
      return valor;
   }
   @Override public Fraction visitExprReduce(FracLangParser.ExprReduceContext ctx) {
      Fraction exp1 = visit(ctx.expr());
      if(exp1 == null)return null;
      int mdc = mdc(exp1);
      return new Fraction(exp1.numerador/mdc,exp1.denominador/mdc);
   }
   public int mdc(Fraction c){
      int op1 = c.numerador;
      int op2 = c.denominador;
      if(op2 == 0) return op1;
      else{return mdc(new Fraction(op2,op1%op2));}
   }
}
