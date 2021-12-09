%code top {
  #include "scanner.h"
}

%define parse.error verbose // Return fully verbose parsing errors
%define api.pure full // Use a fully pure reentrant parser (AKA NO GLOBAL STATE)
%lex-param {void* scanner} // Stub out our parser state struct as void* for now
%parse-param {void* scanner} // Same here
%parse-param {saml_scanner* saml} // Pass something we can use to store tokens!
%define api.token.prefix {T_} // Preface the tokens with T_ makes 
                              // this file more human readable

%{
  // Include the generated parser/scanner code
  #include "parser.tab.h"  
  #include "lex.yy.h"

  // Forward declare the yyerror method to handle errors
  extern void yyerror(yyscan_t scanner, saml_scanner* saml, char const *message);
%}

// This union describes a tokens result value state
%union {
  double d_val;
  int i_val;
  char c_val;
  char* s_val;
}

// Typical tokens
%token EOL
%token COLON
%token <s_val> IDENT
%token <s_val> STRING

%type <s_val> key;
%type <s_val> value;

// Entrypoint
%start markup

%%

markup : nodes

nodes : node
  | nodes node
  | nodes EOL

node : key COLON value { printf("%s=%s\n", $1, $3); saml->pos.col++; }
  | key COLON value EOL { printf("%s=%s\n", $1, $3); saml->pos.col++; }

key : IDENT { $$ = $1; }
  | STRING {$$ = $1; }

value : IDENT { $$ = $1; }
  | STRING { $$ = $1; }

%%
