grammar CalculatorV2;

program: 
  stat *EOF				#ProgramStat
| assignment *EOF			#ProgramID
;

stat: expr ? NEWLINE;

assignment: ID '=' expr ? NEWLINE;

expr:
op=('+' | '-') expr 			#ExprUnary
| '(' expr ')' 			#ExprParent
| expr op=('*' | '/' | '%') expr 	#ExprMultDivMod
| expr op=('+' | '-') expr 		#ExprAddSub
| Integer 				#ExprInteger
| ID					#ExprID
;

ID:[a-zA-Z]+;
Integer:[0-9]+; 
NEWLINE: '\r' ? '\n';
WS: [ \t]+ -> skip;
COMMENT: '#' . * ? '\n' -> skip;
