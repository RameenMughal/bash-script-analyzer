%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"

int yyline      = 1;
int token_count = 0;

typedef struct {
    int  line;
    char type[32];
    char value[128];
} TokenEntry;

#define MAX_TOKENS 2048
TokenEntry token_table[MAX_TOKENS];
int table_size = 0;

void record_token(const char *type, const char *value) {
    if (table_size < MAX_TOKENS) {
        token_table[table_size].line = yyline;
        strncpy(token_table[table_size].type,  type,  31);
        strncpy(token_table[table_size].value, value, 127);
        token_table[table_size].type[31]   = '\0';
        token_table[table_size].value[127] = '\0';
        table_size++;
    }
    token_count++;
}

void print_token_table(void) {
    int i;
    printf("\n");
    printf("+------+---------------------+--------------------------------+\n");
    printf("| LINE | TOKEN TYPE          | VALUE                          |\n");
    printf("+------+---------------------+--------------------------------+\n");
    for (i = 0; i < table_size; i++) {
        printf("| %-4d | %-19s | %-30s |\n",
               token_table[i].line,
               token_table[i].type,
               token_table[i].value);
    }
    printf("+------+---------------------+--------------------------------+\n");
}
%}

%option noyywrap

%%

\n              { yyline++; /* count lines but do NOT return a token */ }
[ \t]+          { /* skip whitespace */ }

"#!"[^\n]*      { /* shebang, ignore */ }
#[^\n]*         { /* comment, ignore */ }

"$(("           { record_token("ARITH_OPEN",  "$((" ); return ARITH_OPEN;  }
"))"            { record_token("ARITH_CLOSE", "))"  ); return ARITH_CLOSE; }

"rm"[ \t]+"--"[^\n]*          { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"rm"[ \t]+"-"[rRfFvn]+[^\n]*  { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"chmod"[ \t]+[^\n]*            { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"dd"[ \t]+"if="[^\n]*          { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"mkfs"[^\n]*                   { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"wget"[ \t]+[^\n]*"|"[^\n]*    { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"curl"[ \t]+[^\n]*"|"[^\n]*    { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"sudo"[ \t]+[^\n]*             { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"chown"[ \t]+[^\n]*            { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"iptables"[ \t]+[^\n]*         { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"passwd"[ \t]+[^\n]*           { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"useradd"[ \t]+[^\n]*          { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"userdel"[ \t]+[^\n]*          { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"shutdown"[^\n]*               { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"reboot"[^\n]*                 { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"shred"[ \t]+[^\n]*            { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"eval"[ \t]+[^\n]*             { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
":(){"[^\n]*                   { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
":()"[ \t]*"{"[^\n]*           { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"nc"[ \t]+[^\n]*               { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }
"netcat"[ \t]+[^\n]*           { record_token("DANGEROUS_CMD", yytext); return DANGEROUS_CMD; }

"=="    { record_token("OP_EQ",      "==" ); return OP_EQ;      }
"!="    { record_token("OP_NEQ",     "!=" ); return OP_NEQ;     }
">="    { record_token("OP_GE",      ">=" ); return OP_GE;      }
"<="    { record_token("OP_LE",      "<=" ); return OP_LE;      }
">"     { record_token("OP_GT",      ">"  ); return OP_GT;      }
"<"     { record_token("OP_LT",      "<"  ); return OP_LT;      }

"-eq"   { record_token("OP_EQ_NUM",  "-eq"); return OP_EQ_NUM;  }
"-ne"   { record_token("OP_NEQ_NUM", "-ne"); return OP_NEQ_NUM; }
"-lt"   { record_token("OP_LT_NUM",  "-lt"); return OP_LT_NUM;  }
"-le"   { record_token("OP_LE_NUM",  "-le"); return OP_LE_NUM;  }
"-gt"   { record_token("OP_GT_NUM",  "-gt"); return OP_GT_NUM;  }
"-ge"   { record_token("OP_GE_NUM",  "-ge"); return OP_GE_NUM;  }

"+"     { record_token("PLUS",   "+" ); return PLUS;   }
"-"     { record_token("MINUS",  "-" ); return MINUS;  }
"*"     { record_token("STAR",   "*" ); return STAR;   }
"/"     { record_token("SLASH",  "/" ); return SLASH;  }
"("     { record_token("LPAREN", "(" ); return LPAREN; }
")"     { record_token("RPAREN", ")" ); return RPAREN; }

"$"[a-zA-Z_][a-zA-Z0-9_]*  { record_token("VAR_REF",    yytext); return VAR_REF;     }

"if"    { record_token("IF",    "if"   ); return IF;         }
"then"  { record_token("THEN",  "then" ); return THEN;       }
"elif"  { record_token("ELIF",  "elif" ); return ELIF;       }
"else"  { record_token("ELSE",  "else" ); return ELSE;       }
"fi"    { record_token("FI",    "fi"   ); return FI;         }
"for"   { record_token("FOR",   "for"  ); return FOR;        }
"in"    { record_token("IN",    "in"   ); return IN;         }
"do"    { record_token("DO",    "do"   ); return DO;         }
"done"  { record_token("DONE",  "done" ); return DONE;       }
"while" { record_token("WHILE", "while"); return WHILE;      }
"echo"  { record_token("ECHO",  "echo" ); return TOKEN_ECHO; }

\"[^\"]*\"  { record_token("STRING",     yytext); return STRING;     }
\'[^\']*\'  { record_token("STRING",     yytext); return STRING;     }
[0-9]+      { record_token("NUMBER",     yytext); return NUMBER;     }

[a-zA-Z_][a-zA-Z0-9_]*  { record_token("IDENTIFIER", yytext); return IDENTIFIER; }

"="  { record_token("ASSIGN",    "=" ); return ASSIGN;    }
";"  { record_token("SEMICOLON", ";" ); return SEMICOLON; }
"["  { record_token("LBRACKET",  "[" ); return LBRACKET;  }
"]"  { record_token("RBRACKET",  "]" ); return RBRACKET;  }

.    { /* ignore unknown characters */ }

%%
