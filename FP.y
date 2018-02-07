import java_cup.runtime.*;
import java.lang.Math;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import java_cup.runtime.ComplexSymbolFactory.ComplexSymbol;

terminal  	ROUND_BRACKET_OPEN, ROUND_BRACKET_CLOSE, CURLY_BRACKET_OPEN, CURLY_BRACKET_CLOSE;
terminal  	DIVIDE, ADD, MINUS, MULTIPLY, MOD, IDENTIFIER;
terminal  	COMPARE, LESSEQ, GREATEREQ, NOTEQ, EQUAL, GREATER, LESS, PROGRAM, FUNCTION;
terminal  	RETURN, IF, THEN, ELSE, WHILE, DO, OR, AND, PRINT, STRING, BOOLEAN_TRUE, BOOLEAN_FALSE;
terminal  	INTEGER, FLOAT;

non terminal  	prog_def, prog_title; 
non terminal 	number, string, identifier;
non terminal  	comparison_operator, boolean_operator, predefined_func;
non terminal 	parameters, parameter, arg, args, return_arg;
non terminal 	func_def, func_title, func_call;
non terminal	print_statement;
non terminal 	statement, statements, assignment_statement, if_statement, while_statement, expression;

precedence left ADD, MINUS, MULTIPLY, DIVIDE;

prog_def      			::= CURLY_BRACKET_OPEN PROGRAM prog_title func_def statements CURLY_BRACKET_CLOSE;
					
prog_title           	::= identifier;                      
                        
func_def     			::= CURLY_BRACKET_OPEN FUNCTION func_title args statements RETURN return_arg CURLY_BRACKET_CLOSE;
                        
func_title           	::= identifier;

func_call           	::= CURLY_BRACKET_OPEN func_title parameters CURLY_BRACKET_CLOSE {:;:}
                        | CURLY_BRACKET_OPEN predefined_func parameters CURLY_BRACKET_CLOSE {:;:}
                        ;
						
predefined_func		    ::= ADD {:;:}
                        | MINUS {:;:}
                        | MULTIPLY {:;:}
                        | DIVIDE {:;:}
                        | MOD {:;:}
                        | PRINT {:;:}
                        ;
                        
args               		::= arg {:;:}
                        | args arg {:;:}
                        ;
                        
arg		                ::= identifier {:;:};
                        
return_arg              ::= identifier {:;:};
                        
statements              ::= statement {:;:}
                        | statements statement {:;:}
                        ;
                        
statement               ::= assignment_statement {:;:}
                        | func_call {:;:}
                        | if_statement{:;:}
                        | while_statement {:;:}
                        ;
                        
assignment_statement    ::= CURLY_BRACKET_OPEN EQUAL identifier parameter CURLY_BRACKET_CLOSE {:;:};
                        
parameters              ::= parameter {::}
                        | parameters parameter {:;:}
                        ;
                        
parameter               ::= func_call {:;:}
                        | identifier {:;:}
                        | number {:;:}
                        ;
                        
if_statement            ::= CURLY_BRACKET_OPEN IF expression THEN statements ELSE statements CURLY_BRACKET_CLOSE {:;:}
                        ;
                        
while_statement         ::= CURLY_BRACKET_OPEN WHILE expression DO statements CURLY_BRACKET_CLOSE {:;:}
                        ;
						
print_statement			::= ROUND_BRACKET_OPEN STRING ROUND_BRACKET_CLOSE;
                        
expression              ::= CURLY_BRACKET_OPEN comparison_operator parameter parameter CURLY_BRACKET_CLOSE {:;:}
						| CURLY_BRACKET_OPEN parameter AND parameter CURLY_BRACKET_CLOSE {:;:}
						| CURLY_BRACKET_OPEN parameter OR parameter CURLY_BRACKET_CLOSE {:;:}
                        ;
						
comparison_operator     ::= COMPARE {:;:}
                        | GREATER {:;:}
                        | LESS {:;:}
                        | GREATEREQ {:;:}
                        | LESSEQ {:;:}
                        | NOTEQ {:;:}
                        ;
						
string					::= ROUND_BRACKET_OPEN identifier ROUND_BRACKET_CLOSE
						;
                        
boolean_operator		::=  BOOLEAN_TRUE {:;:}
						|    BOOLEAN_FALSE {:;:}
						;
						
identifier              ::= IDENTIFIER;

number                  ::= INTEGER 
                        | FLOAT {:;:}
                        ;




