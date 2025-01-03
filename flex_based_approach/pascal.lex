%option case-insensitive
%option yylineno
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include "pascal.tab.h"

FILE *outputFile;
FILE *symbolTableFile;
%}

DELIMITERS (":"|";"|","|"."|".."|"("|")"|"["|"]")
IDENTIFIER [A-Za-z_][A-Za-z0-9_]{0,30}

%%

"PROGRAM"           { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return PROGRAM; }
"USES"              { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return USES; }
"BEGIN"             { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return START; }
"END"               { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return END; }
"VAR"               { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return VAR; }
"CONST"             { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return CONST; }
"TYPE"              { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return TYPE; }
"PROCEDURE"         { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return PROCEDURE; }
"FUNCTION"          { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return FUNCTION; }
"IF"                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return IF; }
"THEN"              { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return THEN; }
"ELSE"              { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return ELSE; }
"WHILE"             { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return WHILE; }
"DO"                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return DO; }
"FOR"               { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return FOR; }
"TO"                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return TO; }
"BREAK"             { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return BREAK; }
"CONTINUE"          { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return CONTINUE; }
"DOWNTO"            { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return DOWNTO; }
"REPEAT"            { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return REPEAT; }
"UNTIL"             { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return UNTIL; }
"CASE"              { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return CASE; }
"OF"                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return OF; }
"WRITE"             { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return WRITE; }
"WRITELN"           { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return WRITELN; }
"READ"              { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return READ; }
"READLN"            { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return READLN; }
"INTEGER"           { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return INTEGER; }
"REAL"              { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return REAL; }
"CHAR"              { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return CHAR; }
"BOOLEAN"           { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return BOOLEAN; }
"ARRAY"             { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return ARRAY; }
"RECORD"            { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return RECORD; }

"DIV"               { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return DIV; }
"MOD"               { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return MOD; }
"AND"               { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return AND; }
"OR"                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return OR; }
"NOT"               { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return NOT; }
":="                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return ASSIGN; }
"="                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return EQUALS; }
"+"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return PLUS; }
"-"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return MINUS; }
"*"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return MULT; }
"/"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return DIVIDE; }
"<>"                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return NEQ; }
"<="                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return LEQ; }
">="                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return GEQ; }
"<"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return LT; }
">"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return GT; }

":"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return COLON; }
";"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return SEMICOLON; }
","                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return COMMA; }
"."                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return DOT; }
".."                { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return DOTDOT; }
"("                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return LPAREN; }
")"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return RPAREN; }
"["                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return LBRACKET; }
"]"                 { fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return RBRACKET; }

[+-]?([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)([eE][+-]?[0-9]+)? {
    yylval.fval = atof(yytext);
    fprintf(outputFile, "| %-15s | %-15s | %-10s %s |\n", yytext, "RealLiteral", "", yytext); return RealLiteral;
}

[+-]?[0-9]+ {
    yylval.ival = atoi(yytext);
    fprintf(outputFile, "| %-15s | %-15s | %-10s %s |\n", yytext, "IntegerLiteral", "", yytext); return IntegerLiteral;
}

'[^\\n\']' {
    yylval.sval = strdup(yytext);
    fprintf(outputFile, "| %-15s | %-15s | %-10s %s |\n", yytext, "CharLiteral", "", yytext); return CharLiteral;
}

'(('')|[^'\n])*' {
    yylval.sval = strdup(yytext);
    fprintf(outputFile, "| %-15s | %-15s | %-10s %s |\n", yytext, "StringLiteral", "", yytext); return StringLiteral;
}

([Tt][Rr][Uu][Ee]|[Ff][Aa][Ll][Ss][Ee]) {
    yylval.bval = (strcasecmp(yytext, "true") == 0);
    fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "BooleanLiteral", ""); return BooleanLiteral;
}

\{[^}]*\} {}  

\(\*[^*]*\*[^)]*\) {}  

{IDENTIFIER}   { yylval.sval = strdup(yytext); fprintf(outputFile, "| %-15s | %-15s | %-10s |\n", yytext, "Identifier", ""); return IDENTIFIER; }

([0-9]|[#$@!-])+(({IDENTIFIER}[#$@!-]+)|{IDENTIFIER}) { fprintf(outputFile, "Lexical Error: Unrecognized token: %s found on line %d\n", yytext,yylineno); }

[ \t\n]+      {} ;

. { fprintf(outputFile, "Lexical Error: Unrecognized token: %s found on line %d\n", yytext,yylineno); }

%%

int yywrap(void) {
    if (outputFile) fclose(outputFile);
    return 1;  
}