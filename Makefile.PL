# $Id: Makefile.PL,v 1.1 2007/10/18 17:41:02 drhyde Exp $

use ExtUtils::MakeMaker;

use strict;
$^W = 1;

WriteMakefile(
    NAME         => 'Devel::CheckLib',
    VERSION_FROM => 'lib/Devel/CheckLib.pm',
    PREREQ_PM    => {
        'Test::More'       => 0.62,  # too high? but API changed here
        'File::Temp'       => 0.18,
    },
);
