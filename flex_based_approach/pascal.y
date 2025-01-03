%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define BOOLEAN_TYPE 1
#define IDENTIFIER_TYPE 2
#define REAL_TYPE 3
#define INTEGER_TYPE 4
#define STRING_TYPE 5
#define CHAR_TYPE 6

extern FILE *yyin;
extern FILE *outputFile;
extern FILE *symbolTableFile;
int yylex();
void yyerror(const char *s);
extern int yylineno;

typedef struct Symbol {
    char* name;
    char* type; // "INTEGER", "REAL", etc.
    union {
        int ival;
        float fval;
        char* sval;
        bool bval;
    } value;
    bool isConstant; // true for constants, false for variables
    char* scope;     // Optional: used to track scope
    struct Symbol* next;
} Symbol;

Symbol* symbolTable = NULL;


void printSymbolTable();

%}

%union {
    int ival;
    double fval;
    char* sval;
    bool bval;
}

%token PROGRAM USES START END VAR CONST TYPE PROCEDURE FUNCTION IF THEN ELSE WHILE DO FOR TO BREAK CONTINUE DOWNTO REPEAT UNTIL CASE OF WRITE WRITELN READ READLN 
%token DIV MOD AND OR NOT ASSIGN EQUALS PLUS MINUS MULT DIVIDE NEQ LEQ GEQ LT GT
%token COLON SEMICOLON COMMA DOT DOTDOT LPAREN RPAREN LBRACKET RBRACKET
%token <sval> IDENTIFIER INTEGER REAL CHAR BOOLEAN ARRAY RECORD  
%token <ival> IntegerLiteral
%token <sval> CharLiteral StringLiteral
%token <fval> RealLiteral
%token <bval> BooleanLiteral

%type <sval> TYPES  
%type <ival> expression simple_expression term factor expression_list
%type <bval> comparison_expr logical_expr

%start program

%%

program:
    PROGRAM IDENTIFIER SEMICOLON program_part START statement_sequence END DOT  {
        { fprintf(stderr, "Program parsed successfully:\n"); exit(0); }
    }
;

program_part:
    constant_definition_part program_part_rest    
    | USES IDENTIFIER SEMICOLON program_part_rest {fprintf(symbolTableFile, "| %-15s | %-15s | %-10s |\n", $2, "raidd", ""); }
    | type_definition_part program_part_rest
    | variable_declaration_part program_part_rest
    | procedure_declaration program_part_rest
    | function_declaration program_part_rest
    | /* empty */  /* Allows for empty program part (base case for recursion) */
;

program_part_rest:
    constant_definition_part program_part_rest
    | USES IDENTIFIER SEMICOLON program_part_rest
    | type_definition_part program_part_rest
    | variable_declaration_part program_part_rest
    | procedure_declaration program_part_rest
    | function_declaration program_part_rest
    | /* empty */  /* End of repetition (empty case) */
;

constant_definition_part:
    CONST constant_definition_list
;

constant_definition_list:
    constant_definition
    | constant_definition constant_definition_list
;

constant_definition:
    IDENTIFIER EQUALS RealLiteral SEMICOLON {

        fprintf(symbolTableFile, "1...\n");
    }
    | IDENTIFIER EQUALS IntegerLiteral SEMICOLON {
       
        fprintf(symbolTableFile, "2...\n");
    }
    | IDENTIFIER EQUALS StringLiteral SEMICOLON {
        
        fprintf(symbolTableFile, "3...\n");
    }
    | IDENTIFIER EQUALS CharLiteral SEMICOLON {
       
        fprintf(symbolTableFile, "5...\n");
    }
;

type_definition_part:
    TYPE type_definition_list
;

type_definition_list:
    type_definition
    | type_definition type_definition_list
;

type_definition:
    IDENTIFIER EQUALS TYPES SEMICOLON
;

constant:
    IntegerLiteral         
    | StringLiteral        
    | CharLiteral  
    // | BooleanLiteral 
;
scalable_constant:
    IntegerLiteral         
    | CharLiteral   
;

TYPES:
    INTEGER   {$$ = "INTEGER";}
    | REAL  {$$ = "REAL";}
    | CHAR  {$$ = "CHAR";}
    | BOOLEAN   {$$ = "BOOLEAN";}
    | ARRAY LBRACKET scalable_constant DOTDOT scalable_constant RBRACKET OF TYPES   {$$ = "ARRAY";}
    | RECORD record_fields END  {$$ = "RECORD";}
;

record_fields:
    record_field
    | record_field record_fields
;

record_field:
    IDENTIFIER COLON TYPES SEMICOLON
;

variable_declaration_part:
    VAR variable_declaration_list
;

variable_declaration_list:
    variable_declaration
    | variable_declaration variable_declaration_list
;

variable_declaration:
    IDENTIFIER COLON TYPES SEMICOLON {
      
        fprintf(symbolTableFile, " %s : %s ;\n",$1,$3);
    }
;

procedure_declaration:
    PROCEDURE IDENTIFIER formal_parameter_list SEMICOLON program_part START statement_sequence END SEMICOLON {
       
        fprintf(symbolTableFile, "7...\n");
    }
;

function_declaration:
    FUNCTION IDENTIFIER formal_parameter_list COLON TYPES SEMICOLON program_part START statement_sequence END SEMICOLON {
        
        fprintf(symbolTableFile, "8...\n");
    }
;

formal_parameter_list:
    LPAREN formal_parameter_list_items RPAREN
;

formal_parameter_list_items:
    formal_parameter
    | formal_parameter formal_parameter_list_items
;

formal_parameter:
    VAR IDENTIFIER COLON TYPES
    | IDENTIFIER COLON TYPES
;

statement_sequence:
    statement
    | statement statement_sequence
;

statement:
    assignment_statement SEMICOLON
    | procedure_call_statement SEMICOLON
    | if_statement SEMICOLON
    | while_statement SEMICOLON
    | repeat_statement SEMICOLON
    | for_statement 
    | case_statement SEMICOLON
    | input_statement SEMICOLON
    | output_statement SEMICOLON
    | BREAK SEMICOLON
    | CONTINUE SEMICOLON
;

assignment_statement:
    IDENTIFIER ASSIGN expression
;

procedure_call_statement:
    IDENTIFIER LPAREN expression_list RPAREN
;

expression_list:
    expression { $$ = $1; }  
    | expression COMMA expression_list {
   
    }
;

if_statement:
    IF expression THEN statement ELSE statement
;

while_statement:
    WHILE expression DO statement
;

repeat_statement:
    REPEAT statement_sequence UNTIL expression
;

for_statement:
    FOR IDENTIFIER ASSIGN expression TO expression DO statement 
    | FOR IDENTIFIER ASSIGN expression TO expression DO block_statement
    | FOR IDENTIFIER ASSIGN expression DOWNTO expression DO statement
    | FOR IDENTIFIER ASSIGN expression DOWNTO expression DO block_statement
;

block_statement:
    START statement_sequence END
;

case_statement:
    CASE expression OF case_element_list END
;

case_element_list:
    case_element
    | case_element case_element_list
;

case_element:
    constant COLON statement
;

input_statement:
    READLN LPAREN variable_list RPAREN
    |READ LPAREN variable_list RPAREN
;

output_statement:
    WRITELN LPAREN expression_list RPAREN  {fprintf(symbolTableFile, "%s\n", $3);}
    |WRITE LPAREN expression_list RPAREN    {fprintf(symbolTableFile, "%s", $3);}
;

variable_list:
    IDENTIFIER variable_suffix_opt
;
variable_suffix_opt:
    /* Empty */
    | index_access
    | record_field_access
    | pointer_dereference
;

index_access:
    LBRACKET expression RBRACKET
;

record_field_access:
    DOT IDENTIFIER
;

pointer_dereference:
    '^'
;

expression:
      simple_expression { $$ = $1; }
    | comparison_expr   { $$ = $1; }
    | logical_expr      { $$ = $1; }
;

comparison_expr:
      simple_expression EQUALS simple_expression   { $$ = $1 == $3; }
    | simple_expression NEQ simple_expression     { $$ = $1 != $3; }
    | simple_expression LT simple_expression      { $$ = $1 < $3; }
    | simple_expression LEQ simple_expression     { $$ = $1 <= $3; }
    | simple_expression GT simple_expression      { $$ = $1 > $3; }
    | simple_expression GEQ simple_expression     { $$ = $1 >= $3; }
;

logical_expr:
      comparison_expr AND comparison_expr  { $$ = $1 && $3; }
    | comparison_expr OR comparison_expr   { $$ = $1 || $3; }
    | NOT comparison_expr                  { $$ = !$2; }
;

simple_expression:
      term
    | simple_expression PLUS term   { $$ = $1 + $3; fprintf(symbolTableFile, "%d\n", $1 + $3);}
    | simple_expression MINUS term  { $$ = $1 - $3; }
;

term:
      factor
    | term MULT factor   { $$ = $1 * $3; }
    | term DIVIDE factor { $$ = $1 / $3; }
    | term MOD factor    { $$ = $1 % $3; }
;

factor:
    IDENTIFIER        { $$ = atoi($1); }
    | RealLiteral     { $$ = $1; }
    | IntegerLiteral  { $$ = $1; }
    | StringLiteral   { $$ = $1; }
    | CharLiteral     { $$ = $1[0]; }
    | LPAREN expression RPAREN { $$ = $2; }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s  | %d\n", s,yylineno);
}

/* ------------------------------------------------------------------ */



void printSymbolTable() {
    Symbol* current = symbolTable;
    fprintf(symbolTableFile, "Symbol Table:\n");
    fprintf(symbolTableFile, "| Name        | Type        | Constant | Value     | Scope     |\n");
    fprintf(symbolTableFile, "-------------------------------------------------------------\n");
    while (current) {
        fprintf(symbolTableFile, "| %-10s | %-10s | %-8s | ...       | %-8s |\n",
                current->name, current->type, current->isConstant ? "Yes" : "No", current->scope);
        current = current->next;
    }
}

int main(int argc, char **argv) {
   if (argc < 3) {
        fprintf(stderr, "Usage: %s <input file> <output file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Open input file for lexer
    FILE *inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        perror("Error opening input file");
        return EXIT_FAILURE;
    }
    yyin = inputFile;

    // Open output file for lexer
    outputFile = fopen(argv[2], "w");
    if (!outputFile) {
        perror("Error opening output file");
        fclose(inputFile);
        return EXIT_FAILURE;
    }

    // Open symbol table output file
    symbolTableFile = fopen(argv[3], "w");
    if (!symbolTableFile) {
        perror("Error opening symbol table output file");
        fclose(inputFile);
        fclose(outputFile);
        return EXIT_FAILURE;
    }
    fprintf(stderr, "Parsing...\n");
    // Start parsing
    yyparse();

    // Close files
    fclose(inputFile);
    fclose(outputFile);

    return EXIT_SUCCESS;
}
