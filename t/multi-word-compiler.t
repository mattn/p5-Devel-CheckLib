# $Id: multi-word-compiler.t,v 1.2 2007/10/23 13:17:12 drhyde Exp $

use strict;
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use Test::More;
use File::Temp;

plan tests => 1;

use Config;
BEGIN {
    BEGIN { if (not $] < 5.006 ) { warnings->unimport('redefine') } }
    *Config::STORE = sub { $_[0]->{$_[1]} = $_[2] }
}

$Config{cc} = "$^X $Config{cc}";
eval "use Devel::CheckLib";
ok(!$@, "Good multi-word compiler is OK");
