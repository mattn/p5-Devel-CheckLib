# $Id: Makefile.PL,v 1.6 2008/03/04 21:49:19 drhyde Exp $

use ExtUtils::MakeMaker;

use strict;
$^W = 1;

WriteMakefile(
    NAME         => 'Devel::CheckLib',
    VERSION_FROM => 'lib/Devel/CheckLib.pm',
    PREREQ_PM    => {
        'Test::More'        => 0.62,  # too high? but API changed here
        'File::Temp'        => 0.16,
        'IO::CaptureOutput' => 1.0801
    },
    EXE_FILES    => [qw(
        bin/use-devel-checklib
    )],
);
