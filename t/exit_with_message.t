use strict;
# compatible use warnings
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use Test::More;
use File::Temp;

plan tests => 1;

my $fh = File::Temp->new();
print {$fh} << 'ENDPRINT';
use Devel::CheckLib;
check_lib_or_exit( qw/lib hlagh/ );
ENDPRINT
$fh->close;

my $err = `$^X $fh 2>&1`;

like ($err, "/^Can't build and link to 'hlagh'/ms", 
    "missing hlagh detected non-fatally"
);
