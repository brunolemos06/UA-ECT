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
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, BINARY=15, ID=16, WS=17, 
		Comment=18, ERROR=19;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
			"T__9", "T__10", "T__11", "T__12", "T__13", "BINARY", "ID", "WS", "Comment", 
			"ERROR"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "';'", "'print'", "'='", "'if'", "'('", "')'", "':'", "'end'", 
			"'else'", "'while'", "'for'", "'+'", "'-'", "'read'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, "BINARY", "ID", "WS", "Comment", "ERROR"
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\25z\b\1\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\3\2\3\2\3\3\3\3\3\3\3\3\3\3\3\3\3\4\3\4\3\5\3\5\3"+
		"\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\t\3\t\3\n\3\n\3\n\3\n\3\n\3\13\3"+
		"\13\3\13\3\13\3\13\3\13\3\f\3\f\3\f\3\f\3\r\3\r\3\16\3\16\3\17\3\17\3"+
		"\17\3\17\3\17\3\20\6\20Z\n\20\r\20\16\20[\3\21\3\21\7\21`\n\21\f\21\16"+
		"\21c\13\21\3\22\6\22f\n\22\r\22\16\22g\3\22\3\22\3\23\3\23\3\23\3\23\7"+
		"\23p\n\23\f\23\16\23s\13\23\3\23\3\23\3\23\3\23\3\24\3\24\3q\2\25\3\3"+
		"\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37\21"+
		"!\22#\23%\24\'\25\3\2\6\3\2\62\63\4\2C\\c|\5\2\62;C\\c|\5\2\13\f\17\17"+
		"\"\"\2}\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2"+
		"\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3"+
		"\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2"+
		"\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\3)\3\2\2\2\5+\3\2\2\2\7\61\3\2\2\2"+
		"\t\63\3\2\2\2\13\66\3\2\2\2\r8\3\2\2\2\17:\3\2\2\2\21<\3\2\2\2\23@\3\2"+
		"\2\2\25E\3\2\2\2\27K\3\2\2\2\31O\3\2\2\2\33Q\3\2\2\2\35S\3\2\2\2\37Y\3"+
		"\2\2\2!]\3\2\2\2#e\3\2\2\2%k\3\2\2\2\'x\3\2\2\2)*\7=\2\2*\4\3\2\2\2+,"+
		"\7r\2\2,-\7t\2\2-.\7k\2\2./\7p\2\2/\60\7v\2\2\60\6\3\2\2\2\61\62\7?\2"+
		"\2\62\b\3\2\2\2\63\64\7k\2\2\64\65\7h\2\2\65\n\3\2\2\2\66\67\7*\2\2\67"+
		"\f\3\2\2\289\7+\2\29\16\3\2\2\2:;\7<\2\2;\20\3\2\2\2<=\7g\2\2=>\7p\2\2"+
		">?\7f\2\2?\22\3\2\2\2@A\7g\2\2AB\7n\2\2BC\7u\2\2CD\7g\2\2D\24\3\2\2\2"+
		"EF\7y\2\2FG\7j\2\2GH\7k\2\2HI\7n\2\2IJ\7g\2\2J\26\3\2\2\2KL\7h\2\2LM\7"+
		"q\2\2MN\7t\2\2N\30\3\2\2\2OP\7-\2\2P\32\3\2\2\2QR\7/\2\2R\34\3\2\2\2S"+
		"T\7t\2\2TU\7g\2\2UV\7c\2\2VW\7f\2\2W\36\3\2\2\2XZ\t\2\2\2YX\3\2\2\2Z["+
		"\3\2\2\2[Y\3\2\2\2[\\\3\2\2\2\\ \3\2\2\2]a\t\3\2\2^`\t\4\2\2_^\3\2\2\2"+
		"`c\3\2\2\2a_\3\2\2\2ab\3\2\2\2b\"\3\2\2\2ca\3\2\2\2df\t\5\2\2ed\3\2\2"+
		"\2fg\3\2\2\2ge\3\2\2\2gh\3\2\2\2hi\3\2\2\2ij\b\22\2\2j$\3\2\2\2kl\7\61"+
		"\2\2lm\7\61\2\2mq\3\2\2\2np\13\2\2\2on\3\2\2\2ps\3\2\2\2qr\3\2\2\2qo\3"+
		"\2\2\2rt\3\2\2\2sq\3\2\2\2tu\7\f\2\2uv\3\2\2\2vw\b\23\2\2w&\3\2\2\2xy"+
		"\13\2\2\2y(\3\2\2\2\7\2[agq\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}