grammar StrLang;

program: stat* EOF;

stat :   print | assign ;

print  : 'print' expr;
assign : ID ':' expr;

expr:       'input''(' STRING ')'       #ExprInput
        |   STRING                      #ExprString
        |   ID                          #ExprID
        |   expr '+' expr               #ExprAdd
        |   expr '-' expr               #ExprSub
        |   'trim' expr                 #ExprTrim
        |   '(' expr ')'                #ExprParent 
        |   expr '/' expr '/' expr      #ExprSubstituicao
        ;

ID:         [a-zA-Z][a-zA-Z0-9]?;
STRING:     '"' .*?  '"';
WS:         [ \t\r\n]+ -> skip;
Comment: '//' .*? '\n' -> skip;
ERROR: .;