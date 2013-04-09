package MARC::Shell::Command::load;
use Moo::Role;
#with 'Marc::Shell::Command'; #we could use another role to set common stuff

sub run {
    my $self = shift;
    print $self. "\n";


}

sub help {'foo\'s help string'}

sub sumary {'fooing the foo'}


1;
