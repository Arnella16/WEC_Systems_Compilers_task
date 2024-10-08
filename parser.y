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
    	int rows=6, cols=8;
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
	insertErrorTable(yytext, "Syntax Error ");
	printf("Invalid due to %s\n", msg);
}

void parseTable(){
	char ***matrix;

    	matrix = malloc(rows * sizeof(char **));
    	if (matrix == NULL) {
        	fprintf(stderr, "Memory allocation failed\n");
        	return;
    	}

    	for (int i = 0; i < rows; i++) {
        	matrix[i] = malloc(cols * sizeof(char *));
        	if (matrix[i] == NULL) {
            		fprintf(stderr, "Memory allocation failed\n");
            		return;
        	}

        	for (int j = 0; j < cols; j++) {
            		matrix[i][j] = malloc(100 * sizeof(char));
            		if (matrix[i][j] == NULL) {
                		fprintf(stderr, "Memory allocation failed\n");
                		return;
            		}
        	}
    	}
    	
    	strcpy(matrix[0][0], "Non-Ter|Ter");
    	strcpy(matrix[0][1], "START_WORD");
    	strcpy(matrix[0][2], "WORD");
    	strcpy(matrix[0][3], "QUOTATION");
    	strcpy(matrix[0][4], "STOP");
    	strcpy(matrix[0][5], "COMMA");
    	strcpy(matrix[0][6], "HYPHEN");
    	strcpy(matrix[0][7], "$");
    	strcpy(matrix[1][0], "stmt");
    	strcpy(matrix[1][1], "1");
    	strcpy(matrix[1][7], "1");
    	strcpy(matrix[2][0], "mid_sentence");
    	strcpy(matrix[2][1], "2");
    	strcpy(matrix[2][2], "2");
	strcpy(matrix[2][3], "2");
	strcpy(matrix[2][4], "4");
	strcpy(matrix[2][5], "3");
	strcpy(matrix[2][6], "3");
	strcpy(matrix[3][0], "words");
	strcpy(matrix[3][1], "5");
	strcpy(matrix[3][2], "6");
	strcpy(matrix[3][3], "7");
	strcpy(matrix[4][0], "punctuations");
	strcpy(matrix[4][1], "10");
	strcpy(matrix[4][2], "10");
	strcpy(matrix[4][3], "10");
	strcpy(matrix[4][5], "8");
	strcpy(matrix[4][6], "9");
	strcpy(matrix[5][0], "combos");
	strcpy(matrix[5][1], "13");
	strcpy(matrix[5][2], "13");
	strcpy(matrix[5][3], "13");
	strcpy(matrix[5][5], "11");
	strcpy(matrix[5][6], "12");
	
	printf("%100s\n", "LL(1) Parsing table");
	printf("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    	for (int i = 0; i < rows; i++) {
        	for (int j = 0; j < cols; j++) {
            		if (j == 0) {
                		printf("  %-20s |", matrix[i][j]); // Left-align first column
            		} else {
                		printf("  %-20s |", matrix[i][j]); // Left-align subsequent columns
            		}
        	}
        	printf("\n------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    	}
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
		printf("No errors\n\n\n");
	}
	parseTable();
	return 0;
}
