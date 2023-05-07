// Generated from grammarDecimal.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link grammarDecimalParser}.
 */
public interface grammarDecimalListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link grammarDecimalParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(grammarDecimalParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link grammarDecimalParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(grammarDecimalParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link grammarDecimalParser#statList}.
	 * @param ctx the parse tree
	 */
	void enterStatList(grammarDecimalParser.StatListContext ctx);
	/**
	 * Exit a parse tree produced by {@link grammarDecimalParser#statList}.
	 * @param ctx the parse tree
	 */
	void exitStatList(grammarDecimalParser.StatListContext ctx);
	/**
	 * Enter a parse tree produced by {@link grammarDecimalParser#statListforLoops}.
	 * @param ctx the parse tree
	 */
	void enterStatListforLoops(grammarDecimalParser.StatListforLoopsContext ctx);
	/**
	 * Exit a parse tree produced by {@link grammarDecimalParser#statListforLoops}.
	 * @param ctx the parse tree
	 */
	void exitStatListforLoops(grammarDecimalParser.StatListforLoopsContext ctx);
	/**
	 * Enter a parse tree produced by {@link grammarDecimalParser#stat}.
	 * @param ctx the parse tree
	 */
	void enterStat(grammarDecimalParser.StatContext ctx);
	/**
	 * Exit a parse tree produced by {@link grammarDecimalParser#stat}.
	 * @param ctx the parse tree
	 */
	void exitStat(grammarDecimalParser.StatContext ctx);
	/**
	 * Enter a parse tree produced by {@link grammarDecimalParser#inloops}.
	 * @param ctx the parse tree
	 */
	void enterInloops(grammarDecimalParser.InloopsContext ctx);
	/**
	 * Exit a parse tree produced by {@link grammarDecimalParser#inloops}.
	 * @param ctx the parse tree
	 */
	void exitInloops(grammarDecimalParser.InloopsContext ctx);
	/**
	 * Enter a parse tree produced by {@link grammarDecimalParser#print}.
	 * @param ctx the parse tree
	 */
	void enterPrint(grammarDecimalParser.PrintContext ctx);
	/**
	 * Exit a parse tree produced by {@link grammarDecimalParser#print}.
	 * @param ctx the parse tree
	 */
	void exitPrint(grammarDecimalParser.PrintContext ctx);
	/**
	 * Enter a parse tree produced by {@link grammarDecimalParser#loop}.
	 * @param ctx the parse tree
	 */
	void enterLoop(grammarDecimalParser.LoopContext ctx);
	/**
	 * Exit a parse tree produced by {@link grammarDecimalParser#loop}.
	 * @param ctx the parse tree
	 */
	void exitLoop(grammarDecimalParser.LoopContext ctx);
	/**
	 * Enter a parse tree produced by {@link grammarDecimalParser#assgin}.
	 * @param ctx the parse tree
	 */
	void enterAssgin(grammarDecimalParser.AssginContext ctx);
	/**
	 * Exit a parse tree produced by {@link grammarDecimalParser#assgin}.
	 * @param ctx the parse tree
	 */
	void exitAssgin(grammarDecimalParser.AssginContext ctx);
	/**
	 * Enter a parse tree produced by {@link grammarDecimalParser#stop}.
	 * @param ctx the parse tree
	 */
	void enterStop(grammarDecimalParser.StopContext ctx);
	/**
	 * Exit a parse tree produced by {@link grammarDecimalParser#stop}.
	 * @param ctx the parse tree
	 */
	void exitStop(grammarDecimalParser.StopContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprBinary}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprBinary(grammarDecimalParser.ExprBinaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprBinary}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprBinary(grammarDecimalParser.ExprBinaryContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprRead}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprRead(grammarDecimalParser.ExprReadContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprRead}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprRead(grammarDecimalParser.ExprReadContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprPlus}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprPlus(grammarDecimalParser.ExprPlusContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprPlus}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprPlus(grammarDecimalParser.ExprPlusContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprID}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprID(grammarDecimalParser.ExprIDContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprID}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprID(grammarDecimalParser.ExprIDContext ctx);
}