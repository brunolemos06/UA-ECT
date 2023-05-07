// Generated from Gbinary.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link GbinaryParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface GbinaryVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link GbinaryParser#program}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram(GbinaryParser.ProgramContext ctx);
	/**
	 * Visit a parse tree produced by {@link GbinaryParser#statList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatList(GbinaryParser.StatListContext ctx);
	/**
	 * Visit a parse tree produced by {@link GbinaryParser#stat}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStat(GbinaryParser.StatContext ctx);
	/**
	 * Visit a parse tree produced by {@link GbinaryParser#print}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrint(GbinaryParser.PrintContext ctx);
	/**
	 * Visit a parse tree produced by {@link GbinaryParser#assign}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssign(GbinaryParser.AssignContext ctx);
	/**
	 * Visit a parse tree produced by {@link GbinaryParser#condicional}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCondicional(GbinaryParser.CondicionalContext ctx);
	/**
	 * Visit a parse tree produced by {@link GbinaryParser#loop}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLoop(GbinaryParser.LoopContext ctx);
	/**
	 * Visit a parse tree produced by {@link GbinaryParser#cyclefor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCyclefor(GbinaryParser.CycleforContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ExprBinary}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprBinary(GbinaryParser.ExprBinaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ExprRead}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprRead(GbinaryParser.ExprReadContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ExprSum}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprSum(GbinaryParser.ExprSumContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ExprParent}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprParent(GbinaryParser.ExprParentContext ctx);
	/**
	 * Visit a parse tree produced by the {@code ExprID}
	 * labeled alternative in {@link GbinaryParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprID(GbinaryParser.ExprIDContext ctx);
}