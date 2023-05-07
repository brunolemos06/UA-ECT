grammar Gbinary;

program: statList EOF;

statList : (stat? ';')*;

stat :          print
        |       assign
        |       loop
        |       condicional
        |       cyclefor
        ;

print: 'print' expr;
assign: ID '=' expr;
condicional: 'if' '(' expr ')' ':' statList ('end' | ( 'else' ':' statList 'end')? );
loop: 'while' '(' expr ')' ':' statList 'end';
cyclefor: 'for' '(' expr ':' expr ')' ':' statList 'end';

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

