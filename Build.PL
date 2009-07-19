#!/usr/bin/perl
use Module::Build;
use strict;
use warnings;

my $build = Module::Build->new(
	module_name => 'Getopt::String',
	license => 'perl',
	requires => { 'Moose', '0.62', 'Test::More', 0 },
);

$build->create_build_script;

