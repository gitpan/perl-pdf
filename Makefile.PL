# -*- mode: Perl -*-

use ExtUtils::MakeMaker;

WriteMakefile(NAME         => "PDF::Create",
              VERSION_FROM => "lib/PDF/Create.pm",
	      DISTVNAME	   => "perl-pdf-0.06.1b-SREZIC",
              dist         => { COMPRESS => "gzip", SUFFIX => "gz" },
              clean        => { FILES => '*.bak *.old mibs/*.dump ' .
                                         'lib/*/*~ lib/*/*/*~' },
              # EXE_FILES  => [ qw() ],
);
