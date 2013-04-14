#ABSTRACT: List directory contents
package MARC::Shell::Command::dir;
use strict;
use warnings;
use Moo::Role;
use File::Spec;

sub summary { 'List directory contents' }

sub help {
    <<'END';
dir DIRECTORY 
    Lists directory contents. Expects a path to a directory (absolute or 
    relative). Defaults to current directory (.).

    TODO: current directory should be relative to context!
END
}

sub alias { qw (ls) }

#from App::Maisha
sub run_ls  { goto &MARC::Shell::run_dir }
sub smry_ls { "Alias to dir" }
sub help_ls { goto &MARC::Shell::help_dir }

#appears only when I do this, but command doesn't work then
#sub smry_ls {} #strange
#sub help_ls {} #strange

sub run {
    my ( $self, $dir_wanted ) = @_;

    if ( !$dir_wanted ) {
        $dir_wanted = '.';    #default
    }

    #$self->verbose("Enter run_dir $dir_wanted\n");
    $dir_wanted = $self->realpath_dir($dir_wanted) or return;

    opendir( my $dh, $dir_wanted )
      || $self->error("Can't open dir '$dir_wanted': $!");

    #while and readdir with $_ work only since 5.11.2
    #list absolute or relative paths? Both, just as input
    foreach my $path ( readdir($dh) ) {
        next if ( $path eq '.' or $path eq '..' );
        my $fullpath = Path::Class::Dir->new( $dir_wanted, $path );
        print "d" if ( -d $fullpath );
        print "l" if ( -l $fullpath );
        print "-" if ( -f $fullpath );
        print "\t$path\n";
    }
    closedir $dh;
}

=head1 TODO

Implement typical shell shortcuts like ~ or $HOME. Either as perl or perhaps
interfacing the shell. Where should it be? Not in dir, because common to 
several file commands.

Perhaps package MARC::Shell::FileUtils and sub path
with 'MARC::Shell::FileUtils'
$self->canonical_path ($path); replaces variables and other shortcuts

=cut

1;
