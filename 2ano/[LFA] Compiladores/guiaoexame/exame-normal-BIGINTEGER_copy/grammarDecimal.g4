grammar grammarDecimal;

program: statList EOF ;

statList : (stat? ';')*;
statListforLoops: (inloops? ';')*;

stat: (print | assgin | loop );
inloops:  (stat | stop);

print  : 'print' expr ;
loop   : 'loop'':' statListforLoops 'end';
assgin :  ID '->' expr ;
stop   :  'break';

expr:           BINARY              #ExprBinary
            |   ID                  #ExprID
            |   'read'              #ExprRead
            |   expr '+' expr       #ExprPlus                         
            ;

BINARY: [0-1]+;
ID: [a-zA-Z][a-zA-Z0-9]+;
WS: [ \t\r\n]+ .*? -> skip;
COMMENT: '//' .*? '\n' -> skip;
ERROR: .;