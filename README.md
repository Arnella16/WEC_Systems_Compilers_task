![image](https://github.com/user-attachments/assets/39f6c482-43de-4ed8-992c-ef17575b5fc1)# WEC_Systems_Compilers_task

### Explanation
#### Lexer:
The file [lexer.l](https://github.com/Arnella16/WEC_Systems_Compilers_task/blob/main/lexer.l) implements a lexical analyzer using Lex and integrates it with a simple symbol table and error reporting mechanism. The lexer identifies various tokens from the input text, records them, and maintains a symbol table for recognized words, commas, hyphens, and quotations.

##### Lexer Rules:
As specified in the task, the following rules have been used by the lexer to generate and identify tokens
```
word					[^0-9., \t"-]{3,26}
comma					[,]
hyphen					[-]

%%
{comma}					{insertSymbolTable(yytext, "Comma");return COMMA;}
{hyphen}				{insertSymbolTable(yytext, "Hyphen");return HYPHEN;}
"."					{insertSymbolTable(yytext, "Stop");return STOP;}
"\""({word}|[ \t])*"\""			{insertSymbolTable(yytext, "Quotation");return QUOTATION;}
[A-Z][^0-9., \t"-]{2,25}		{insertSymbolTable(yytext, "Start word");return START_WORD;}
{word}					{insertSymbolTable(yytext, "Word");return WORD;}
[ \t]					{}
[\n]					{yylineno++;}
.					{
						flag=1;
						insertErrorTable(yytext, "Lexical error");
					}
%%

```
Each time a new token is parsed it is added into the symbol table using the insertSymbolTable() function and the token parsed can be identified through an inbuilt string called yytext which contains a sequence of characters making up a single input token. 

**Error Handling:** If an unrecognized character is found, it triggers an error and records it in the error table as a lexical error.

#### Parser:
The file [parser.y](https://github.com/Arnella16/WEC_Systems_Compilers_task/blob/main/parser.y) implements a parser using Yacc and takes the input string from the file [input.txt](https://github.com/Arnella16/WEC_Systems_Compilers_task/blob/main/input.txt) and the input stream of tokens from the lexer and parses it using the following grammar:

##### Grammar:
As specified in the task, the following production rules have been used by the parser to parse the input string
```
%token WORD START_WORD STOP COMMA HYPHEN QUOTATION

%%
stmt : START_WORD mid_sentence STOP
     ;  
     
mid_sentence : words mid_sentence
	     | punctuations words mid_sentence
	     |
	     ;
	     
words : START_WORD 
      | WORD 
      | QUOTATION
      ;	      
	     	     
punctuations : COMMA 
	     | HYPHEN
	     | combos
	     ;	     	     
	    
combos : COMMA HYPHEN combos
       | HYPHEN combos
       |
       ;
%%

```
After parsing the input string the final accepted string and the symbol table and the error table(if any errors are present) are printed.
Parser identifies the syntax errors and stops parsing a particular line after an error has been identified through the inbuilt function yyerror whose parameters explain the type of error and it automatically terminated after detecting an error.

#### Bonus task:
1. Parsing table
2. Abstract Syntax Tree

NULL productions don't get printed in the Level-Order Traversal.

- **Valid Input:**
For the following input:
```
Teja--,--,- hello-,---,-- "hello hue teja",---,-- Hue.
```

Output:
![image](https://github.com/user-attachments/assets/21f75347-e696-4477-8110-a6bb5f2759a7)




- **Invalid Input:**
For the following input:
```
Teja--,--,- hello-,---,-- "hello hue teja",,---,-- Hue.
```

Output:
![image](https://github.com/user-attachments/assets/72ae210b-0be6-4803-a7d4-72d9451f6aaa)


Production rules used for parsing table:

1. stmt -> START_WORD mid_sentence STOP
2. mid_sentence -> words mid_sentence
3. mid_sentence -> punctuations words mid_sentence
4. mid_sentence -> epsilon
5. words -> START_WORD 
6. words -> WORD 
7. words -> QUOTATION  	     
8. punctuations -> COMMA
9. punctuations -> HYPHEN
10. punctuations -> combos
11. combos -> COMMA HYPHEN combos
12. combos -> HYPHEN combos
13. combos -> epsilon      

- '$' is used to represent the start symbol



