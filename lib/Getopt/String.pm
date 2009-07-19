package Getopt::String;
use 5.010000;
use strict;
use warnings;
use Carp;
use XSLoader;

use Sub::Exporter -setup => {
    exports => [qw( PARSEOPT_EATARG PARSEOPT_NOARG PARSEOPT_STOP )],
};

our $VERSION = '0.01';

XSLoader::load('Getopt::String', $VERSION);

*PARSEOPT_EATARG = value('PARSEOPT_EATARG');
*PARSEOPT_NOARG  = value('PARSEOPT_NOARG');
*PARSEOPT_STOP   = value('PARSEOPT_STOP');

sub value {
    my $name = shift;
    my ($error, $val) = constant($name);
    croak $error if $error;
    return sub () { $val };
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
