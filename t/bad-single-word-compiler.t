# $Id: bad-single-word-compiler.t,v 1.2 2008/02/07 14:16:39 drhyde Exp $

use strict;
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use Test::More;

plan tests => 1;

use Config;
BEGIN {
    BEGIN { if (not $] < 5.006 ) { warnings->unimport('redefine') } }
    *Config::STORE = sub { $_[0]->{$_[1]} = $_[2] } unless *Config::STORE
}


eval { $Config{cc} = 'flibbertigibbet' };
SKIP: {
    skip "Couldn't update %Config", 1 if $@ =~ /%Config::Config is read-only/;
    eval "use Devel::CheckLib";
    ok($@ =~ /^Couldn't find your C compiler/, "Bad multi-word compiler is not OK");
}
