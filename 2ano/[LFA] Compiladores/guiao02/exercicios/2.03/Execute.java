public class Execute extends CalculatorBaseVisitor<Integer> {

   @Override public Integer visitProgram(CalculatorParser.ProgramContext ctx) {
      return visitChildren(ctx);
   }

   @Override public Integer visitStat(CalculatorParser.StatContext ctx) {
      Integer res = (Integer) visit(ctx.expr());
      if(res!=null) System.out.print("[RESULT]: "+res+"\n");
      return res;
   }

   @Override public Integer visitExprAddSub(CalculatorParser.ExprAddSubContext ctx) {
      Integer res = null;
      Integer op1 = (Integer) visit(ctx.expr(0));
      Integer op2 = (Integer) visit(ctx.expr(1));
      if(op1!=null && op2!=null){
         switch(ctx.op.getText()){
            case "+":
               res = op1 + op2;
               break;
            case "-":
               res = op1 - op2;
               break;
         }
      }
      return res;
   }

   @Override public Integer visitExprParent(CalculatorParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public Integer visitExprUnary(CalculatorParser.ExprUnaryContext ctx) {
      Integer res = (Integer) visit(ctx.expr());
      if(ctx.op.getText().equals("-")){
         res = -res;
      }
      return res;
   }

   @Override public Integer visitExprInteger(CalculatorParser.ExprIntegerContext ctx) {
      return Integer.parseInt(ctx.Integer().getText());
   }

   @Override public Integer visitExprMultDivMod(CalculatorParser.ExprMultDivModContext ctx) {
      Integer res = null;
      Integer op1 = (Integer) visit(ctx.expr(0));
      Integer op2 = (Integer) visit(ctx.expr(1));
      if(op1!=null && op2!=null){
         switch(ctx.op.getText()){
            case "*":
               res = op1 * op2;
               break;
            case "/":
               if(op2==0){
                  System.err.println("ERROR: DIVIDED BY ZERO");
               }else{
                  res= op1 / op2;
               }
               break;
            case "%":
               if(op2==0){
                  System.err.println("ERROR: DIVIDED BY ZERO");
               }else{
                  res= op1 % op2;
               }
               break;
          }
      }
      return res;
   }
}
