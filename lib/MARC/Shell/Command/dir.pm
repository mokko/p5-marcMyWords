#ABSTRACT: List directory contents
package MARC::Shell::Command::dir;
use strict;
use warnings;
use Moo::Role;
use File::Spec;

sub summary {'List directory contents'}

sub help {
    <<'END';
dir DIRECTORY 
    Lists directory contents. Expects a path to a directory (absolute or 
    relative). Defaults to current directory (.).

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
        $dir_wanted = '.';    #default
    }
    $self->debug("Enter run_dir $dir_wanted\n");

    if (!-d $dir_wanted) {
        $self->error ("Directory not found: '$dir_wanted'");
        return;
    }

    opendir(my $dh, $dir_wanted)
      || $self->error("Can't open dir '$dir_wanted': $!");

    #while and readdir with $_ work only since 5.11.2
    #list absolute or relative paths? Both, just as input
    foreach (readdir($dh)) {
        my $path = File::Spec->catfile($dir_wanted, $_);
        print "d" if (-d $path);
        print "l" if (-l $path);
        print "-" if (-f $path);
        print "\t$path\n";
    }
    closedir $dh;
}


1;
