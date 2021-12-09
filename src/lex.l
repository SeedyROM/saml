%option 8bit reentrant bison-bridge
%option warn noyywrap nodefault
%option header-file="src/lex.yy.h"

%{
  #include <string.h>
  
  #include "scanner.h"
  #include "parser.tab.h"  

  extern void yyerror(yyscan_t scanner, saml_scanner* saml, const char* message);
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
  \n               {
                      yyerror(yyscanner, NULL, "unexpected EOL for open \"");
                      return 0;
                   }
  <<EOF>>          {
                      yyerror(yyscanner, NULL, "unexpected EOF for open \"");
                      return 0;
                   }
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