%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h> 

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int ival;
    float fval;
    char* sval;
    bool bval
} yylval;

%token PROGRAM USES BEGIN END VAR CONST TYPE PROCEDURE FUNCTION IF THEN ELSE WHILE DO FOR TO BREAK CONTINUE DOWNTO REPEAT UNTIL CASE OF WRITE WRITELN READ READLN INTEGER REAL CHAR BOOLEAN ARRAY RECORD
%token DIV MOD AND OR NOT ASSIGN EQUALS PLUS MINUS MULT DIVIDE NEQ LEQ GEQ LT GT
%token COLON SEMICOLON COMMA DOT DOTDOT LPAREN RPAREN LBRACKET RBRACKET
%token IDENTIFIER     
%token <ival> IntegerLiteral
%token <sval> CharLiteral StringLiteral
%token <fval> RealLiteral
%token <bval> BooleanLiteral

%start program

%%

program:
    PROGRAM IDENTIFIER SEMICOLON program_part BEGIN statement_sequence END DOT
    {
        printf("Program parsed successfully: %s\n", $2);
    }
;

program_part:
    constant_definition_part
    | type_definition_part
    | variable_declaration_part
    | procedure_declaration
    | function_declaration
;

constant_definition_part:
    CONST constant_definition_list
;

constant_definition_list:
    constant_definition
    | constant_definition constant_definition_list
;

constant_definition:
    IDENTIFIER EQUALS RealLiteral  SEMICOLON
    |IDENTIFIER EQUALS IntegerLiteral  SEMICOLON
    |IDENTIFIER EQUALS StringLiteral  SEMICOLON
    |IDENTIFIER EQUALS CharLiteral SEMICOLON
    
;

type_definition_part:
    TYPE type_definition_list
;

type_definition_list:
    type_definition
    | type_definition type_definition_list
;

type_definition:
    IDENTIFIER EQUALS TYPE SEMICOLON
;

constant:
    IntegerLiteral         
    | StringLiteral        
    | CharLiteral  
    | BooleanLiteral 
;
scalable_constant:
    IntegerLiteral         
    | CharLiteral   

;


type:
    INTEGER
    | REAL
    | CHAR
    | BOOLEAN
    | ARRAY LBRACKET scalable_constant DOTDOT scalable_constant RBRACKET OF TYPE
    | RECORD record_fields END
;

record_fields:
    record_field
    | record_field record_fields
;

record_field:
    IDENTIFIER COLON type SEMICOLON
;

variable_declaration_part:
    VAR variable_declaration_list
;

variable_declaration_list:
    variable_declaration
    | variable_declaration variable_declaration_list
;

variable_declaration:
    IDENTIFIER COLON TYPE SEMICOLON
;

procedure_declaration:
    PROCEDURE IDENTIFIER formal_parameter_list SEMICOLON program_part BEGIN statement_sequence END SEMICOLON
;

function_declaration:
    FUNCTION IDENTIFIER formal_parameter_list COLON TYPE SEMICOLON program_part BEGIN statement_sequence END SEMICOLON
;

formal_parameter_list:
    LPAREN formal_parameter_list_items RPAREN
;

formal_parameter_list_items:
    formal_parameter
    | formal_parameter formal_parameter_list_items
;

formal_parameter:
    VAR IDENTIFIER COLON TYPE
    | IDENTIFIER COLON type
;

statement_sequence:
    statement
    | statement statement_sequence
;

statement:
    assignment_statement
    | procedure_call_statement
    | if_statement
    | while_statement
    | repeat_statement
    | for_statement
    | case_statement
    | input_statement
    | output_statement
    | BREAK
    | CONTINUE
;

assignment_statement:
    IDENTIFIER EQUALS expression
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
    FOR IDENTIFIER EQUALS expression TO expression DO statement
    |FOR IDENTIFIER EQUALS expression DOWNTO expression DO statement
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
    READ LPAREN variable_list RPAREN
;

output_statement:
    WRITE LPAREN expression_list RPAREN
;

variable_list:
    IDENTIFIER
    | IDENTIFIER variable_list
;

expression:
    simple_expression
    | simple_expression relational_operator simple_expression
;

simple_expression:
    PLUS term
    | MINUS term
    | term
;

term:
    factor
    | factor MULT factor
    | factor DIVIDE factor
;

factor:
    IDENTIFIER
    | RealLiteral 
    | IntegerLiteral
    | StringLiteral
    | CharLiteral
    | LPAREN expression RPAREN
;

relational_operator:
    EQUALS
    | NEQ
    | LT
    | LEQ
    | GT
    | GEQ
;

%%

int main() {
    printf("PASCAL PARSER\n");
    yyparse();
    return 0;
}
