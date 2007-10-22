# $Id: bad-single-word-compiler.t,v 1.1 2007/10/22 22:23:34 drhyde Exp $

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


$Config{cc} = 'flibbertigibbet';
eval "use Devel::CheckLib";
ok($@ =~ /^Couldn't find your C compiler/, "Bad multi-word compiler is not OK");
