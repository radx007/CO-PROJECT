%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h> 

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

// Helper functions
Symbol* createSymbol(const char* name, const char* type, bool isConstant, const char* scope);
void insertSymbol(Symbol* symbol);
Symbol* findSymbol(const char* name);
void printSymbolTable();

typedef union {
    int iVal;           // For IntegerLiteral
    double rVal;        // For RealLiteral
    char cVal;          // For CharLiteral
    char* sVal;         // For StringLiteral
    char* identifier;   // For IDENTIFIER
} FactorValue;

typedef struct {
    int type;           // Type of the value (e.g., Integer, Real, String, etc.)
    FactorValue value;  // The actual value
} Factor;




%}

%union {
    int ival;
    float fval;
    char* sval;
    bool bval;
};

%token PROGRAM USES START END VAR CONST TYPE PROCEDURE FUNCTION IF THEN ELSE WHILE DO FOR TO BREAK CONTINUE DOWNTO REPEAT UNTIL CASE OF WRITE WRITELN READ READLN 
%token DIV MOD AND OR NOT ASSIGN EQUALS PLUS MINUS MULT DIVIDE NEQ LEQ GEQ LT GT
%token COLON SEMICOLON COMMA DOT DOTDOT LPAREN RPAREN LBRACKET RBRACKET
%token <sval> IDENTIFIER INTEGER REAL CHAR BOOLEAN ARRAY RECORD  
%token <ival> IntegerLiteral
%token <sval> CharLiteral StringLiteral
%token <fval> RealLiteral
%token <bval> BooleanLiteral

%type <sval> TYPES 
%type <Factor> factor simple_expression  expression
%type <bval> term 


%start program

%%

program:
    PROGRAM IDENTIFIER SEMICOLON program_part START statement_sequence END DOT  {
        { fprintf(stderr, "Program parsed successfully:\n"); exit(0); }
    }
    
;


program_part:
    constant_definition_part program_part_rest    
    | USES IDENTIFIER SEMICOLON program_part_rest {fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", $2, "raidd", ""); }
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
    IDENTIFIER EQUALS RealLiteral  SEMICOLON {
        Symbol* symbol = createSymbol($1, "REAL", true, "global");
        symbol->value.fval = $3;
        insertSymbol(symbol);
        fprintf(stderr, "1...\n");
    }
    |IDENTIFIER EQUALS IntegerLiteral  SEMICOLON {
        fprintf(stderr, "21...\n");
        Symbol* symbol = createSymbol($1, "INTEGER", true, "global");
        fprintf(stderr, "22...\n");
        symbol->value.ival = $3;
        fprintf(stderr, "23...\n");
        insertSymbol(symbol);
        fprintf(stderr, "2...\n");
    }
    |IDENTIFIER EQUALS StringLiteral  SEMICOLON SEMICOLON {
        Symbol* symbol = createSymbol($1, "STRING", true, "global");
        symbol->value.sval = strdup($3);
        insertSymbol(symbol);
        fprintf(stderr, "3...\n");
    }
    |IDENTIFIER EQUALS CharLiteral SEMICOLON {
        Symbol* symbol = createSymbol($1, "CHAR", true, "global");
        symbol->value.sval = strdup($3);
        insertSymbol(symbol);
        fprintf(stderr, "5...\n");
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
    INTEGER
    | REAL
    | CHAR
    | BOOLEAN
    | ARRAY LBRACKET scalable_constant DOTDOT scalable_constant RBRACKET OF TYPES
    | RECORD record_fields END
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
        fprintf(stderr, "61...\n");

        Symbol* symbol = createSymbol($1, $3, false, "global");
        fprintf(stderr, "62...\n");

        insertSymbol(symbol);
        fprintf(stderr, "6...\n");
    }
;

procedure_declaration:
    PROCEDURE IDENTIFIER formal_parameter_list SEMICOLON program_part START statement_sequence END SEMICOLON {
        Symbol* symbol = createSymbol($2, "PROCEDURE", false, "global");
        insertSymbol(symbol);
        fprintf(symbolTableFile, "Procedure '%s' stored.\n", $2);
        fprintf(stderr, "7...\n");
    }
;

function_declaration:
    FUNCTION IDENTIFIER formal_parameter_list COLON TYPES SEMICOLON program_part START statement_sequence END SEMICOLON {
        Symbol* symbol = createSymbol($2, "FUNCTION", false, "global");
        symbol->type = strdup($5); // Return type
        insertSymbol(symbol);
        fprintf(symbolTableFile, "Function '%s' stored.\n", $2);
        fprintf(stderr, "8...\n");
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
    expression
    | expression expression_list
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
    WRITELN LPAREN expression_list RPAREN
    |WRITE LPAREN expression_list RPAREN
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
      simple_expression  { $$ = $1; }
    | comparison_expr    { $$ = $1; }  // Comparison can return a boolean
    | logical_expr       { $$ = $1; }  // Logical operations can return a boolean
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
      factor AND factor  { $$ = $1 && $3; }
    | factor OR factor   { $$ = $1 || $3; }
    | NOT factor         { $$ = !$2; }
;


simple_expression:
      term
    | simple_expression PLUS term   { $$ = $1 + $3; }
    | simple_expression MINUS term  { $$ = $1 - $3; }
;

term:
      factor
    | term MULT factor   { $$ = $1 * $3; }
    | term DIVIDE factor { $$ = $1 / $3; }
    | term MOD factor    { $$ = $1 % $3; }
;

;

factor:
    IDENTIFIER        { $$ = (Factor*) malloc(sizeof(Factor)); $$->type = IDENTIFIER_TYPE; $$->value.identifier = $1; }
    | RealLiteral     { $$ = (Factor*) malloc(sizeof(Factor)); $$->type = REAL_TYPE; $$->value.rVal = $1; }
    | IntegerLiteral  { $$ = (Factor*) malloc(sizeof(Factor)); $$->type = INTEGER_TYPE; $$->value.iVal = $1; }
    | StringLiteral   { $$ = (Factor*) malloc(sizeof(Factor)); $$->type = STRING_TYPE; $$->value.sVal = $1; }
    | CharLiteral     { $$ = (Factor*) malloc(sizeof(Factor)); $$->type = CHAR_TYPE; $$->value.cVal = $1; }
    | LPAREN expression RPAREN
                      { $$ = $2; }  // Assuming expression is evaluated earlier and passed as a factor
;


%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s  | %d\n", s,yylineno);
}

/* ------------------------------------------------------------------ */

Symbol* createSymbol(const char* name, const char* type, bool isConstant, const char* scope) {
    if (name == NULL) {
        fprintf(stderr, "Error: Attempted to create symbol with NULL name\n");
        return NULL;
    }
    
    Symbol* symbol = (Symbol*)malloc(sizeof(Symbol));
    if (!symbol) {
        fprintf(stderr, "Error: Memory allocation failed for symbol\n");
        return NULL;
    }

    symbol->name = strdup(name);  // Make sure name is not NULL before strdup
    if (symbol->name == NULL) {
        fprintf(stderr, "Error: strdup failed for symbol name\n");
        free(symbol);
        return NULL;
    }

    symbol->type = strdup(type);
    if (symbol->type == NULL) {
        fprintf(stderr, "Error: strdup failed for symbol type\n");
        free(symbol->name);
        free(symbol);
        return NULL;
    }

    symbol->isConstant = isConstant;
    symbol->scope = strdup(scope);
    if (symbol->scope == NULL) {
        fprintf(stderr, "Error: strdup failed for symbol scope\n");
        free(symbol->name);
        free(symbol->type);
        free(symbol);
        return NULL;
    }

    symbol->next = NULL;
    return symbol;
}


void insertSymbol(Symbol* symbol) {
        fprintf(stderr, "a...\n");
    if (findSymbol(symbol->name)) {
        fprintf(stderr, "Error: Symbol '%s' already declared\n", symbol->name);
        return;
    }
    fprintf(stderr, "b...\n");
    symbol->next = symbolTable;
    symbolTable = symbol;
}

Symbol* findSymbol(const char* name) {
    fprintf(stderr, "t...\n");
    Symbol* current = symbolTable;
     fprintf(stderr, "t...\n");
    while (current) {
        fprintf(stderr, "i...\n");
        fprintf(stderr, "i... Comparing '%s' with '%s'\n", current->name, name);
        if (strcmp(current->name, name) == 0)
            return current;
        fprintf(stderr, "i...\n");    
        current = current->next;
        fprintf(stderr, "i...\n");
    }
     fprintf(stderr, "t...\n");
    return NULL;
}

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
