public class Visitor extends PreffixCalculatorBaseVisitor<Object> {

   @Override public Object visitStat(PreffixCalculatorParser.StatContext ctx) {
      Double res=null;
      res = (Double) visit(ctx.expr());
      if(res!=null)
      	System.out.println("[Statement]: "+res);
      return res;
   }

   @Override public Object visitExprPreffix(PreffixCalculatorParser.ExprPreffixContext ctx) {
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
      	}
      }
      return res;
   }

   @Override public Object visitExprNumber(PreffixCalculatorParser.ExprNumberContext ctx) {
      return Double.parseDouble(ctx.Number().getText());
   }
}
