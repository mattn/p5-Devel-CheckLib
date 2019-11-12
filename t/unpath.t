use strict;
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use lib 't/lib';
use Capture::Tiny qw(capture);
use Test::More;

my $debug = $ENV{DEVEL_CHECKLIB_DEBUG} || 0;

eval "use Devel::CheckLib";
if($@ =~ /Couldn't find your C compiler/) { #'
    plan skip_all => "Couldn't find your C compiler";
}

my $set_rpath = shift;

my $path = "/usr/local/libssh2";
my $incpath = "$path/include";
my $libpath = "$path/lib";
my @rpath = ($set_rpath ? (ldflags => "-Wl,-rpath=$libpath") : ());

my ($stdout, $stderr) = capture { eval {
    assert_lib(debug => $debug,
           header => 'libssh2.h',
           lib => 'ssh2',
           incpath => $incpath,
           libpath => $libpath,
           @rpath,
           function => 'libssh2_init(0); return 0;') }
};
ok($stderr eq '' || $stderr !~ /^No such file or directory/, "linked OK") || diag("\tSTDOUT: $stdout\n\tSTDERR: $stderr\n");

done_testing;
