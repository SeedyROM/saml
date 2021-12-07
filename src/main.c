#include <stdio.h>

#include "log.h"

#include "parser.tab.h"
#include "lex.yy.h"


int main(int argc, char* argv[]) {
  log_debug("Hello %s", "world");

  yyscan_t scanner;
  yylex_init(&scanner);
  yyset_in(stdin, scanner);
  yyparse(scanner);
  yylex_destroy(scanner);

  return 0;
}

void yyerror(yyscan_t scanner, const char* message) {
  log_error("Parse error: %s\n", message);
}