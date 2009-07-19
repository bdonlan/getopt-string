package Getopt::String::Tokenizer;

use strict;
use warnings;

require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/get_token/;

## Precompiled regex fragments
my $dquote_contents = qr/ (?: \\ (.) | [^\"] ) */x;
our $raw_contents = qr/ [^'"\s\\] | \\. /x;

sub get_token {
	my ($string, $escapes) = @_;

	# Remove leading whitespace
	$string =~ s/^\s*//;

	# Perform escape substitution and strip quotes. Oh, and figure out how
	# long our token is, too.
	#
	# This is made a bit tricky by the fact that we need to prevent parsing
	# of single quotes within dquotes, so we need to loop a bit.
	my $pptoken = "";

	while ($string =~ s{
			## Always start at the beginning of the string
			^
			## Grab a segment of string to process
			## We need to escape-process raw text plus a possible dquote
			## These go into $1 and $2 (may be undef)
			## 
			## Note that raw text must not contain our quotation characters
			## or whitespace, as these are treated specially.
			( $raw_contents *) (?: " ($dquote_contents) " )?
			## Also, we may have a single-quoted string.
			## This goes into $4 and is not escaped.
			## What happened to $3, you ask? Beats me. :|
			(?: ' ([^']*) ' )?
			## Make sure we matched at least one character with a lookbehind
			(?<= .)
		}{}x)
	{
		my ($raw, $dquote, $squote) = ($1, $2, $4);
		my $escapable = $raw . ($dquote || "");

		$escapable =~ s/\\(.)/$escapes->{$1} || $1/ge;

		$pptoken .= $escapable;
		$pptoken .= $squote if $squote;
	}

	## Return emptyhanded if we don't have anything...
	return undef if $pptoken eq '';

	## Token in $ret[0], remainder in $ret[1]
	return ($pptoken, $string);
}

1;
