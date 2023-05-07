grammar CalculatorV2;

program: 
  stat *EOF				#ProgramStat
| assignment *EOF			#ProgramID
;

stat: expr ? NEWLINE;

assignment: ID '=' expr ? NEWLINE;

expr:
expr op=('!+' | '!-')			#ExprUnary
| '(' expr ')' 			#ExprParent
| expr expr op=('*' | '/' | '%') 	#ExprMultDivMod
| expr expr op=('+' | '-') 		#ExprAddSub
| Integer 				#ExprInteger
| ID					#ExprID
;

ID:[a-zA-Z]+;
Integer:[0-9]+; 
NEWLINE: '\r' ? '\n';
WS: [ \t]+ -> skip;
COMMENT: '#' . * ? '\n' -> skip;
