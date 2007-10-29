use strict;
# compatible use warnings
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use lib 't/lib';
use IO::CaptureOutput qw(capture);

use File::Spec;
use Test::More;

eval "use Devel::CheckLib";
if($@ =~ /Couldn't find your C compiler/) {
    plan skip_all => "Couldn't find your C compiler";
} else {
    eval "use Helper qw/create_testlib/";
}

my($debug, $stdout, $stderr) = ($ENV{DEVEL_CHECKLIB_DEBUG} || 0);

# compile a test library
my $libdir = create_testlib("bazbam");

my @lib = (
    $^O eq 'MSWin32' ? 'msvcrt' : 'm',
    $^O eq 'MSWin32' ? 'kernel32' : 'c',
);

# cases are strings to interpolate into the assert_lib call
my @cases = (
    qq/lib => '$lib[0]'/,
    qq/lib => '$lib[1]'/,
    qq/lib => ['$lib[0]', '$lib[1]']/,
);

push @cases, qq{lib => 'bazbam', libpath => '$libdir'} if $libdir;

plan tests => scalar @cases;


for my $c ( @cases ) {
    capture(
        sub { eval "assert_lib(debug => $debug, $c)"; },
        \$stdout,
        \$stderr
    );
    is($@, q{}, "$c") || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");
}
