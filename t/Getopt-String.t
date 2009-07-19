# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Getopt-String.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { use_ok('Getopt::String', ':all') };


my $fail = 0;
foreach my $constname (qw(
	PARSEOPT_EATARG PARSEOPT_NOARG PARSEOPT_STOP)) {
  next if (eval "my \$a = $constname; 1");
  if ($@ =~ /^Your vendor has not defined Getopt::String macro $constname/) {
    print "# pass: $@";
  } else {
    print "# fail: $@";
    $fail = 1;
  }

}

ok( $fail == 0 , 'Constants' );
#########################

use Data::Dumper;
my $c;
my $name;
my $age;
my $rest = Getopt::String::parse(
    "--name=bob -cfoo --age 10 I like cheese",
    {
        shortopt => sub {
            my ($opt, $val) = @_;
            if ($opt eq 'c') {
                $c = $val;
                return PARSEOPT_EATARG;
            }
            else {
                return PARSEOPT_NOARG;
            }
        },
        longopt => sub {
            my ($opt, $val) = @_;
            if ($opt eq 'name') {
                $name = $val;
                return PARSEOPT_EATARG;
            }
            elsif ($opt eq 'age') {
                $age = $val;
                return PARSEOPT_EATARG;
            }
            else {
                return PARSEOPT_NOARG;
            }
        },
        literalopt => sub {
            my ($val) = @_;
            return PARSEOPT_STOP;
        },
    }
);

is($name, 'bob');
is($c, 'foo');
is($age, '10');

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.


