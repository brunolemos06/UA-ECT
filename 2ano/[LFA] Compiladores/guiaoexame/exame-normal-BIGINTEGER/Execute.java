import java.math.BigInteger;
import java.util.*;
public class Execute extends GbinaryBaseVisitor<BigInteger> {
   HashMap<String,BigInteger> mapa = new HashMap<>();
   Scanner sc = new Scanner(System.in);

   @Override public BigInteger visitStatList(GbinaryParser.StatListContext ctx) {
      for(int i=0;i < ctx.stat().size();i++){
         try{
            visit(ctx.stat(i));
         }catch(Exception e){
            return null;
         }
      }
      return BigInteger.ZERO;
   }

   @Override public BigInteger visitPrint(GbinaryParser.PrintContext ctx) {
      BigInteger value = visit(ctx.expr());
      if(value == null) return null;
      System.out.print(value.toString(2) + "[" + value.toString(10) + "]\n");
      return BigInteger.ZERO;
   }
   @Override public BigInteger visitCondicional(GbinaryParser.CondicionalContext ctx) {
      BigInteger cond = visit(ctx.expr());
      int statlist = ctx.statList().size();
      if(cond.equals(BigInteger.ZERO)){
         visit(ctx.statList(0));
      }else{
         if(statlist == 2){
            visit(ctx.statList(1));
         }
      }
      return BigInteger.ZERO;
   }
   @Override public BigInteger visitCyclefor(GbinaryParser.CycleforContext ctx) {
      BigInteger var = visit(ctx.expr(0));
      try{
         for(int valor = var.intValueExact();valor <= visit(ctx.expr(1)).intValueExact();valor++){
            visit(ctx.statList());
         }
      }catch(Exception e){return null;};
      return BigInteger.ZERO;
   }

   @Override public BigInteger visitAssign(GbinaryParser.AssignContext ctx) {
      String id = ctx.ID().getText();
      BigInteger value = visit(ctx.expr());
      if(value == null) return null;
      mapa.put(id, value);
      return value;
   }

   @Override public BigInteger visitLoop(GbinaryParser.LoopContext ctx) {
      BigInteger cond = visit(ctx.expr());
      if(cond == null) return null;
      while(!cond.equals(BigInteger.ZERO)){
         if(visit(ctx.statList())==null)return null;
         cond = visit(ctx.expr());
      }
      return BigInteger.ZERO;
   }

   @Override public BigInteger visitExprBinary(GbinaryParser.ExprBinaryContext ctx) {
      String value = ctx.BINARY().getText();
      return new BigInteger(value,2);
   }

   @Override public BigInteger visitExprRead(GbinaryParser.ExprReadContext ctx) {
      System.out.print("Value -> ");
      try{
         String word = sc.nextLine();
         if(word.charAt(0) == '-') throw new Exception();
         return new BigInteger(word,2);
      }catch(Exception e){
         System.err.println("Erro : read format [1-0]");
         return null;
      }
   }

   @Override public BigInteger visitExprSum(GbinaryParser.ExprSumContext ctx) {
      String op = ctx.op.getText();
      if(op.equals("+"))   return visit(ctx.expr(0)).add(visit(ctx.expr(1)));
      else return visit(ctx.expr(0)).subtract(visit(ctx.expr(1)));
   }

   @Override public BigInteger visitExprParent(GbinaryParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public BigInteger visitExprID(GbinaryParser.ExprIDContext ctx) {
      String id = ctx.ID().getText();
      if(mapa.containsKey(id)){
         return mapa.get(id);
      }else{
         System.err.printf("Erro :  Variavel %s nao existe\n",id);
         return null;
      }
   }

}
