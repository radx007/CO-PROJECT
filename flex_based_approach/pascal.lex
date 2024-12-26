%option case-insensitive
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

char* to_upper_case(char* str) {
    // Loop through the string and convert each character to uppercase
    for (int i = 0; str[i] != '\0'; i++) {
        str[i] = toupper((unsigned char)str[i]);  // Use toupper to convert to uppercase
    }
    return str;  // Return the modified string
}

FILE *output_file;

%}
USES
KEYWORDS ("PROGRAM"|"USES|"CONST"|"TYPE"|"INTEGER"|"REAL"|"CHAR"|"BOOLEAN"|"ARRAY"|"RECORD"|"END"|"PROCEDURE"|"FUNCTION"|"VAR"|"BEGIN"|"IF"|"THEN"|"ELSE"|"WHILE"|"DO"|"REPEAT"|"UNTIL"|"FOR"|"TO"|"DOWNTO"|"CASE"|"OF"|"BREAK"|"CONTINUE"|"READ"|"READLN"|"WRITE"|"WRITELN")
OPERATORS ("DIV"|"MOD"|"AND"|"OR"|"NOT"|":="|"="|"+"|"-"|"*"|"/"|"<>"|"<="|">="|"<"|">")
DELIMITERS (":"|";"|","|"."|".."|"("|")"|"["|"]")
IDENTIFIER [A-Za-z_][A-Za-z0-9_]{0,30}


%%

{KEYWORDS}          { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Keyword", ""); return to_upper_case(yytext) }
{OPERATORS}         { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Operator", ""); return to_upper_case(yytext) }
{DELIMITERS}        { fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Delimiter", ""); return to_upper_case(yytext)  }

[+-]?([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)([eE][+-]?[0-9]+)? {
    fprintf(output_file, "| %-15s | %-15s | %-10s %s |\n", yytext, "RealLiteral", "", yytext); return 
}

[+-]?[0-9]+ {
    fprintf(output_file, "| %-15s | %-15s | %-10s %s |\n", yytext, "IntegerLiteral", "", yytext);
}

'[^\\n\']' {
    fprintf(output_file, "| %-15s | %-15s | %-10s %s |\n", yytext, "CharLiteral", "", yytext);
}

'(('')|[^'\n])*' {
    fprintf(output_file, "| %-15s | %-15s | %-10s %s |\n", yytext, "StringLiteral", "", yytext);
}

([Tt][Rr][Uu][Ee]|[Ff][Aa][Ll][Ss][Ee]) {
    fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "BooleanLiteral", "");
}

\{[^}]*\} {}  

\(\*[^*]*\*[^)]*\) {}  



{IDENTIFIER}   {   fprintf(output_file, "| %-15s | %-15s | %-10s |\n", yytext, "Identifier", ""); }

([0-9]|[#$@!-])+(({IDENTIFIER}[#$@!-]+)|{IDENTIFIER}) { fprintf(output_file, "Lexical Error: Unrecognized character: %s\n", yytext); }

[ \t\n]+      {} ;


. { fprintf(output_file, "Lexical Error: Unrecognllllized character: %s\n", yytext); }

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
