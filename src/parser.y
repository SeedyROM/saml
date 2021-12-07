%define parse.error verbose
%define api.pure full
%lex-param {void *scanner}
%parse-param {void *scanner}

%{
  #include "parser.tab.h"  
  #include "lex.yy.h"

  extern void yyerror(yyscan_t scanner, char const *message);
%}

%union {
  double d_val;
  int i_val;
  char c_val;
  char* s_val;
}

%token T_EOL
%token T_COLON T_DASH
%token <s_val> T_IDENT 

%start markup

%%

markup : nodes

nodes : node
  | nodes node

node : T_IDENT T_COLON T_IDENT
  | T_IDENT T_COLON T_IDENT T_EOL

%%
