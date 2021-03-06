#include <stdio.h>
#include <assert.h>

#include "log.h"
#include "scanner.h"

#include "parser.tab.h"
#include "lex.yy.h"

int main(int argc, char *argv[])
{
  //
  // Load our test file relatively to the root of the project
  // make sure to run `./build/a.out` at the root!
  //
  FILE *test_file = fopen("./test/test.saml", "r");
  assert(test_file != NULL);

  //
  // Use our scanner and parser without globals, notice how we allocate a yyscan_t
  // onto the stack to store our state! This allows us to parse files not only
  // concurrently but also thread-safely.
  //
  yyscan_t scanner;
  saml_scanner saml = {
    .pos = {
      .line = 0,
      .col = 0
    }
  };

  yylex_init(&scanner);
  yyset_in(test_file, scanner);
  yyparse(scanner, &saml);
  yylex_destroy(scanner);

  printf("Scanner found %d\n", saml.pos.col);

  return 0;
}

/**
 * @brief The bison error formatting method we externally defined in the parser generator
 * 
 * @param scanner 
 * @param message 
 */
void yyerror(yyscan_t scanner, saml_scanner* saml, const char *message)
{
  log_error("Parse error: %s\n", message);
}