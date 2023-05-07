// Generated from StrLang.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link StrLangParser}.
 */
public interface StrLangListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link StrLangParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(StrLangParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link StrLangParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(StrLangParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link StrLangParser#stat}.
	 * @param ctx the parse tree
	 */
	void enterStat(StrLangParser.StatContext ctx);
	/**
	 * Exit a parse tree produced by {@link StrLangParser#stat}.
	 * @param ctx the parse tree
	 */
	void exitStat(StrLangParser.StatContext ctx);
	/**
	 * Enter a parse tree produced by {@link StrLangParser#print}.
	 * @param ctx the parse tree
	 */
	void enterPrint(StrLangParser.PrintContext ctx);
	/**
	 * Exit a parse tree produced by {@link StrLangParser#print}.
	 * @param ctx the parse tree
	 */
	void exitPrint(StrLangParser.PrintContext ctx);
	/**
	 * Enter a parse tree produced by {@link StrLangParser#assign}.
	 * @param ctx the parse tree
	 */
	void enterAssign(StrLangParser.AssignContext ctx);
	/**
	 * Exit a parse tree produced by {@link StrLangParser#assign}.
	 * @param ctx the parse tree
	 */
	void exitAssign(StrLangParser.AssignContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprString}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprString(StrLangParser.ExprStringContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprString}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprString(StrLangParser.ExprStringContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprParent}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprParent(StrLangParser.ExprParentContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprParent}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprParent(StrLangParser.ExprParentContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprSub}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprSub(StrLangParser.ExprSubContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprSub}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprSub(StrLangParser.ExprSubContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprSubstituicao}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprSubstituicao(StrLangParser.ExprSubstituicaoContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprSubstituicao}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprSubstituicao(StrLangParser.ExprSubstituicaoContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprInput}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprInput(StrLangParser.ExprInputContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprInput}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprInput(StrLangParser.ExprInputContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprTrim}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprTrim(StrLangParser.ExprTrimContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprTrim}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprTrim(StrLangParser.ExprTrimContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprID}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprID(StrLangParser.ExprIDContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprID}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprID(StrLangParser.ExprIDContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ExprAdd}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprAdd(StrLangParser.ExprAddContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ExprAdd}
	 * labeled alternative in {@link StrLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprAdd(StrLangParser.ExprAddContext ctx);
}