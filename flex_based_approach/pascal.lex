%option case-insensitive
%option yylineno
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>


FILE *output_file;

%}
USES

DELIMITERS (":"|";"|","|"."|".."|"("|")"|"["|"]")
IDENTIFIER [A-Za-z_][A-Za-z0-9_]{0,30}


%%
"PROGRAM"           { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return PROGRAM; }
"USES"           { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return USES; }
"BEGIN"             { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return BEGIN; }
"END"               { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return END; }
"VAR"               { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return VAR; }
"CONST"             { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return CONST; }
"TYPE"              { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return TYPE; }
"PROCEDURE"         { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return PROCEDURE; }
"FUNCTION"          { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return FUNCTION; }
"IF"                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return IF; }
"THEN"              { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return THEN; }
"ELSE"              { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return ELSE; }
"WHILE"             { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return WHILE; }
"DO"                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return DO; }
"FOR"               { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return FOR; }
"TO"                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return TO; }
"BREAK"             { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return BREAK; }
"CONTINUE"          { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return CONTINUE; }
"DOWNTO"            { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return DOWNTO; }
"REPEAT"            { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return REPEAT; }
"UNTIL"             { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return UNTIL; }
"CASE"              { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return CASE; }
"OF"                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return OF; }
"WRITE"             { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return WRITE; }
"WRITELN"           { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return WRITELN; }
"READ"              { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return READ; }
"READLN"            { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return READLN; }
"INTEGER"           { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return INTEGER; }
"REAL"              { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return REAL; }
"CHAR"              { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return CHAR; }
"BOOLEAN"           { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return BOOLEAN; }
"ARRAY"             { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return ARRAY; }
"RECORD"            { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return RECORD; }

"DIV"               { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return DIV; }
"MOD"               { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return MOD; }
"AND"               { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return AND; }
"OR"                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return OR; }
"NOT"               { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return NOT; }
":="                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return ASSIGN; }
"="                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return EQUALS; }
"+"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return PLUS; }
"-"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return MINUS; }
"*"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return MULT; }
"/"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return DIVIDE; }
"<>"                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return NEQ; }
"<="                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return LEQ; }
">="                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return GEQ; }
"<"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return LT; }
">"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return GT; }

":"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return COLON; }
";"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return SEMICOLON; }
","                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return COMMA; }
"."                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return DOT; }
".."                { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return DOTDOT; }
"("                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return LPAREN; }
")"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return RPAREN; }
"["                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return LBRACKET; }
"]"                 { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return RBRACKET; }


[+-]?([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)([eE][+-]?[0-9]+)? {
    fprintf(output_file, "| %-15s | %-15s | %-10s %s |\n", yytext, "RealLiteral", "", yytext); return RealLiteral;
}

[+-]?[0-9]+ {
    fprintf(output_file, "| %-15s | %-15s | %-10s %s |\n", yytext, "IntegerLiteral", "", yytext); return IntegerLiteral;
}

'[^\\n\']' {
    fprintf(output_file, "| %-15s | %-15s | %-10s %s |\n", yytext, "CharLiteral", "", yytext); return CharLiteral;
}

'(('')|[^'\n])*' {
    fprintf(output_file, "| %-15s | %-15s | %-10s %s |\n", yytext, "StringLiteral", "", yytext); return StringLiteral;
}

([Tt][Rr][Uu][Ee]|[Ff][Aa][Ll][Ss][Ee]) {
    fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "BooleanLiteral", ""); return BooleanLiteral;
}

\{[^}]*\} {}  

\(\*[^*]*\*[^)]*\) {}  


{IDENTIFIER}   {   fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Identifier", ""); return IDENTIFIER;
}

([0-9]|[#$@!-])+(({IDENTIFIER}[#$@!-]+)|{IDENTIFIER}) { fprintf(output_file, "Lexical Error: Unrecognized token: %s found on line %d\n", yytext,yylineno); }

[ \t\n]+      {} ;


. { fprintf(output_file, "Lexical Error: Unrecognized token: %s found on line %d\n", yytext,yylineno); }

%%

int main(int argc, char *argv[]) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error opening input file");
        return 1;
    }

    output_file = fopen(argv[2], "w");
    if (!output_file) {
        perror("Error opening output file");
        return 1;
    }

    // Print header for the table
    fprintf(output_file, "| %-15s | %-15s | %-10s |\n", "Lexeme", "Category", "Value");
    fprintf(output_file, "|-----------------|-----------------|------------|\n");

    yyin = input_file;
    yylex();

    fclose(input_file);
    fclose(output_file);

    return 0;
}

int yywrap(void) {
    return 1;  // Return non-zero to indicate that the input is finished
}
