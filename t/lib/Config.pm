# This fakes up the system-side Config.pm, only substituting some
# different information for $Config{cc}.

package Config;

use Tie::Hash;
@ISA = qw(Tie::Hash);

local %INC = %INC; delete $INC{'Config.pm'};
local @INC = grep { $_ !~ /^t\/lib$/ } @INC;

eval '
    package FakeConfig;
    require Config;
    Config->import();
';

tie my %hash, 'FakeConfig';

sub import {
    my $callpkg = caller(0);
    *{"$callpkg\::Config"} = \%hash;
    return;
}

package FakeConfig;

sub TIEHASH {
    print "Tied - $Config{cc}\n";
    my $foo = '';
    return bless \$foo, 'FakeConfig';
}

sub FETCH {
    my($self, $key) = @_;
    print "Called FETCH\n";
    if($key eq 'cc') { return 't/bin/passthrough '.$Config{$key} }
     else { return $Config{$key} }
}

1;
