package MARC::Shell::Command::save;
use Moo::Role;

sub run {
    my $self = shift;
    print $self->_command . "\n";


}

sub help {'save\'s help string'}

sub sumary {'saving the foo'}


1;
