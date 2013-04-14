#ABSTRACT: List supported file formats
package MARC::Shell::Command::formats;
use strict;
use warnings;
use Moo::Role;
use Say::Compat;

sub summary { 'List supported file formats' }

sub help {
    <<'END';
List supported file formats.

formats 
END
}

sub run {
    #my $self=shift;
    say "File formats currently supported";
    foreach (keys %INC) {
        print $_ if $_=~/MARC\/File/;
    }
    
    say "USMARC";
    say "MARCMaker";
    say "MicroLIF";
}

1;
