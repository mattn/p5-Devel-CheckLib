# $Id: multi-word-compiler.t,v 1.3 2008/02/07 14:16:39 drhyde Exp $

use strict;
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }

use Test::More;

plan tests => 1;

use Config;
BEGIN {
    BEGIN { if (not $] < 5.006 ) { warnings->unimport('redefine') } }
    unless(defined($ActivePerl::VERSION) && $Config{cc} =~ /\bgcc\b/) {
      *Config::STORE = sub { $_[0]->{$_[1]} = $_[2] }
    }
}

if(defined($ActivePerl::VERSION) && $Config{cc} =~ /\bgcc\b/) {
   my $obj = tied %Config::Config;
   $obj->{cc} = "$^X $Config{cc}";
}
else {
  $Config{cc} = "$^X $Config{cc}";
}

eval { $Config{cc} = "$^X $Config{cc}" };
SKIP: {
    skip "Couldn't update %Config", 1 if $@ =~ /%Config::Config is read-only/;
    eval "use Devel::CheckLib";
    ok(!$@, "Good multi-word compiler is OK");
}
