use strict;
# compatible use warnings
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use lib 't/lib';
use IO::CaptureOutput qw(capture);
use Config;

use File::Spec;
use Test::More;

my($debug, $stdout, $stderr) = ($ENV{DEVEL_CHECKLIB_DEBUG} || 0);
my $libdir;

eval "use Devel::CheckLib";
if($@ =~ /Couldn't find your C compiler/) { #'
    plan skip_all => "Couldn't find your C compiler";
}

eval "use Helper qw(create_testlib)";
if($libdir = create_testlib("bazbam")) {
    plan tests => 1;
} else {
    plan skip_all => "Couldn't build a library to test against";
};

my $runtime = '-l'.(
    $^O eq 'MSWin32'                       # if Win32 (not Cygwin) ...
        ? (
            $Config{cc} =~ /(^|^\w+ )bcc/
                ? 'cc3250'                 # ... Borland
                : 'msvcrt'                 # ... otherwise assume Microsoft
          )
        : 'm'                              # default to Unix-style
);

my @args = (qq{LIBS=$runtime});
capture(
    sub { system(
        $Config{perlpath},
	'-Mblib',
	'-MDevel::CheckLib',
	'-e',
	"print @ARGV;assert_lib(debug => $debug)",
        @args
    )},
    \$stdout,
    \$stderr
);
is($stderr, q{}, join(', ', @args)) || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");

@args = map { "LIBS=$_" } ($runtime, '-lbazbam', "-L$libdir");
capture(
    sub { system(
        $Config{perlpath},
	'-Mblib',
	'-MDevel::CheckLib',
	'-e',
	"print @ARGV;assert_lib(debug => $debug)",
        @args
    )},
    \$stdout,
    \$stderr
);
is($stderr, q{}, join(', ', @args)) || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");

@args = (qq{LIBS="$runtime -lbazbam -L$libdir"});
capture(
    sub { system(
        $Config{perlpath},
	'-Mblib',
	'-MDevel::CheckLib',
	'-e',
	"print @ARGV;assert_lib(debug => $debug)",
        @args
    )},
    \$stdout,
    \$stderr
);
is($stderr, q{}, join(', ', @args)) || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");
