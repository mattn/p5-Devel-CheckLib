# $Id: multi-word-compiler.t,v 1.1 2007/10/22 22:23:34 drhyde Exp $

use strict;

use Test::More;
use File::Temp;

plan tests => 1;

use Config;
*Config::STORE = sub { $_[0]->{$_[1]} = $_[2] };

$Config{cc} = "$^X $Config{cc}";
eval "use Devel::CheckLib";
ok(!$@, "Good multi-word compiler is OK");
