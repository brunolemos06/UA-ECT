grammar Gbinary;

program: stat* EOF;


stat : ( print | assign | loop)? ';';

print: 'print' expr;
assign: ID '=' expr;

loop: 'while' '(' expr ')' ':' stat* 'end'; 

expr:       '(' expr ')'                #ExprParent
        |   BINARY                      #ExprBinary
        |   ID                          #ExprID
        |   expr op=('+'|'-') expr      #ExprSum
        |   'read'                      #ExprRead
        ;


BINARY:[0-1]+;
ID: [a-zA-Z][a-zA-Z0-9]*;
WS:[ \t\r\n]+ -> skip;
Comment: '//' .*? '\n' -> skip;
ERROR: .;