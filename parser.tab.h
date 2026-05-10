/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    UMINUS = 258,                  /* UMINUS  */
    DANGEROUS_CMD = 259,           /* DANGEROUS_CMD  */
    IF = 260,                      /* IF  */
    THEN = 261,                    /* THEN  */
    ELIF = 262,                    /* ELIF  */
    ELSE = 263,                    /* ELSE  */
    FI = 264,                      /* FI  */
    FOR = 265,                     /* FOR  */
    IN = 266,                      /* IN  */
    DO = 267,                      /* DO  */
    DONE = 268,                    /* DONE  */
    WHILE = 269,                   /* WHILE  */
    TOKEN_ECHO = 270,              /* TOKEN_ECHO  */
    IDENTIFIER = 271,              /* IDENTIFIER  */
    NUMBER = 272,                  /* NUMBER  */
    STRING = 273,                  /* STRING  */
    VAR_REF = 274,                 /* VAR_REF  */
    ASSIGN = 275,                  /* ASSIGN  */
    SEMICOLON = 276,               /* SEMICOLON  */
    LBRACKET = 277,                /* LBRACKET  */
    RBRACKET = 278,                /* RBRACKET  */
    PLUS = 279,                    /* PLUS  */
    MINUS = 280,                   /* MINUS  */
    STAR = 281,                    /* STAR  */
    SLASH = 282,                   /* SLASH  */
    LPAREN = 283,                  /* LPAREN  */
    RPAREN = 284,                  /* RPAREN  */
    ARITH_OPEN = 285,              /* ARITH_OPEN  */
    ARITH_CLOSE = 286,             /* ARITH_CLOSE  */
    OP_EQ = 287,                   /* OP_EQ  */
    OP_NEQ = 288,                  /* OP_NEQ  */
    OP_GT = 289,                   /* OP_GT  */
    OP_LT = 290,                   /* OP_LT  */
    OP_GE = 291,                   /* OP_GE  */
    OP_LE = 292,                   /* OP_LE  */
    OP_EQ_NUM = 293,               /* OP_EQ_NUM  */
    OP_NEQ_NUM = 294,              /* OP_NEQ_NUM  */
    OP_GT_NUM = 295,               /* OP_GT_NUM  */
    OP_LT_NUM = 296,               /* OP_LT_NUM  */
    OP_GE_NUM = 297,               /* OP_GE_NUM  */
    OP_LE_NUM = 298                /* OP_LE_NUM  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
