# Custom-Compiler-JFlex

In this project, you need to implement a compiler for a language defined here. The programming language you need to use is C or C++ (and the language defined by the corresponding tools).
The project includes two phases, lexical analysis, and syntax analysis. In the following, we first define the language syntax and tokens. The definitions are given in BNF form.

# Language Definitions

## Syntax Definitions
program ::= “{” “Program” program-name function-definitions statements “}”
program-name ::= identifier
function-definitions ::= (function-definition)*
function-definition ::=
“{” “Function” function-name arguments statements “return” return-arg “}”
function-name ::= identifier
arguments ::= (argument)*
argument ::= identifier
return-arg ::= identifier | ε
statements ::= (statement)+
statement ::= assignment-stmt | function-call | if-stmt | while-stmt
assignment-stmt ::= “{” “=” identifier parameter “}”
function-call ::= “{” function-name parameters “}” | “{” predefined-function parameters “}”
predefined-function ::= “+” | “–” | “*” | “/” | “%” | “print”
parameters ::= (parameter)*
parameter ::= function-call | identifier | number | character-string | Boolean
number ::= integer | float
if-stmt ::= “{” “if” expression “then” statements “else” statements “}”
while-stmt ::= “{” “while” expression “do” statements “}”
expression ::= “{”comparison-operator parameter parameter “}” |
“{”Boolean-operator expression expression “}” | Boolean
comparison-operator ::= “==” | “>” | “<” | “>=” | “<=” | “!=”
Boolean-operator ::= “or” | “and”
To make the later references easier, let’s call this language the FP language (similar to functional language syntax, but has the procedural language characteristics).

The FP language is case sensitive.

## Here is an example program using the FP language.

{
  Program Sample
  {
    Function facto VAL
    { 
      if {< VAL 0 }
      then {= retVal -1}
      else {= retVal 1}
      {
        while {> VAL 0} do
        {= retVal {* retVal VAL}}
        {= VAL {- VAL 1}}
      }
    }
    return retVal
  }
  {print {facto 999}}
}

1. Execute the following code to generate the Lexer java file from the lex file
> java -jar jflex-1.6.1.jar fp.l

2. Execute the following file to generate the class files for the parser from the yacc file
> java -jar javacup11b.jar -interface < FP.y

3. Compile the Lexer.java file using the below command
>javac  Lexer.java

5. Compile the Main.java using the below command:
>javac Main.java

6. Test the sample input with the below command:
>java Main sample.fp

Code Output:
-----------
Node: 4, {
Node: 19, Program

Node: 11, Identifier :Sample

Node: 4, {
Node: 20, Function

Node: 11, Identifier :facto

Node: 11, Identifier :VAL

Node: 4, {
Node: 22, if

Node: 4, {
Node: 18, <

Node: 11, Identifier :VAL
Node: 33, Identifier : 0
Node: 5, }

Node: 23, then

Node: 4, {
Node: 16, =

Node: 11, Identifier :retVal

Node: 33, Identifier :-1
Node: 5, }

Node: 24, else

Node: 4, {
Node: 16, =

Node: 11, Identifier :retVal
Node: 33, Identifier : 1
Node: 5, }

Node: 4, {
Node: 25, while

Node: 4, {
Node: 17, >

Node: 11, Identifier :VAL
Node: 33, Identifier : 0
Node: 5, }

Node: 26, do

Node: 4, {
Node: 16, =

Node: 11, Identifier :retVal

Node: 4, {
Node: 9, *

Node: 11, Identifier :retVal

Node: 11, Identifier :VAL
Node: 5, }
Node: 5, }

Node: 4, {
Node: 16, =

Node: 11, Identifier :VAL

Node: 4, {
Node: 8, -

Node: 11, Identifier :VAL
Node: 33, Identifier : 1
Node: 5, }
Node: 5, }

Node: 5, }

Node: 5, }

Node: 21, return

Node: 11, Identifier :retVal

Node: 5, }

Node: 4, {
Node: 29, print

Node: 4, {
Node: 11, Identifier :facto
Node: 33, Identifier : 999
Node: 5, }
Node: 5, }

Node: 5, }


The Contents of the Symbol table for the above FP language is:

0:  => facto:14 => facto:2 => Sample:1

1:  null

2:  => retVal:2 => VAL:12 => VAL:11 => VAL:10 => retVal:10 => retVal:9 => VAL:8 => retVal:6 => retVal:5 => VAL:4 => VAL:2

3:  null

4:  null



