// Generated from Gbinary.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link GbinaryParser}.
 */
public interface GbinaryListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link GbinaryParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(GbinaryParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link GbinaryParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(GbinaryParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link GbinaryParser#statList}.
	 * @param ctx the parse tree
	 */
	void enterStatList(GbinaryParser.StatListContext ctx);
	/**
	 * Exit a parse tree produced by {@link GbinaryParser#statList}.
	 * @param ctx the parse tree
	 */
	void exitStatList(GbinaryParser.StatListContext ctx);
	/**
	 * Enter a parse tree produced by {@link GbinaryParser#stat}.
	 * @param ctx the parse tree
	 */
	void enterStat(GbinaryParser.StatContext ctx);
	/**
	 * Exit a parse tree produced by {@link GbinaryParser#stat}.
	 * @param ctx the parse tree
	 */
	void exitStat(GbinaryParser.StatContext ctx);
	/**
	 * Enter a parse tree produced by {@link GbinaryParser#print}.
	 * @param ctx the parse tree
	 */
	void enterPrint(GbinaryParser.PrintContext ctx);
	/**
	 * Exit a parse tree produced by {@link GbinaryParser#print}.
	 * @param ctx the parse tree
	 */
	void exitPrint(GbinaryParser.PrintContext ctx);
	/**
	 * Enter a parse tree produced by {@link GbinaryParser#assign}.
	 * @param ctx the parse tree
	 */
	void enterAssign(GbinaryParser.AssignContext ctx);
	/**
	 * Exit a parse tree produced by {@link GbinaryParser#assign}.
	 * @param ctx the parse tree
	 */
	void exitAssign(GbinaryParser.AssignContext ctx);
	/**
	 * Enter a parse tree produced by {@link GbinaryParser#condicional}.
	 * @param ctx the parse tree
	 */
	void enterCondicional(GbinaryParser.CondicionalContext ctx);
	/**
	 * Exit a parse tree produced by {@link GbinaryParser#condicional}.
	 * @param ctx the parse tree
	 */
	void exitCondicional(GbinaryParser.CondicionalContext ctx);
	/**
	 * Enter a parse tree produced by {@link GbinaryParser#loop}.
	 * @param ctx the parse tree
	 */
	void enterLoop(GbinaryParser.LoopContext ctx);
	/**
	 * Exit a parse tree produced by {@link GbinaryParser#loop}.
	 * @param ctx the parse tree
	 */
	void exitLoop(GbinaryParser.LoopContext ctx);
	/**
	 * Enter a parse tree produced by {@link GbinaryParser#cyclefor}.
	 * @param ctx the parse tree
	 */
	void enterCyclefor(GbinaryParser.CycleforContext ctx);
	/**
	 * Exit a parse tree produced by {@link GbinaryParser#cyclefor}.
	 * @param ctx the parse tree
	 */
	void exitCyclefor(GbinaryParser.CycleforContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprBinary}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprBinary(GbinaryParser.ExprBinaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprBinary}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprBinary(GbinaryParser.ExprBinaryContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprRead}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprRead(GbinaryParser.ExprReadContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprRead}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprRead(GbinaryParser.ExprReadContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprSum}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprSum(GbinaryParser.ExprSumContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprSum}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprSum(GbinaryParser.ExprSumContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprParent}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprParent(GbinaryParser.ExprParentContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprParent}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprParent(GbinaryParser.ExprParentContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprID}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprID(GbinaryParser.ExprIDContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprID}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprID(GbinaryParser.ExprIDContext ctx);
}