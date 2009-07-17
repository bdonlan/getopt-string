#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <parseopt.h>

#include "const-c.inc"

MODULE = Getopt::String		PACKAGE = Getopt::String		PREFIX = parseopt_

PROTOTYPES: ENABLE
INCLUDE: const-xs.inc


