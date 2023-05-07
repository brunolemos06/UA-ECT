// Generated from Gbinary.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class GbinaryLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.9.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, BINARY=12, ID=13, WS=14, Comment=15, ERROR=16;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
			"T__9", "T__10", "BINARY", "ID", "WS", "Comment", "ERROR"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "';'", "'print'", "'='", "'while'", "'('", "')'", "':'", "'end'", 
			"'+'", "'-'", "'read'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			"BINARY", "ID", "WS", "Comment", "ERROR"
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


	public GbinaryLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Gbinary.g4"; }

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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\22l\b\1\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\3\2\3\2\3"+
		"\3\3\3\3\3\3\3\3\3\3\3\3\4\3\4\3\5\3\5\3\5\3\5\3\5\3\5\3\6\3\6\3\7\3\7"+
		"\3\b\3\b\3\t\3\t\3\t\3\t\3\n\3\n\3\13\3\13\3\f\3\f\3\f\3\f\3\f\3\r\6\r"+
		"H\n\r\r\r\16\rI\3\16\6\16M\n\16\r\16\16\16N\3\16\7\16R\n\16\f\16\16\16"+
		"U\13\16\3\17\6\17X\n\17\r\17\16\17Y\3\17\3\17\3\20\3\20\3\20\3\20\7\20"+
		"b\n\20\f\20\16\20e\13\20\3\20\3\20\3\20\3\20\3\21\3\21\3c\2\22\3\3\5\4"+
		"\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37\21!\22"+
		"\3\2\6\3\2\62\63\3\2c|\4\2\62;c|\5\2\13\f\17\17\"\"\2p\2\3\3\2\2\2\2\5"+
		"\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2"+
		"\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33"+
		"\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\3#\3\2\2\2\5%\3\2\2\2\7"+
		"+\3\2\2\2\t-\3\2\2\2\13\63\3\2\2\2\r\65\3\2\2\2\17\67\3\2\2\2\219\3\2"+
		"\2\2\23=\3\2\2\2\25?\3\2\2\2\27A\3\2\2\2\31G\3\2\2\2\33L\3\2\2\2\35W\3"+
		"\2\2\2\37]\3\2\2\2!j\3\2\2\2#$\7=\2\2$\4\3\2\2\2%&\7r\2\2&\'\7t\2\2\'"+
		"(\7k\2\2()\7p\2\2)*\7v\2\2*\6\3\2\2\2+,\7?\2\2,\b\3\2\2\2-.\7y\2\2./\7"+
		"j\2\2/\60\7k\2\2\60\61\7n\2\2\61\62\7g\2\2\62\n\3\2\2\2\63\64\7*\2\2\64"+
		"\f\3\2\2\2\65\66\7+\2\2\66\16\3\2\2\2\678\7<\2\28\20\3\2\2\29:\7g\2\2"+
		":;\7p\2\2;<\7f\2\2<\22\3\2\2\2=>\7-\2\2>\24\3\2\2\2?@\7/\2\2@\26\3\2\2"+
		"\2AB\7t\2\2BC\7g\2\2CD\7c\2\2DE\7f\2\2E\30\3\2\2\2FH\t\2\2\2GF\3\2\2\2"+
		"HI\3\2\2\2IG\3\2\2\2IJ\3\2\2\2J\32\3\2\2\2KM\t\3\2\2LK\3\2\2\2MN\3\2\2"+
		"\2NL\3\2\2\2NO\3\2\2\2OS\3\2\2\2PR\t\4\2\2QP\3\2\2\2RU\3\2\2\2SQ\3\2\2"+
		"\2ST\3\2\2\2T\34\3\2\2\2US\3\2\2\2VX\t\5\2\2WV\3\2\2\2XY\3\2\2\2YW\3\2"+
		"\2\2YZ\3\2\2\2Z[\3\2\2\2[\\\b\17\2\2\\\36\3\2\2\2]^\7\61\2\2^_\7\61\2"+
		"\2_c\3\2\2\2`b\13\2\2\2a`\3\2\2\2be\3\2\2\2cd\3\2\2\2ca\3\2\2\2df\3\2"+
		"\2\2ec\3\2\2\2fg\7\f\2\2gh\3\2\2\2hi\b\20\2\2i \3\2\2\2jk\13\2\2\2k\""+
		"\3\2\2\2\b\2INSYc\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}