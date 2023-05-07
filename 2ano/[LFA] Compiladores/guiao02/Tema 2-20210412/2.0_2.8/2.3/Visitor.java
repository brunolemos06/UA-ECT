public class Visitor extends CalculatorBaseVisitor<Object> {

   @Override public Object visitStat(CalculatorParser.StatContext ctx) {
      Double res=null;
      res = (Double) visit(ctx.expr());
      if(res!=null)
      	System.out.println("[Result]: "+res);
      return res;
   }

   @Override public Object visitExprAddSub(CalculatorParser.ExprAddSubContext ctx) {
      Double res = null;
      Double op1 = (Double) visit(ctx.expr(0));
      Double op2 = (Double) visit(ctx.expr(1));
      if(op1!=null && op2!=null){
      	switch(ctx.op.getText()){
           case "+":
           	res= op1 + op2;
           	break;
           case "-":
           	res= op1 - op2;
           	break;
        }
      }
      return res;
   }

   @Override public Object visitExprParent(CalculatorParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public Object visitExprUnary(CalculatorParser.ExprUnaryContext ctx) {
      Double res = null;
      res = (Double) visit(ctx.expr());
      switch(ctx.op.getText()){
           case "+":
           	res= res;
           	break;
           case "-":
           	res= -res;
           	break;
      }
      return res;
   }

   @Override public Object visitExprInteger(CalculatorParser.ExprIntegerContext ctx) {
      return Double.parseDouble(ctx.Integer().getText());
   }

   @Override public Object visitExprMultDivMod(CalculatorParser.ExprMultDivModContext ctx) {
      Double res = null;
      Double op1 = (Double) visit(ctx.expr(0));
      Double op2 = (Double) visit(ctx.expr(1));
      if(op1!=null && op2!=null){
      	switch(ctx.op.getText()){
           case "*":
           	res=op1 * op2;
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
