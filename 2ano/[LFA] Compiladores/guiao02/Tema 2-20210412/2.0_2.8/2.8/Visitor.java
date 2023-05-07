import java.util.HashMap;

public class Visitor extends CalculatorV2BaseVisitor<Object> {

   static HashMap<String, Double> value = new HashMap<String, Double>();

   @Override public Object visitProgramStat(CalculatorV2Parser.ProgramStatContext ctx) {
      return visitChildren(ctx);
   }

   @Override public Object visitProgramID(CalculatorV2Parser.ProgramIDContext ctx) {
      return visitChildren(ctx);
   }

   @Override public Object visitStat(CalculatorV2Parser.StatContext ctx) {
      Double res=null;
      res = (Double) visit(ctx.expr());
      if(res!=null)
      	System.out.println("[Result]: "+res);
      return res;
   }

   @Override public Object visitAssignment(CalculatorV2Parser.AssignmentContext ctx) {
      String res = null;
      String ID = (String) ctx.ID().getText()+ " = ";
      String EXPR = String.valueOf(visit(ctx.expr()));
      value.put((String) ctx.ID().getText(), (Double) visit(ctx.expr()));
      res=ID.concat(EXPR);
      if(res==null){
      	System.err.println("ERROR: Assignment");
      }else{
      	System.out.println("[Statement]: "+res);
      }
      return res;
   }

   @Override public Object visitExprAddSub(CalculatorV2Parser.ExprAddSubContext ctx) {
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

   @Override public Object visitExprParent(CalculatorV2Parser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public Object visitExprUnary(CalculatorV2Parser.ExprUnaryContext ctx) {
      Double res = null;
      res = (Double) visit(ctx.expr());
      System.out.println(ctx.op.getText());
      switch(ctx.op.getText()){
           case "!+":
           	res= res;
           	break;
           case "!-":
           	res= -res;
           	break;
      }
      return res;
   }

   @Override public Object visitExprInteger(CalculatorV2Parser.ExprIntegerContext ctx) {
      return Double.parseDouble(ctx.Integer().getText());
   }

   @Override public Object visitExprID(CalculatorV2Parser.ExprIDContext ctx) {
      Double res = null;
      res=value.get(ctx.ID().getText());
      if(res==null){
      	System.err.println("ERROR: No Assigned Value");
      }
      return res;
   }

   @Override public Object visitExprMultDivMod(CalculatorV2Parser.ExprMultDivModContext ctx) {
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
