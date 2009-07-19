use Test::More tests => 32;

BEGIN { use_ok('Getopt::String', ":all"); }

$getopt = new Getopt::String("--help foo --output=xyz --input bar --arg baz --arg --arg=quux --arg",
	{ help => NO_ARG, output => REQUIRED_ARG, input => REQUIRED_ARG,
	  arg => OPTIONAL_ARG
	});

is_deeply([$getopt->next], ["help", undef], "no-arg returned");
is_deeply([$getopt->next], [undef, "foo"], "literal isn't consumed");
is_deeply([$getopt->next], ["output", "xyz"], "explicit argument");
is_deeply([$getopt->next], ["input", "bar"], "implicit argument");
is_deeply([$getopt->next], ["arg", "baz"], "optional argument, implicit");
is_deeply([$getopt->next], ["arg", undef], "optional argument, suppressed by following");
is_deeply([$getopt->next], ["arg", "quux"], "optional argument, explicit");
is_deeply([$getopt->next], ["arg", undef], "optional argument, suppressed by end-of-string");
is_deeply([$getopt->next], [undef, undef], "end of string");

$getopt = new Getopt::String("-a -b --cee --dee",
	{ 'a' => 'b', 'b' => 'cee', 'cee' => 'dee', 'dee' => NO_ARG });
is_deeply([$getopt->next], ["dee", undef], "argument aliases");
is_deeply([$getopt->next], ["dee", undef], "argument aliases");
is($getopt->remain, " --cee --dee", "getopt->remain");
is_deeply([$getopt->next], ["dee", undef], "argument aliases");
is_deeply([$getopt->next], ["dee", undef], "argument aliases");
is_deeply([$getopt->next], [undef, undef], "argument aliases");

$getopt = new Getopt::String("-a foo -b bar", { a => 'b', b => REQUIRED_ARG });
is_deeply([$getopt->next], ["b", "foo"], "aliases respect root's mode");
is_deeply([$getopt->next], ["b", "bar"], "aliases respect root's mode");

$getopt = new Getopt::String(qq{--foo="bar baz quux" blah}, {foo => OPTIONAL_ARG});
is_deeply([$getopt->next], ["foo", "bar baz quux"], "quoted strings seem to work");
is_deeply([$getopt->next], [undef, "blah"], "end-of-string");

$getopt = new Getopt::String(qq{--foo=\\n"bar\\n\\"baz quux" blah}, {foo => OPTIONAL_ARG});
is_deeply([$getopt->next], ["foo", "\nbar\n\"baz quux"], "escapes");
is_deeply([$getopt->next], [undef, "blah"], "escapes");

$getopt = new Getopt::String(qq{--foo='bar\\' --baz='quux\\'},
	{ foo => OPTIONAL_ARG, baz => OPTIONAL_ARG });
is_deeply([$getopt->next], ['foo', "bar\\"], "single quoted strings");
is_deeply([$getopt->next], ['baz', "quux\\"], "single quoted strings");

eval {
	$getopt = new Getopt::String("--foo", {foo => REQUIRED_ARG}, croak_on_malformed => 1);
	$getopt->next;
};
ok($@ && $@ =~ m{Missing mandatory argument for option 'foo'}, "croak on missing arguments");

eval {
	$getopt = new Getopt::String("--foo=bar", {foo => NO_ARG}, croak_on_malformed => 1);
	$getopt->next;
};
ok($@ && $@ =~ m{Unexpected argument for option 'foo'}, "croak on excess arguments");

eval {
	$getopt = new Getopt::String("--foo --bar=baz", {foo => REQUIRED_ARG});
	is_deeply([$getopt->next], ['foo', undef], "don't croak when not requested");
	is_deeply([$getopt->next], ['bar', 'baz'], "don't croak when not requested");
};
ok(!$@, "don't croak when not requested");

eval {
	$getopt = new Getopt::String("--foo --bar=baz", {foo => OPTIONAL_ARG, bar => OPTIONAL_ARG}, croak_on_malformed => 1);
	is_deeply([$getopt->next], ["foo", undef], "optional args don't croak");
	is_deeply([$getopt->next], ["bar", "baz"], "optional args don't croak");
};
ok(!$@, "optional args don't croak");
