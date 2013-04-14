#ABSTRACT: Change current directory
package MARC::Shell::Command::close;
use strict;
use warnings;
use Moo::Role;

#use Try::Tiny;
use Cwd;

sub summary { 'Close file' }

sub help {
    <<'END';
close  
    Closes current file. Discards unsaved changes.
END
}



sub run {
    my $self = shift;
    #i should ask here if user really wants to close file
    $self->{data}{context}{file} = undef;
}

1;
