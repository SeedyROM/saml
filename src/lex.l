%option 8bit reentrant bison-bridge
%option warn noyywrap nodefault
%option header-file="src/lex.yy.h"

%{
  #include <string.h>

  #include "parser.tab.h"  

  int current_line_indent = 0;
  int indent_level = 0;
%}

%%

" "          ;
\n           { return T_EOL; }
":"          { return T_COLON; }
"-"          { return T_DASH; }
[a-zA-Z_-]+  { 
                yylval->s_val = strdup(yytext);
                return T_IDENT; 
             }

%%