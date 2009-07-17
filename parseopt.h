#ifndef PARSEOPT_H
#define PARSEOPT_H 1

typedef enum {
	PARSEOPT_STOP,
	PARSEOPT_NOARG,
	PARSEOPT_EATARG
} ParseOptStatus;

/* General notes:
 *
 * argument, literal, and opt (in the case of longopt()) are owned by the caller. You
 * must strdup() them if you wish to work with them.
 *
 * start is the beginning of the option's token. Note with short arguments, this points
 * to the '-' at the start. Also, this will be a pointer directly into the string you
 * gave it, so it's valid after calling PARSEOPT_STOP.
 *
 * cb->literalopt() must never return PARSEOPT_NOARG.
 *
 * argument may also be NULL at the end of the string.
 *
 * The return value of parseopt is a pointer to the start of the token you returned
 * PARSEOPT_STOP from; or a pointer to the end of the passed string if you let it run
 * to the end.
 */
typedef struct {
	ParseOptStatus (*shortopt)(void *baton, const char opt, const char *argument, const char *start);
	ParseOptStatus (*longopt)(void *baton, const char *opt, const char *argument, const char *start);
	ParseOptStatus (*literalopt)(void *baton, const char *literal, const char *start);
} ParseOptCallbacks;

const char *parseopt_parse(void *baton, const char *argstr, const ParseOptCallbacks *cb);

#endif
