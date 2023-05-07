import java.math.BigInteger;
import java.util.*;


public class Execute extends grammarDecimalBaseVisitor<BigInteger> {
   HashMap<String,BigInteger> mapa = new HashMap<>();
   Scanner sc = new Scanner(System.in);
   boolean stop = false;
   @Override public BigInteger visitStatList(grammarDecimalParser.StatListContext ctx) {
      for(int i=0;i<ctx.stat().size();i++){
         visit(ctx.stat(i));
      }
      return BigInteger.ZERO;
   }
   @Override public BigInteger visitStatListforLoops(grammarDecimalParser.StatListforLoopsContext ctx) {
      for(int i=0;i<ctx.inloops().size();i++){
         BigInteger BI = visit(ctx.inloops(i));
         if(stop){
            stop = false;
            return null;
         }
      }
      return BigInteger.ZERO;
   }
   @Override public BigInteger visitPrint(grammarDecimalParser.PrintContext ctx) {
      BigInteger value = visit(ctx.expr());
      System.out.println("-> "+value.toString(2));
      return value;
   }

   @Override public BigInteger visitLoop(grammarDecimalParser.LoopContext ctx){
      while(true){
         BigInteger BI = visit(ctx.statListforLoops());
         if(BI == null)
            break;
         else if(BI.equals(BigInteger.TWO)){
            System.err.print("Erro : <break> fora do loop!\n");
            return null;
         }
      }
      return BigInteger.ZERO;
   }

   @Override public BigInteger visitAssgin(grammarDecimalParser.AssginContext ctx) {
      String key = ctx.ID().getText();
      BigInteger value = visit(ctx.expr());
      if(value.equals(null)) return null;
      mapa.put(key, value);
      return value;
   }

   @Override public BigInteger visitStop(grammarDecimalParser.StopContext ctx) {
      stop = true;
      return BigInteger.ZERO;
   }

   @Override public BigInteger visitExprBinary(grammarDecimalParser.ExprBinaryContext ctx) {
      return new BigInteger(ctx.BINARY().getText(),2);
   }

   @Override public BigInteger visitExprRead(grammarDecimalParser.ExprReadContext ctx) {
      System.out.print("Value >");
      try{
         String value = sc.nextLine();
         if(value.charAt(0)=='-') value = value.substring(1,value.length()-1);
         return new BigInteger(value,2);
      }catch(Exception e){
         System.err.printf("Erro : Scanner can only scan numbers [0-9]");
         return null;
      }
   }

   @Override public BigInteger visitExprPlus(grammarDecimalParser.ExprPlusContext ctx) {
      BigInteger numero1 = visit(ctx.expr(0));
      BigInteger numero2 = visit(ctx.expr(1));
      return numero1.add(numero2);
   }

   @Override public BigInteger visitExprID(grammarDecimalParser.ExprIDContext ctx) {
      String id = ctx.ID().getText();
      if(mapa.containsKey(id)){
         return mapa.get(id);
      }else{
         System.err.printf("Erro : Variavel %s nao existe !\n",id);
         return null;
      }
   }
}
