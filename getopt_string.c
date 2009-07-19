#include "parseopt.h"

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

static ParseOptStatus call_handler(HV *handlers, char *name, SV *option, SV *argument)/*{{{*/
{
	SV **handler = hv_fetch(handlers, name, strlen(name), 0);
	ParseOptStatus status;

	if (handler != NULL) {
		int count;
		int rv;
		dSP;
		ENTER;
		SAVETMPS;

		PUSHMARK(SP);
		if (option) PUSHs(option);
		if (argument) PUSHs(argument);
		PUTBACK;

		count = call_sv(*handler, G_SCALAR);
		if (count != 1)
			Perl_croak(aTHX_ "should not happen");
		SPAGAIN;

		rv = POPi;
		switch (rv) {
			case PARSEOPT_NOARG:
			case PARSEOPT_EATARG:
			case PARSEOPT_STOP:
				break;
			default:
				Perl_croak(aTHX_ "Invalid return value: %d", rv);
				break;
		}

		PUTBACK;
		FREETMPS;
		LEAVE;

		return rv;
	}
	return PARSEOPT_STOP; // stop if there's no handler.
}/*}}}*/

ParseOptStatus getopt_string_shortopt_handler(void *baton, const char opt, const char *argument, const char *start)
{
	return call_handler((HV *)baton, "shortopt", sv_2mortal(newSVpvf("%c", opt)), sv_2mortal(newSVpvf("%s", argument)));
}

ParseOptStatus getopt_string_longopt_handler(void *baton, const char *opt, const char *argument, const char *start)
{
	return call_handler((HV *)baton, "longopt", sv_2mortal(newSVpvf("%s", opt)), sv_2mortal(newSVpvf("%s", argument)));
}

ParseOptStatus getopt_string_literalopt_handler(void *baton, const char *literal, const char *start)
{
	ParseOptStatus status = call_handler((HV *)baton, "literalopt", sv_2mortal(newSVpvf("%s", literal)), NULL);
	if (status == PARSEOPT_NOARG)
		Perl_croak(aTHX_ "literalopt must never return PARSEOPT_NOARG!");
	return status;
}

