// Generated from /home/bruno/Desktop/UA-CT/2ano/2semestre/LFA/guiao-exame/exame-normal-BIGINTEGER_copy/grammarDecimal.g4 by ANTLR 4.8
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class grammarDecimalLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.8", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		BINARY=10, ID=11, WS=12, COMMENT=13, ERROR=14;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
			"BINARY", "ID", "WS", "COMMENT", "ERROR"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "';'", "'print'", "'loop'", "':'", "'end'", "'->'", "'break'", 
			"'read'", "'+'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, "BINARY", 
			"ID", "WS", "COMMENT", "ERROR"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}


	public grammarDecimalLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "grammarDecimal.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\20i\b\1\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\3\2\3\2\3\3\3\3\3\3\3\3\3\3\3"+
		"\3\3\4\3\4\3\4\3\4\3\4\3\5\3\5\3\6\3\6\3\6\3\6\3\7\3\7\3\7\3\b\3\b\3\b"+
		"\3\b\3\b\3\b\3\t\3\t\3\t\3\t\3\t\3\n\3\n\3\13\6\13D\n\13\r\13\16\13E\3"+
		"\f\3\f\6\fJ\n\f\r\f\16\fK\3\r\6\rO\n\r\r\r\16\rP\3\r\7\rT\n\r\f\r\16\r"+
		"W\13\r\3\r\3\r\3\16\3\16\3\16\3\16\7\16_\n\16\f\16\16\16b\13\16\3\16\3"+
		"\16\3\16\3\16\3\17\3\17\4U`\2\20\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23"+
		"\13\25\f\27\r\31\16\33\17\35\20\3\2\6\3\2\62\63\4\2C\\c|\5\2\62;C\\c|"+
		"\5\2\13\f\17\17\"\"\2m\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2"+
		"\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25"+
		"\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\3\37\3\2"+
		"\2\2\5!\3\2\2\2\7\'\3\2\2\2\t,\3\2\2\2\13.\3\2\2\2\r\62\3\2\2\2\17\65"+
		"\3\2\2\2\21;\3\2\2\2\23@\3\2\2\2\25C\3\2\2\2\27G\3\2\2\2\31N\3\2\2\2\33"+
		"Z\3\2\2\2\35g\3\2\2\2\37 \7=\2\2 \4\3\2\2\2!\"\7r\2\2\"#\7t\2\2#$\7k\2"+
		"\2$%\7p\2\2%&\7v\2\2&\6\3\2\2\2\'(\7n\2\2()\7q\2\2)*\7q\2\2*+\7r\2\2+"+
		"\b\3\2\2\2,-\7<\2\2-\n\3\2\2\2./\7g\2\2/\60\7p\2\2\60\61\7f\2\2\61\f\3"+
		"\2\2\2\62\63\7/\2\2\63\64\7@\2\2\64\16\3\2\2\2\65\66\7d\2\2\66\67\7t\2"+
		"\2\678\7g\2\289\7c\2\29:\7m\2\2:\20\3\2\2\2;<\7t\2\2<=\7g\2\2=>\7c\2\2"+
		">?\7f\2\2?\22\3\2\2\2@A\7-\2\2A\24\3\2\2\2BD\t\2\2\2CB\3\2\2\2DE\3\2\2"+
		"\2EC\3\2\2\2EF\3\2\2\2F\26\3\2\2\2GI\t\3\2\2HJ\t\4\2\2IH\3\2\2\2JK\3\2"+
		"\2\2KI\3\2\2\2KL\3\2\2\2L\30\3\2\2\2MO\t\5\2\2NM\3\2\2\2OP\3\2\2\2PN\3"+
		"\2\2\2PQ\3\2\2\2QU\3\2\2\2RT\13\2\2\2SR\3\2\2\2TW\3\2\2\2UV\3\2\2\2US"+
		"\3\2\2\2VX\3\2\2\2WU\3\2\2\2XY\b\r\2\2Y\32\3\2\2\2Z[\7\61\2\2[\\\7\61"+
		"\2\2\\`\3\2\2\2]_\13\2\2\2^]\3\2\2\2_b\3\2\2\2`a\3\2\2\2`^\3\2\2\2ac\3"+
		"\2\2\2b`\3\2\2\2cd\7\f\2\2de\3\2\2\2ef\b\16\2\2f\34\3\2\2\2gh\13\2\2\2"+
		"h\36\3\2\2\2\b\2EKPU`\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}