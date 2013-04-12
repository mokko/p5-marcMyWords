#ABSTRACT: Change current directory
package MARC::Shell::Command::cd;
use strict;
use warnings;
use Moo::Role;
use File::Spec;    #necessary? use MARC::Shell::FileUtils?

#use Try::Tiny;
use Cwd;

sub summary { 'Change current directory' }

sub help {
    <<'END';
cd DIRECTORY 
    Change current directory. Expects a path to a directory (absolute or 
    relative). 

    TODO: current directory should be relative to context!
END
}



sub run {
    my ( $self, $dir_wanted ) = @_;

    #$self->verbose("Enter run_cd $dir_wanted");
    $dir_wanted=$self->realpath_dir($dir_wanted) or return;

    $self->{data}{context}{dir} = $dir_wanted;
}

1;
