# WEC_Systems_Compilers_task

### Explanation
The file [lexer.l](https://github.com/Arnella16/WEC_Systems_Compilers_task/blob/main/lexer.l) implements a lexical analyzer using Lex and integrates it with a simple symbol table and error reporting mechanism. The lexer identifies various tokens from the input text, records them, and maintains a symbol table for recognized words, commas, hyphens, and quotations.

##### Lexer Rules:
As specified in the task, the following rules have been used by the lexer to generate and identify tokens
```
word					[^0-9., \t"-]{3,26}
comma					[,]
hyphen					[-]

%%
{comma}				              {insertSymbolTable(yytext, "Comma");return COMMA;}
{hyphen}				            {insertSymbolTable(yytext, "Hyphen");return HYPHEN;}
"."					                {insertSymbolTable(yytext, "Stop");return STOP;}
"\""({word}|[ \t])*"\""			{insertSymbolTable(yytext, "Quotation");return QUOTATION;}
[A-Z][^0-9., \t"-]{2,25}		{insertSymbolTable(yytext, "Start word");return START_WORD;}
{word}					            {insertSymbolTable(yytext, "Word");return WORD;}
[ \t]					              {}
[\n]					              {yylineno++;}
.					{
						flag=1;
						insertErrorTable(yytext, "Lexical error");
					}
%%
```

