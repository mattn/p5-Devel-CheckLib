use strict;
# compatible use warnings
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use lib 't/lib';
use IO::CaptureOutput qw(capture);
use Config;

use File::Spec;
use Test::More;

eval "use Devel::CheckLib";
if($@ =~ /Couldn't find your C compiler/) {
    plan skip_all => "Couldn't find your C compiler";
}

my($debug, $stdout, $stderr) = ($ENV{DEVEL_CHECKLIB_DEBUG} || 0);

# cases are strings to interpolate into the assert_lib call
my @failcases = (
    qq{                 header => 'headerfile.h'}, # no such file
    qq{INC => '-t/inc', header => 'headerfile.h'}  # bad syntax
);
my @passcases = (
    qq{                    header => 't/inc/headerfile.h'},
    qq{incpath => 't/inc', header => 'headerfile.h'},
    qq{INC => '-It/inc',   header => 'headerfile.h'}
);

plan tests => scalar(@failcases) + scalar(@passcases);

for my $c (@failcases) {
    capture(
        sub { eval "assert_lib(debug => $debug, $c)"; },
        \$stdout,
        \$stderr
    );
    ok($@, "$c") || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");
}
for my $c ( @passcases ) {
    capture(
        sub { eval "assert_lib(debug => $debug, $c)"; },
        \$stdout,
        \$stderr
    );
    is($@, q{}, "$c") || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");
}
