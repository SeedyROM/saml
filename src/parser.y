%define parse.error verbose // Return fully verbose parsing errors
%define api.pure full // Use a fully pure reentrant parser (AKA NO GLOBAL STATE)
%lex-param {void *scanner} // Stub out our parser state struct as void* for now
%parse-param {void *scanner} // Same here

%{
  // Include the generated parser/scanner code
  #include "parser.tab.h"  
  #include "lex.yy.h"

  // Forward declare the yyerror method to handle errors
  extern void yyerror(yyscan_t scanner, char const *message);
%}

// This union describes a tokens result value state
%union {
  double d_val;
  int i_val;
  char c_val;
  char* s_val;
}

// Typical tokens
%token T_EOL
%token T_COLON T_DASH
%token <s_val> T_IDENT 

// Entrypoint
%start markup

%%

markup : nodes

nodes : node
  | nodes node

node : T_IDENT T_COLON T_IDENT
  | T_IDENT T_COLON T_IDENT T_EOL

%%
