#ABSTRACT: Save
package MARC::Shell::Command::save;
use Moo::Role;

sub summary {'saving the foo'}

sub help {'save\'s help string'}

sub run {
    my $self = shift;
    print $self->_command . "\n";


}




1;
