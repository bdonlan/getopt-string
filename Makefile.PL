use 5.010000;
use strict;
use warnings;

use ExtUtils::MakeMaker;
use ExtUtils::PkgConfig;

my %glib = ExtUtils::PkgConfig->find('glib-2.0');

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME          => 'Getopt::String',
    VERSION_FROM  => 'lib/Getopt/String.pm',                         # finds $VERSION
    PREREQ_PM     => {},                                             # e.g., Module::Name => 1.1
    ABSTRACT_FROM => 'lib/Getopt/String.pm',                         # retrieve abstract from module
    AUTHOR        => 'Dylan William Hardison <dylan@>',
    DEFINE        => '',                                             # e.g., '-DHAVE_SOMETHING'
    LIBS          => [split(/\s+/, $glib{libs})],
    INC           => '-I.',           # e.g., '-I. -I/usr/include/other'
    CCFLAGS       => "-std=gnu99 $glib{cflags}",
    OBJECT        => 'String.o parseopt.o',    # link all the C files too
);
if ( eval { require ExtUtils::Constant; 1 } ) {

    # If you edit these definitions to change the constants used by this module,
    # you will need to use the generated const-c.inc and const-xs.inc
    # files to replace their "fallback" counterparts before distributing your
    # changes.
    my @names = (
        { name => "PARSEOPT_EATARG", macro => "1" },
        { name => "PARSEOPT_NOARG",  macro => "1" },
        { name => "PARSEOPT_STOP",   macro => "1" }
    );
    ExtUtils::Constant::WriteConstants(
        NAME         => 'Getopt::String',
        NAMES        => \@names,
        DEFAULT_TYPE => 'IV',
        C_FILE       => 'const-c.inc',
        XS_FILE      => 'const-xs.inc',
    );

}
else {
    use File::Copy;
    use File::Spec;
    foreach my $file ( 'const-c.inc', 'const-xs.inc' ) {
        my $fallback = File::Spec->catfile( 'fallback', $file );
        copy( $fallback, $file ) or die "Can't copy $fallback to $file: $!";
    }
}
