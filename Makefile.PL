# $Id: Makefile.PL,v 1.4 2007/10/23 13:53:28 drhyde Exp $

use ExtUtils::MakeMaker;

use strict;
$^W = 1;

WriteMakefile(
    NAME         => 'Devel::CheckLib',
    VERSION_FROM => 'lib/Devel/CheckLib.pm',
    PREREQ_PM    => {
        'Test::More'        => 0.62,  # too high? but API changed here
        'File::Temp'        => 0.16,
        'IO::CaptureOutput' => 1.04   # doesn't exist yet :-)
    },
    EXE_FILES    => [qw(
        bin/use-devel-checklib
    )],
);
