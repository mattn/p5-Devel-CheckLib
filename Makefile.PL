# $Id: Makefile.PL,v 1.3 2007/10/18 21:21:02 drhyde Exp $

use ExtUtils::MakeMaker;

use strict;
$^W = 1;

WriteMakefile(
    NAME         => 'Devel::CheckLib',
    VERSION_FROM => 'lib/Devel/CheckLib.pm',
    PREREQ_PM    => {
        'Test::More'       => 0.62,  # too high? but API changed here
        'File::Temp'       => 0.16,
    },
    EXE_FILES    => [qw(
        bin/use-devel-checklib
    )],
);
