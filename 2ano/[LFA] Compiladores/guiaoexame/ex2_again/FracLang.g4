grammar FracLang;

program: stat* EOF;

stat: (display | assign)? ';';

display: 'display' expr;
assign: ID '<=' expr;

expr:       '(' expr ')'                #ExprParents    
        |   FRACTION                    #ExprFraction
        |   ID                          #ExprID
        |   'reduce' expr               #ExprReduce
        |   expr op=('*'|':') expr      #ExprMultDiv
        |   expr op=('+'|'-') expr      #ExprSubAdd
        |   '-' expr                    #ExprUnary
        |   'read' STRING               #ExprRead
        ;

FRACTION: [0-9]+ ('/'[0-9]+)?;
ID: [a-z]+;
STRING:     '"' .*?  '"';
WS: [ \t\r\n]+ .*? -> skip;
COMMENT: '--' .*? '\n' -> skip;
ERROR: .;