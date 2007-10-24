# $Id: Makefile.PL,v 1.5 2007/10/24 14:44:23 drhyde Exp $

use ExtUtils::MakeMaker;

use strict;
$^W = 1;

WriteMakefile(
    NAME         => 'Devel::CheckLib',
    VERSION_FROM => 'lib/Devel/CheckLib.pm',
    PREREQ_PM    => {
        'Test::More'        => 0.62,  # too high? but API changed here
        'File::Temp'        => 0.16,
        # 'IO::CaptureOutput' => 1.04   # doesn't exist yet :-)
    },
    EXE_FILES    => [qw(
        bin/use-devel-checklib
    )],
);
