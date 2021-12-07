#include <stdio.h>
#include <assert.h>

#include "log.h"

#include "parser.tab.h"
#include "lex.yy.h"


int main(int argc, char* argv[]) {
  FILE* test_file = fopen("./test/test.saml", "r");
  assert(test_file != NULL);

  yyscan_t scanner;
  yylex_init(&scanner);
  yyset_in(test_file, scanner);
  yyparse(scanner);
  yylex_destroy(scanner);

  return 0;
}

void yyerror(yyscan_t scanner, const char* message) {
  log_error("Parse error: %s\n", message);
}