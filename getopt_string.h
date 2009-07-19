#include "parseopt.h"

ParseOptStatus getopt_string_shortopt_handler(void *baton, const char opt, const char *argument, const char *start);
ParseOptStatus getopt_string_longopt_handler(void *baton, const char *opt, const char *argument, const char *start);
ParseOptStatus getopt_string_literalopt_handler(void *baton, const char *literal, const char *start);

