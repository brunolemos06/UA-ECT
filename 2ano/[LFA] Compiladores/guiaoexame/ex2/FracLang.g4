grammar FracLang;

program: stat* EOF;


stat:   (display | decl)? ';';

expr :     '(' expr ')'                 #ExprParent
        |   op=('+' | '-') expr         #ExprPositiveNegative
        |   expr op=('*' | ':') expr    #ExprMultDiv
        |   expr op=('+' | '-') expr    #ExprAddSub
        |   NUMBER '/' NUMBER           #ExprFraction  
        |   ID                          #ExprID
        |   NUMBER                      #ExprNumber
        |   'read' STRING               #ExprRead
        |   'reduce' expr               #ExprReduce
        ;
 

display: 'display' expr;
decl:   ID '<=' expr;

STRING: '"' .*? '"';
NUMBER: [0-9]+;
ID:[a-z0-9]+;
WS: [ \t\r\n]+ -> skip;
Comment: '--' .*? '\n' -> skip;
ERROR: .;