#ABSTRACT: Edit a record
package MARC::Shell::Command::edit;
use strict;
use warnings;
use Moo::Role;

sub summary { 'Edit a record' }

sub help {
    <<'END';
Edit a record.

edit RECORD-NUMBER
END

}

sub run {
    my $self = shift;
    my $no   = shift;

    if ( !$no ) {
        $self->error('You need to pick a record!');
        return;
    }
#todo
}
