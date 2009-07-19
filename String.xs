#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <parseopt.h>
#include "getopt_string.h"
#include "const-c.inc"

MODULE = Getopt::String		PACKAGE = Getopt::String		PREFIX = parseopt_

PROTOTYPES: ENABLE
INCLUDE: const-xs.inc

const char *
parseopt_parse(argstr, handlers)
	const char *argstr
	HV *handlers
	INIT:
		ParseOptCallbacks cb;
		cb.shortopt   = getopt_string_shortopt_handler;
		cb.longopt    = getopt_string_longopt_handler;
		cb.literalopt = getopt_string_literalopt_handler;
	CODE:
		RETVAL = parseopt_parse((void *)handlers,  argstr, &cb);
	OUTPUT: RETVAL
