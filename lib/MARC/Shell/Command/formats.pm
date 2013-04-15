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
    my $self = shift;
    my $msg  = <<'END';
(Make sure you load respective classes. This is currently done in bin/msh.pl, 
but should really be done in config file via plugins.)
FORMATS:
--------
END
    $self->verbose($msg);
    foreach ( sort keys %INC ) {
        {                           #make sure you get a local $1
            $_ =~ /^MARC\/File\/(\w+)\.pm/;
            say $1 if ( $1 && $1 ne 'Encode' );
        }
    }
}

1;
