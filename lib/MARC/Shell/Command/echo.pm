#just for debugging
package MARC::Shell::Command::echo;
use strict;
use warnings;
use Moo::Role;

sub summary { 'just for debugging'}

sub run {
    my $self=shift;
    
    foreach (@_) {
        print "arg_cleanup: $_->".$self->arg_cleanup($_)."\n";
    }
    
}

1;