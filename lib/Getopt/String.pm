package Getopt::String;
use 5.010000;
use strict;
use warnings;
use Carp;
use XSLoader;

our $VERSION = '0.01';

use Sub::Exporter -setup => {
	exports => [qw( NO_ARG REQUIRED_ARG OPTIONAL_ARG )]
};

## These are opaque references to prevent confusion with aliases
## Note that this means we must use 'eq' instead of == for comparisons!
use constant {
	NO_ARG => \"NO_ARG",
	REQUIRED_ARG => \"REQUIRED_ARG",
	OPTIONAL_ARG => \"OPTIONAL_ARG"
};

use Moose;
use Getopt::String::Tokenizer qw/get_token/;

has '_string' => (is => 'rw', isa => 'Str', required => 1);
has 'escapes' => (is => 'rw', isa => 'HashRef[Str]',
	default => sub { { 'n' => "\n",
				       'r' => "\r",
				       't' => "\t"
			       } }
	);
has '_args' => (is => 'ro', isa => 'HashRef', required => 1);
has 'croak_on_malformed' => (is => 'ro', isa => 'Bool', default => 0);

sub BUILDARGS {
	my ($self, $str, $args, @opts) = @_;
	return { _string => $str, _args => $args, @opts };
}

sub remain {
	my ($self) = @_;
	return $self->_string;
}

sub next {
	my ($self) = @_;

	my ($token, $remain) = get_token($self->_string, $self->escapes);
	
	return (undef, undef) unless defined $token;

	my ($opt, $arg);
	if ($token =~ m{^--([^=]*)(?:=(.+))?$}s) {
		($opt, $arg) = ($1, $2);
	} elsif ($token =~ m{^-(.)(?:(.+))?$}s) {
		($opt, $arg) = ($1, $2);
	} else {
		$self->_string($remain);
		return (undef, $token);
	}

	my $argmode = $opt;

	while (defined $argmode && !ref $argmode) {
		## resolve an argument alias
		$opt = $argmode;
		$argmode = $self->_args->{$opt};
	}
	$argmode = NO_ARG unless defined $argmode;

	if (defined $arg) {
		if ($self->croak_on_malformed && $argmode eq NO_ARG) {
			croak "Unexpected argument for option '$opt'";
		}
	} elsif ($argmode ne NO_ARG) {
		## We don't have an inline argument (as in --foo=bar or -xfoo)
		## but we may have another token we can consume for an argument...
		my ($token2, $remain2) = get_token($remain, $self->escapes);

		## Don't consume arguments that look like options;
		## the user can use inline args if that's desired
		if (defined $token2 && !($token2 =~ m{^-})) {
			$arg = $token2;
			$remain = $remain2;
		}

		if ($self->croak_on_malformed && $argmode eq REQUIRED_ARG) {
			croak "Missing mandatory argument for option '$opt'";
		}
	}

	$self->_string($remain);
	return ($opt, $arg);
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Getopt::String - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Getopt::String;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Getopt::String, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.

=head2 Exportable constants

  PARSEOPT_EATARG
  PARSEOPT_H
  PARSEOPT_NOARG
  PARSEOPT_STOP



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Dylan William Hardison, E<lt>dylan@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Dylan William Hardison

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.
