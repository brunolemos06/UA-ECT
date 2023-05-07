grammar Hello;
greetings : 'hello' ID | bye : ''
ID : [a-z]+ ;
WS : [ \t\r\n]+ -> skip ;