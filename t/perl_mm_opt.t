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
    plan tests => 2;
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
local $ENV{PERL_MM_OPT} = $runtime;

my $rval = undef;
capture(
    sub { $rval = system(
        $Config{perlpath},
	'-Mblib',
	'-MDevel::CheckLib',
	'-e',
	"print @ARGV;assert_lib(debug => $debug)")},
    \$stdout,
    \$stderr
);
ok($stderr eq '' && defined($rval) && $rval == 0, "linked OK: ".$ENV{PERL_MM_OPT}) || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");

$rval = undef;
local $ENV{PERL_MM_OPT} = "$runtime -lbazbam -L$libdir";
capture(
    sub { $rval = system(
        $Config{perlpath},
	'-Mblib',
	'-MDevel::CheckLib',
	'-e',
	"print @ARGV;assert_lib(debug => $debug)")},
    \$stdout,
    \$stderr
);
ok($stderr eq '' && defined($rval) && $rval == 0, "linked OK: ".$ENV{PERL_MM_OPT}) || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");
