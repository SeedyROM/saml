%option 8bit reentrant bison-bridge
%option warn noyywrap nodefault
%option debug
%option header-file="src/lex.yy.h"

%{
  #include <string.h>

  #include "parser.tab.h"  

  extern void yyerror(const char* message);

  int current_line_indent = 0;
  int indent_level = 0;
%}

%x SINGLE_STRING
%x SINGLE_LINE_COMMENT

%%

" "                ;
\n                 { return T_EOL; }
":"                { return T_COLON; }
[a-zA-Z_-]+        { 
                      yylval->s_val = strdup(yytext);
                      return T_IDENT; 
                   }

\"                 BEGIN(SINGLE_STRING);
<SINGLE_STRING>{
  \n               yyerror("the string misses \" to termiate before newline");
  <<EOF>>          yyerror("the string misses \" to terminate before EOF");
  ([^\\\"]|\\.)*   { 
                      yylval->s_val = strdup(yytext);
                      return T_STRING; 
                    }
  \"               BEGIN(INITIAL);
  .                ;
}

#                  BEGIN(SINGLE_LINE_COMMENT);
<SINGLE_LINE_COMMENT>{
  \n               BEGIN(INITIAL);
  .                ;
}
%%