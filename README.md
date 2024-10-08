# WEC_Systems_Compilers_task

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
