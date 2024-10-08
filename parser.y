%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex();
	void yyerror(char *s);
	extern FILE *yyin;
	extern int yylineno;
	extern int flag;
	extern char *yytext;
	extern char final_string[1000];
	int flag2=0, flag_error=0;
%}

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

void printSymbolTable();
void printErrorTable();
void insertErrorTable(char *, char*);

void yyerror(char *msg){
	flag=1;
	flag2=1;
	flag_error=1;
	insertErrorTable(yytext, msg);
	printf("Invalid due to %s\n", msg);
}


int main(){
	yyin=fopen("input.txt", "r");
	strcpy(final_string, ""); 
	yyparse(); 
	if(flag==0){
		printf("Valid sentence\n");
		printf("Accepted string: %s\n", final_string);
	}
	else if(flag2==0){
		yyerror("lexical error");
	}
	printf("\n");
	printf(" %30s ", "Symbol Table\n");
	printf("----------------------------------------------------------\n");
	printSymbolTable();
	printf("-----------------------------------------------------------\n\n\n");
	if(flag_error==1){
		printf(" %30s ", "Error Table\n");
		printf("------------------------------------------\n");
		printErrorTable();
		printf("------------------------------------------\n\n\n");
	}
	else{
		printf("No errors\n");
	}
	return 0;
}
