use Test::More qw(no_plan); # tests => 17;

BEGIN { use_ok('Getopt::String', ":all"); }

sub is_args {
	my ($ret_opt, $ret_arg, $expect_opt, $expect_arg, $testname) = @_;
	is($ret_opt, $expect_opt, $testname . " (option return)");
	is($ret_arg, $expect_arg, $testname . " (argument return)");
}

$getopt = new Getopt::String("--help foo --output=xyz --input bar --arg baz --arg --arg=quux --arg",
	{ help => NO_ARG, output => REQUIRED_ARG, input => REQUIRED_ARG,
	  arg => OPTIONAL_ARG
	});
is_args($getopt->next, "help", undef, "no-arg returned");
is_args($getopt->next, undef, "foo", "literal isn't consumed");
is_args($getopt->next, "output", "xyz", "explicit argument");
is_args($getopt->next, "input", "bar", "implicit argument");
is_args($getopt->next, "arg", "baz", "optional argument, implicit");
is_args($getopt->next, "arg", undef, "optional argument, suppressed by following");
is_args($getopt->next, "arg", "quux", "optional argument, explicit");
is_args($getopt->next, "arg", undef, "optional argument, suppressed by end-of-string");
is_args($getopt->next, undef, undef, "end of string");
