import java.io.*;
import java.util.ArrayList;
import java_cup.runtime.*;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java_cup.ErrorManager;
import java.lang.Error;
import java.io.InputStreamReader;
%%
%public
%class Lexer
%unicode
%line
%implements sym
%column
%cup
%cupdebug

%{
	private StringBuffer sb;
    private ComplexSymbolFactory _symFactory = new ComplexSymbolFactory();
    private int newLine, newColumn;	
	SymbolTable objSymbolTable = new SymbolTable();
	static ArrayList<String> symbols=new ArrayList<String>();
	
	public Lexer(ComplexSymbolFactory symFactory)
	{
		this(new InputStreamReader(System.in));
        _symFactory = symFactory;
    }
	
	public Lexer(BufferedReader bufReader, ComplexSymbolFactory symFactory)
	{
		this(bufReader);
		_symFactory = symFactory;
	}
	
	public Symbol createSymbol(String name, int node, boolean isKeyword)
	{
		Location newLeftLoc = null;
		Location newRightLoc = null;
		String value = yytext();
		
		if(!isKeyword)
		{
			newLeftLoc = new Location(yyline+1, yycolumn +1);
			newRightLoc = new Location(yyline+1,yycolumn+yylength());			
			
			PrintLine("Node: "+ node + ", Identifier :" + value);
			return _symFactory.newSymbol(name, node, newLeftLoc, newRightLoc, value);
		}
		else
		{
			newLeftLoc = new Location(yyline+1,yycolumn+1-yylength());
			newRightLoc = new Location(yyline+1,yycolumn+1);			
			
			PrintLine("Node: "+ node + ", " + value);
			return _symFactory.newSymbol(name, node, newLeftLoc, newRightLoc);
		}
	}
	
	public void updateSymbolTable(String identifier) throws Exception
	{
		if(null == objSymbolTable)
		{
			objSymbolTable = new SymbolTable();
		}
		
		Boolean status = objSymbolTable.createSymbolTable(identifier);		
		if (!status) {
			PrintLine("Error Creating the Symbol Table");
			return;
		}
	}
	
	public void displaySymbolTable() throws Exception
	{
		for(String strVal : symbols)
		{		
			updateSymbolTable(strVal);
		}
	
		PrintLine("\nThe Contents of the Symbol table for the above FP language is:");
		objSymbolTable.displaySymbolTable();	 
	}
	
	private static void PrintLine(String sVal)
	{
		System.out.println(sVal);
	}
	
	private void OpenBracketCondition()
	{
		sb = new StringBuffer(); 
		newLine=yyline+1; 
		newColumn=yycolumn+1; 
		yybegin(CODESEG); 
	}
	
%}

%state CODESEG
lineTerminator 		   = \r|\n|\r\n|\
inputChar 			   = [^\r\n]
whitespace 			   = {lineTerminator}|[ \t\f]
comment 			   = "//"({inputChar}|[ ])*{lineTerminator}?
digit				   =[0-9]
letter 				   =[a-zA-Z]
chars				   =[a-zA-Z0-9]|\
identifier			   =[a-zA-Z][a-zA-Z0-9]{1,6}
integer				   =[-]?{whitespace}*{digit}+
float				   ={integer}"."{digit}+
string				   ="("({chars}|[ ])*")"
%%
<YYINITIAL>{
"("                            {  
									OpenBracketCondition(); 
									return createSymbol("ROUND_BRACKET_OPEN",ROUND_BRACKET_OPEN,true); 
							   }
")"                            {  return createSymbol("ROUND_BRACKET_CLOSE",ROUND_BRACKET_CLOSE,true);}
[\{]          				   {
									symbols.add("{");
									return createSymbol("CURLY_BRACKET_OPEN",CURLY_BRACKET_OPEN,true); 
							   }
[\}]                           {   
									symbols.add("}");
									return createSymbol("CURLY_BRACKET_CLOSE",CURLY_BRACKET_CLOSE,true);
							   }
"/"                            {  return createSymbol("DIVIDE",DIVIDE,true);}
"+"                            {  return createSymbol("ADD",ADD,true);}
"-"                            {  return createSymbol("MINUS",MINUS,true);}
"*"                            {  return createSymbol("MULTIPLY",MULTIPLY,true);}
"%"							   {  return createSymbol("MOD",MOD,true);}
"=="                           {  return createSymbol("COMPARE",COMPARE,true);}
"<="                           {  return createSymbol("LESSEQ",LESSEQ,true);}
">="                           {  return createSymbol("GREATEREQ",GREATEREQ,true);}
"!="                           {  return createSymbol("NOTEQ",NOTEQ,true);}
"="                            {  return createSymbol("EQUAL",EQUAL,true);}
">"                            {  return createSymbol("GREATER",GREATER,true);}
"<"                            {  return createSymbol("LESS",LESS,true);}
"Program"                      {  return createSymbol("PROGRAM",PROGRAM,true);}
"Function"					   {  return createSymbol("FUNCTION",FUNCTION,true);}
"return"					   {  return createSymbol("RETURN",RETURN,true);}
"if"					   	   {  return createSymbol("IF",IF,true);}
"then"					   	   {  return createSymbol("THEN",THEN,true);}
"else"					       {  return createSymbol("ELSE",ELSE,true);}
"while"					       {  return createSymbol("WHILE",WHILE,true);}
"do"					       {  return createSymbol("DO",DO,true);}
"or"					   	   {  return createSymbol("OR",OR,true);}
"and"					       {  return createSymbol("AND",AND,true);}
"print"					       {  return createSymbol("PRINT",PRINT,true);}
"T"							   {  return createSymbol("BOOLEAN_TRUE",BOOLEAN_TRUE,true);}
"F"							   {  return createSymbol("BOOLEAN_FALSE",BOOLEAN_FALSE,true);}
}


<YYINITIAL>{
{identifier}                   { 
										symbols.add(yytext());										
										return createSymbol("IDENTIFIER",IDENTIFIER,false);
							   }								
{integer}					   { return  createSymbol("INTEGER",INTEGER,false);}
{float}                        { return  createSymbol("FLOAT",FLOAT,false);}
{string}                       { return  createSymbol("STRING",STRING,false);}
[\ \t\b\f\r\n]+				   { PrintLine(""); }
{comment}					   { /* Do Nothing */ }
[^]                    		   { throw new Error("Found an Illegal Character [" + yytext() + "]");}
}
<CODESEG> {
  ":}"         				  { 
									yybegin(YYINITIAL); 
									Location leftLoc = new Location(newLine, newColumn);
									Location rightLoc = new Location(yyline+1,yycolumn+1+yylength());
									
									return _symFactory.newSymbol("STRING", STRING, leftLoc, rightLoc, sb.toString()); 
							  }
  [^]           			  { sb.append(yytext()); }
}