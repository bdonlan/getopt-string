use Test::More tests => 17;

BEGIN { use_ok('Getopt::String::Tokenizer', 'get_token'); }

my ($token, $remain);
## Basic usage
($token, $remain) = get_token("foo bar", {});
is($token, "foo", "basic usage");
is($remain, " bar", "basic usage");

## Last token (and leading whitespace)
($token, $remain) = get_token(" bar", {});
is($token, "bar", "last token");
is($remain, "", "last token");

## End of string handling
($token, $remain) = get_token("", {});
is($token, undef, "end of string");
is($remain, undef, "end of string");

## Unregistered escapes
($token, $remain) = get_token('foo\ bar baz', {});
is($token, 'foo bar', 'unregistered escapes');
is($remain, ' baz', 'unregistered escapes');

## Registered escapes
my $esc = { 'n' => "\n", 't' => "\t" };
($token, $remain) = get_token("\\n\\t\\ foo\\e\\\\bar baz", $esc);
is($token, "\n\t fooe\\bar", "registered escapes");
is($remain, " baz", "registered escapes");

## Single quotes
($token, $remain) = get_token("foo'this is a single quoted string with escapes\\'bar baz", {});
is($token, "foothis is a single quoted string with escapes\\bar", "single quotes");
is($remain, " baz", "single quotes");

## Double quotes with escapes
($token, $remain) = get_token(qq{foo"dquote\\"dquote\\n"bar baz}, $esc);
is($token, qq{foodquote"dquote\nbar}, "double quotes");
is($remain, qq{ baz}, "double quotes");

## Iteration
my $tstr = qq{a\\ "b\\nc"'d e f'g"h i j"'k\\l'm n o p};
($token, $remain) = get_token($tstr, $esc);
is($token, qq{a b\ncd e fgh i jk\\lm}, "iteration");
is($remain, qq{ n o p}, "iteration");
