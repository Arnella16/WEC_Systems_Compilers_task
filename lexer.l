%{
	#include<stdio.h>
	#include "y.tab.h"
	int flag=0;
	
	#include<string.h>
    	#include<stdlib.h>
    	extern int yylineno;  
    	int index_new=0;
    	#define TABLE_SIZE 100
    
    	struct SymbolTable{
    		char symbol_name[100];
    		char symbol_type[100];
    		int line_number;
    	}ST[TABLE_SIZE];
    
    
    	struct error_table{
		char error_name[20];
		int line_number;
		char error_type[20];
	}error_table[100];
	
	char final_string[1000]="";
	
	int error_count=0;
    
    	int searchSymbolTable(char *name){
    		for(int i=0;i<TABLE_SIZE;i++){
    			if(strcmp(ST[i].symbol_name, name)==0){
    				return 1;
    			}
    		}
    		return 0;	
    	}
    	
    	char *removeDoubleQuotes(char *name){
    		int n=strlen(name);
    		char *result=(char *)malloc((n+1)*sizeof(char));
    		if(result==NULL){
    			fprintf(stderr, "Memory allocation failed\n");
        		return NULL;
    		}
    		int k=0;
    		for(int i=0;i<n;i++){
    			if(name[i]=='"') continue;
    			else{
    				result[k++]=name[i];
    			}
    		}
    		result[k++]='\0';
    		return result;		
    	}
    
    	void insertSymbolTable(char *name, char *type){
    		char *cleared=removeDoubleQuotes(name);
    		strcat(final_string, cleared); 
    		strcat(final_string, " ");
    		if(searchSymbolTable(name)==1)
    		return;
    		else{
    			if(index_new>=TABLE_SIZE){
    				printf("Error: Symbol Table is full\n");
    				return;
    			}
    			else{
    				strcpy(ST[index_new].symbol_name,name);
    				strcpy(ST[index_new].symbol_type,type);
    				ST[index_new].line_number=yylineno;
    				index_new++;
    			}
    		}
    	}
    
    	void printSymbolTable(){
    		printf("| %30s | %10s | %10s |\n", "SYMBOL NAME", "TYPE", "LINE");
    		for(int i=0;i<index_new;i++){
    			printf("| %30s | %10s |          %d |\n", ST[i].symbol_name, ST[i].symbol_type, ST[i].line_number);
    		}
    	}
    	
    	int searchErrorTable(char *name){
    		for(int i=0;i<TABLE_SIZE;i++){
    			if(strcmp(error_table[i].error_name, name)==0){
    				return 1;
    			}
    		}
    		return 0;	
    	}
    
    	void insertErrorTable(char *name, char *type){
    		if(searchErrorTable(name)==1)
    		return;
    		else{
    			if(error_count>=TABLE_SIZE){
    				printf("Error: Error Table is full\n");
    				return;
    			}
    			else{
    				strcpy(error_table[error_count].error_name,name);
    				strcpy(error_table[error_count].error_type,type);
    				error_table[error_count].line_number=yylineno;
    				error_count++;
    			}
    		}
    	}
    	
    	void printErrorTable(){
		printf("| %10s | %15s | %10s |\n", "ERROR", "TYPE", "LINE");
		for(int i=0;i<error_count;i++){
			printf("| %10s |  %10s  |          %d |\n", error_table[i].error_name, error_table[i].error_type, error_table[i].line_number);
		}	 	
    	}
%}


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

int yywrap(void){
	return 1;
}
