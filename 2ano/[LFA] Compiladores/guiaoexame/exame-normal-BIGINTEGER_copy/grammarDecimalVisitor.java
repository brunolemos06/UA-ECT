// Generated from grammarDecimal.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link grammarDecimalParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface grammarDecimalVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link grammarDecimalParser#program}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram(grammarDecimalParser.ProgramContext ctx);
	/**
	 * Visit a parse tree produced by {@link grammarDecimalParser#statList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatList(grammarDecimalParser.StatListContext ctx);
	/**
	 * Visit a parse tree produced by {@link grammarDecimalParser#statListforLoops}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatListforLoops(grammarDecimalParser.StatListforLoopsContext ctx);
	/**
	 * Visit a parse tree produced by {@link grammarDecimalParser#stat}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStat(grammarDecimalParser.StatContext ctx);
	/**
	 * Visit a parse tree produced by {@link grammarDecimalParser#inloops}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInloops(grammarDecimalParser.InloopsContext ctx);
	/**
	 * Visit a parse tree produced by {@link grammarDecimalParser#print}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrint(grammarDecimalParser.PrintContext ctx);
	/**
	 * Visit a parse tree produced by {@link grammarDecimalParser#loop}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLoop(grammarDecimalParser.LoopContext ctx);
	/**
	 * Visit a parse tree produced by {@link grammarDecimalParser#assgin}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssgin(grammarDecimalParser.AssginContext ctx);
	/**
	 * Visit a parse tree produced by {@link grammarDecimalParser#stop}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStop(grammarDecimalParser.StopContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ExprBinary}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprBinary(grammarDecimalParser.ExprBinaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ExprRead}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprRead(grammarDecimalParser.ExprReadContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ExprPlus}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprPlus(grammarDecimalParser.ExprPlusContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ExprID}
	 * labeled alternative in {@link grammarDecimalParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprID(grammarDecimalParser.ExprIDContext ctx);
}