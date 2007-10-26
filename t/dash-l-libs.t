use strict;
# compatible use warnings
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use lib 't/lib';
use IO::CaptureOutput qw(capture);
use Helper qw/create_testlib/;

use File::Spec;
use Test::More;

use Devel::CheckLib;

my($debug, $stdout, $stderr) = ($ENV{DEVEL_CHECKLIB_DEBUG} || 0);
my $libdir;
if($libdir = create_testlib("bazbam")) {
    plan tests => 1;
} else {
    plan skip_all => "Couldn't build a library to test against";
};

my $runtime = $^O eq 'MSWin32' ? '-lmsvcrt' : '-lm';
my $args = qq{LIBS => '$runtime -lbazbam -L$libdir'};

capture(
    sub { eval "assert_lib(debug => $debug, $args)"; },
    \$stdout,
    \$stderr
);
is($@, q{}, "$args") || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");
