#ABSTRACT: Change current directory
package MARC::Shell::Command::cd;
use strict;
use warnings;
use Moo::Role;
use File::Spec;    #necessary? use MARC::Shell::FileUtils?
use Try::Tiny;
use Cwd;

sub summary {'Change current directory'}

sub help {
    <<'END';
cd DIRECTORY 
    Change current directory. Expects a path to a directory (absolute or 
    relative). 

    TODO: current directory should be relative to context!
END
}

=head1 TODO

Implement typical shell shortcuts like ~ or $HOME. Either as perl or perhaps
interfacing the shell. Where should it be? Not in dir, because common to 
several file commands.

Perhaps package MARC::Shell::FileUtils and sub path
with 'MARC::Shell::FileUtils'
$self->canonical_path ($path); replaces variables and other shortcuts

=cut


sub run {
    my ($self, $dir_wanted) = @_;

    if (!$dir_wanted) {
        $self->error("No directory specified");
        return;
    }

    if (!-d $dir_wanted) {
        $self->error("Wanted directory not found: '$dir_wanted'");
        return;
    }

    $self->debug("Enter run_cd $dir_wanted");

    #chdir can die on strange OSes; todo test
    try {
        if (chdir $dir_wanted) {
            $self->{data}{context}{dir} = File::Spec->rel2abs(getcwd);
        }
        else {
            $self->error("Error changing to new directory:$dir_wanted");
        }
    }
}


1;
