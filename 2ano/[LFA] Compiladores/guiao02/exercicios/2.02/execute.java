public class execute extends SuffixCalculatorBaseVisitor<Double> {

   @Override public Double visitProgram(SuffixCalculatorParser.ProgramContext ctx) {
      return visitChildren(ctx);
   }

   @Override public Double visitStat(SuffixCalculatorParser.StatContext ctx) { //
      Double res = (Double) visit(ctx.expr());
      if(res != null){
         System.out.println(res);
      }
      return res;
   }

   @Override public Double visitExprNumber(SuffixCalculatorParser.ExprNumberContext ctx) { // retornar com objrct valido
      return Double.parseDouble(ctx.Number().getText());
   }

   @Override public Double visitExprSuffix(SuffixCalculatorParser.ExprSuffixContext ctx) { // fazer funcao 
      Double operando1 = (Double) visit(ctx.expr(0));
      Double operando2 = (Double) visit(ctx.expr(1));
      Double result = null;
      switch(ctx.op.getText()){
         case "+":
            result = operando1+operando2;
            break;
         case "-":
            result = operando1-operando2;
            break;
         case "*":
            result = operando1*operando2;
            break;
         case "/":
            if(operando2 == 0) System.err.println("Erro : não podes dividir por zero");
            else result = operando1/operando2;
            break;
         default:
            System.err.println("Erro : operando inválido");
            break;
      }
      return result;
   }
}
