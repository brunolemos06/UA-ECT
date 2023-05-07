grammar StrLang;

program: stat* EOF;


stat:       decl                #StatDecl
        |   print               #StatPrint
        ;

decl: ID ':' expr;

print: 'print' expr;

expr :      '(' expr ')'             #ExprParent
        |   expr '+' expr            #ExprAdd
        |   expr '-' expr            #ExprSub
        |   'trim' expr              #ExprTrim
        |   'input' expr             #ExprInput
        |   ID                       #ExprID
        |   STRING                   #ExprString
        |   expr '/' expr '/' expr   #ExprReplace
        ;

ID: [a-zA-Z0-9_]+;
STRING: '"' .*? '"';
WS: [ \t\n\r]+ -> skip;
Comment: '//' .*? '\n' -> skip;