%{
#include <stdio.h>
#include <stdlib.h>

int  yylex();
void yyerror(const char *s);

extern int   yyline;
extern int   token_count;
extern FILE *yyin;

void print_token_table(void);

int warning_count    = 0;
int error_count      = 0;
int struct_count     = 0;
int last_error_line  = -1;
%}

/* --- Operator precedence (lowest to highest) --- */
%left  OP_EQ OP_NEQ OP_GT OP_LT OP_GE OP_LE
%left  OP_EQ_NUM OP_NEQ_NUM OP_GT_NUM OP_LT_NUM OP_GE_NUM OP_LE_NUM
%left  PLUS MINUS
%left  STAR SLASH
%right UMINUS

/* --- Tokens --- */
%token DANGEROUS_CMD
%token IF THEN ELIF ELSE FI
%token FOR IN DO DONE WHILE
%token TOKEN_ECHO
%token IDENTIFIER NUMBER STRING VAR_REF
%token ASSIGN SEMICOLON
%token LBRACKET RBRACKET
%token PLUS MINUS STAR SLASH LPAREN RPAREN
%token ARITH_OPEN ARITH_CLOSE
%token OP_EQ OP_NEQ OP_GT OP_LT OP_GE OP_LE
%token OP_EQ_NUM OP_NEQ_NUM OP_GT_NUM OP_LT_NUM OP_GE_NUM OP_LE_NUM

%start program
%%

/* ============================================================
   PROGRAM
============================================================ */
program
    : stmt_list
    ;

stmt_list
    : /* empty */
    | stmt_list stmt
    ;

stmt
    : if_stmt
    | for_stmt
    | while_stmt
    | echo_stmt
    | assign_stmt
    | arith_stmt
    | SEMICOLON
    | DANGEROUS_CMD
        {
            warning_count++;
            printf("\n  [!] SECURITY WARNING -- Dangerous command detected and BLOCKED\n");
            printf("      Line %d\n", yyline);
        }
    | error SEMICOLON   { error_count++; yyerrok; }
    | error DONE        { error_count++; yyerrok; }
    | error FI          { error_count++; yyerrok; }
    ;

/* ============================================================
   IF / ELIF / ELSE
============================================================ */
if_stmt
    : IF condition THEN stmt_list FI
        {
            struct_count++;
            printf("\n+------------------------------------------+\n");
            printf("|  VALID  IF statement                     |\n");
            printf("|  if <cond> then                          |\n");
            printf("|    <statements>                          |\n");
            printf("|  fi                                      |\n");
            printf("+------------------------------------------+\n");
        }
    | IF condition THEN stmt_list ELSE stmt_list FI
        {
            struct_count++;
            printf("\n+------------------------------------------+\n");
            printf("|  VALID  IF-ELSE statement                |\n");
            printf("|  if <cond> then                          |\n");
            printf("|    <statements>                          |\n");
            printf("|  else                                    |\n");
            printf("|    <statements>                          |\n");
            printf("|  fi                                      |\n");
            printf("+------------------------------------------+\n");
        }
    | IF condition THEN stmt_list elif_chain FI
        {
            struct_count++;
            printf("\n+------------------------------------------+\n");
            printf("|  VALID  IF-ELIF statement                |\n");
            printf("|  if <cond> then                          |\n");
            printf("|    <statements>                          |\n");
            printf("|  elif <cond> then                        |\n");
            printf("|    <statements>                          |\n");
            printf("|  fi                                      |\n");
            printf("+------------------------------------------+\n");
        }
    | IF condition THEN stmt_list elif_chain ELSE stmt_list FI
        {
            struct_count++;
            printf("\n+------------------------------------------+\n");
            printf("|  VALID  IF-ELIF-ELSE statement           |\n");
            printf("|  if <cond> then ... elif ... else ... fi |\n");
            printf("+------------------------------------------+\n");
        }
    ;

elif_chain
    : ELIF condition THEN stmt_list
    | elif_chain ELIF condition THEN stmt_list
    ;

/* ============================================================
   FOR
============================================================ */
for_stmt
    : FOR IDENTIFIER IN word_list DO stmt_list DONE
        {
            struct_count++;
            printf("\n+------------------------------------------+\n");
            printf("|  VALID  FOR loop                         |\n");
            printf("|  for <var> in <list>                     |\n");
            printf("|  do                                      |\n");
            printf("|    <statements>                          |\n");
            printf("|  done                                    |\n");
            printf("+------------------------------------------+\n");
        }
    ;

word_list
    : atom
    | word_list atom
    ;

/* ============================================================
   WHILE
============================================================ */
while_stmt
    : WHILE condition DO stmt_list DONE
        {
            struct_count++;
            printf("\n+------------------------------------------+\n");
            printf("|  VALID  WHILE loop                       |\n");
            printf("|  while <cond>                            |\n");
            printf("|  do                                      |\n");
            printf("|    <statements>                          |\n");
            printf("|  done                                    |\n");
            printf("+------------------------------------------+\n");
        }
    ;

/* ============================================================
   ECHO
============================================================ */
echo_stmt
    : TOKEN_ECHO rhs
        { printf("\n  [OK] VALID ECHO  -->  echo <value>\n"); }
    ;

/* ============================================================
   ASSIGNMENT
============================================================ */
assign_stmt
    : IDENTIFIER ASSIGN rhs
        { printf("\n  [OK] VALID Assignment  -->  identifier = <expr>\n"); }
    ;

/* ============================================================
   RHS
============================================================ */
rhs
    : arith_group
    | expr
    ;

/* ============================================================
   ARITHMETIC STATEMENT
============================================================ */
arith_stmt
    : arith_group
        { printf("\n  [OK] VALID Arithmetic  -->  $(( <expr> ))\n"); }
    ;

arith_group
    : ARITH_OPEN expr ARITH_CLOSE
    ;

/* ============================================================
   EXPRESSION
============================================================ */
expr
    : atom
    | expr PLUS  expr
    | expr MINUS expr
    | expr STAR  expr
    | expr SLASH expr
    | MINUS expr          %prec UMINUS
    | LPAREN expr RPAREN
    ;

atom
    : NUMBER
    | STRING
    | IDENTIFIER
    | VAR_REF
    ;

/* ============================================================
   CONDITION
============================================================ */
condition
    : LBRACKET cond_expr RBRACKET
    | IDENTIFIER
    | VAR_REF
    ;

cond_expr
    : atom comparison_op atom
    | atom
    ;

comparison_op
    : OP_EQ      | OP_NEQ
    | OP_GT      | OP_LT
    | OP_GE      | OP_LE
    | OP_EQ_NUM  | OP_NEQ_NUM
    | OP_GT_NUM  | OP_LT_NUM
    | OP_GE_NUM  | OP_LE_NUM
    ;

%%

/* --- error handler --- */
void yyerror(const char *s) {
    if (yyline != last_error_line) {
        fprintf(stderr, "\n  [ERROR] Line %d -- %s\n", yyline, s);
        last_error_line = yyline;
        error_count++;
    }
}

/* --- main --- */
int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <script.sh>\n", argv[0]);
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) { perror("Cannot open file"); return 1; }

    printf("\n");
    printf("+--------------------------------------------------+\n");
    printf("|   Bash Script Lexical & Syntax Security Analyzer |\n");
    printf("|   File : %-40s|\n", argv[1]);
    printf("+--------------------------------------------------+\n");

    yyparse();

    print_token_table();

    printf("\n+----------------------------------------------+\n");
    printf("|              ANALYSIS SUMMARY                |\n");
    printf("+----------------------------------------------+\n");
    printf("|  Total tokens found  : %-22d|\n", token_count);
    printf("|  Valid structures    : %-22d|\n", struct_count);
    printf("|  Security warnings   : %-22d|\n", warning_count);
    printf("|  Syntax errors       : %-22d|\n", error_count);
    printf("+----------------------------------------------+\n");
    if (warning_count == 0 && error_count == 0)
        printf("|  Status : PASSED SECURITY CHECK              |\n");
    else
        printf("|  Status : FAILED -- REVIEW REQUIRED          |\n");
    printf("+----------------------------------------------+\n\n");

    fclose(yyin);
    return (warning_count + error_count) > 0 ? 1 : 0;
}
