#ABSTRACT: Spit out info about MARC::Shell's current state
package MARC::Shell::Command::info;
use strict;
use warnings;
use Moo::Role;
use Data::Dumper;

sub summary {'See MARC::Shell\'s current state'}

sub help {
    <<'END';
info [KEY]
    Output info about current state. 
    
    Optionally specify a hash key to limit output to a section. Currently, only
    the first level keys are recognized. 
END
}

sub run {
    my $self = shift;
    my $key = shift or print Dumper $self;

    if ($key) {
        if (!$self->{$key}) {
            $self->error("Key not recognized: '$key'");
            return;
        }
        print Dumper $self->{$key};
    }
}


1;
