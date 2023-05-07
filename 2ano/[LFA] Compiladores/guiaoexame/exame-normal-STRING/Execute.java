import java.math.BigInteger;
import java.util.HashMap;
import java.util.Scanner;


public class Execute extends GbinaryBaseVisitor<String> {
   HashMap<String,String> mapa = new HashMap<>();
   Scanner sc = new Scanner(System.in);

   @Override public String visitPrint(GbinaryParser.PrintContext ctx) {
      String toprint = visit(ctx.expr());
      try{
         BigInteger B2 = new BigInteger(toprint,2);
         System.out.printf("-> %s[%s]\n",toprint,B2.toString(10));
      }catch(Exception e){
         return null;
      }
      return "";
   }

   @Override public String visitLoop(GbinaryParser.LoopContext ctx) {
      String value = visit(ctx.expr());
      String aux = value.replace("0", "");
      if(aux.equals("")) value = "0";
      try{
         while(!value.equals("0")){    // biginteger.equals(biginteger.zero == false)
            for(int i= 0; i < ctx.stat().size(); i++){
               visit(ctx.stat(i));
            }
            value = visit(ctx.expr());
         }
      }catch(Exception e){
         return null;
      }
      return "";

   }

   @Override public String visitAssign(GbinaryParser.AssignContext ctx) {
      String id = ctx.ID().getText();
      String number = visit(ctx.expr());
      mapa.put(id,number);
      return "";

   }

   @Override public String visitExprBinary(GbinaryParser.ExprBinaryContext ctx) {
      return ctx.BINARY().getText();
   }

   @Override public String visitExprSum(GbinaryParser.ExprSumContext ctx) {
      String op1 = visit(ctx.expr(0));
      String op2 = visit(ctx.expr(1));
      String vs = ctx.op.getText();
      BigInteger B2  = null;
      BigInteger B1  = null;
      try{
         B1 = new BigInteger(op1,2);
         B2 = new BigInteger(op2,2);
      }catch(Exception e){
         return null;
      }
      switch (vs){
         case "-":
            return B1.subtract​(B2).toString(2);
         case "+":
            return B1.add(B2).toString(2);
         default:
            // nao chega aqui
            return null;
      }
   }

   @Override public String visitExprParent(GbinaryParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public String visitExprID(GbinaryParser.ExprIDContext ctx) {
      String id = ctx.ID().getText();
      if(!mapa.containsKey(id)){
         System.err.printf("Erro : Variavel < %s > nao existe !\n",id);
         return null;
      }
      return mapa.get(id);
   }

   @Override public String visitExprRead(GbinaryParser.ExprReadContext ctx) {
      System.out.print("value -> ");
      return sc.nextLine();
   }
}
