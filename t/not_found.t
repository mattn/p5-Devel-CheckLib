use strict;
# compatible use warnings
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use Test::More;
my $debug = 0;

use Devel::CheckLib;

my @lib = (
    $^O eq 'MSWin32' ? 'msvcrt' : 'm',
    $^O eq 'MSWin32' ? 'kernel32' : 'c',
);

# Cases are AoH: { arg => $string, missing => $string }
my @cases = (
    { arg => qq{lib => 'foo'},              missing => ['foo'] },
    { arg => qq{lib => [qw/$lib[1] foo/]},  missing => ['foo'] },
    { arg => qq{lib => [qw/foo $lib[1]/]},  missing => ['foo'] },
    { arg => qq{lib => [qw/foo bar/]},      missing => [qw/foo bar/] },
);

plan tests => 2 * @cases;

for my $c ( @cases ) {
    eval "assert_lib(debug => $debug, $c->{arg})";
    my $err = $@;
    ok ( $err, "died on '$c->{arg}'" );
    my $miss_string = join(q{, }, map { qq{'$_'} } @{$c->{missing}} );
    like ($err, "/^Can't build and link to ${miss_string}/ms", 
        "missing $miss_string detected"
    );
}
