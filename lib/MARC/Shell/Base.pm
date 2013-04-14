package MARC::Shell::Base;    #it's a role, not sure base is suitable name
use strict;
use warnings;
use Moo::Role;
use Path::Class;
use MooX::Types::MooseLike::Base qw (Str);
use Say::Compat;

#with 'MARC::Shell::History'; dont need no freaking history right now
#with 'MARC::Shell::Plugins'; renaming of subs doesn't easily work except in Shell.pm

#
# FileUtils -> use Path::Class instead
#

=method $path=$self->realpath_dir ($new_path)

changes to new $new_path relative to current context and returns absolute path
for new directory. Also tests if $new_path exists and is a directory.

context: /a/b (always absolute)
cd: /c/d (absolute)
new context /c/d
cd e/f
new conext: c/d/e/f

=cut 

sub realpath_dir {
    my ( $self, $dir_wanted ) = @_;
    if ( !$dir_wanted ) {
        $self->error("No directory specified!");
        return;
    }

    $dir_wanted = Path::Class::Dir->new($dir_wanted);

    #mk absolute relative to context dir
    if ( $dir_wanted->is_relative ) {
        $dir_wanted =
          Path::Class::Dir->new( $self->{data}{context}{dir}, $dir_wanted );
    }
    if ( !-e $dir_wanted ) {
        $self->error("does not exist!");
        return;
    }

    if ( !-d $dir_wanted ) {
        $self->error("not a directory!");
        return;
    }

    return $dir_wanted->resolve->stringify;
}

sub realpath_file {
    my ( $self, $file ) = @_;

    if ( !$file ) {
        $self->error("No file specified!");
        return;
    }

    $file = Path::Class::File->new($file);

    #mk absolute relative to context dir
    if ( $file->is_relative ) {
        $file =
          Path::Class::Dir->new( $self->{data}{context}{dir}, $file );
    }
    if ( !-e $file ) {
        $self->error("file does not exist!");
        return;
    }

    if ( !-f $file ) {
        $self->error("not a file!");
        return;
    }

    return $file->resolve->stringify;
}

=method my $text=$self->_get_file_text($file);

returns slurped text file.

Keep this private (underscore)?

=cut

sub _get_file_text {    #from Test::Mining::Shell
    my ( $self, $path_file_name ) = @_;
    my ( $text, $line );
    if ( -e $path_file_name ) {
        open( my $IN, '<', $path_file_name )
          || $self->error("(Get) Cannot open $path_file_name: $!");
        while ( $line = <$IN> ) { $text .= $line; }
        close($IN) || $self->error("(Get) Cannot close $path_file_name: $!");
    }
    return $text;
}

#
# REPLACE SHELL VARIABLES AND OTHER SHORTCUTS
#

=method arg_cleanup

When I process args in from the shell CLI I want to use commond shell shortcuts
like ~ and $HOME, so I thought, I pass args through a cleanup

    ~ becomes $HOME (shell environment)
    
Environment variables which were in place when you started msh should work as 
well. Currently, I am not messing with $SHELL.

I guess there can be only one arg at a time.

Todo: see expand in Term::Shell::Enhanced.

=cut

sub arg_cleanup {
    my $self = shift;
    my $arg = shift or return;

    #assuming that each arg can only have one var
    $arg =~ s/\~/$ENV{HOME}/g;
    $arg =~ /\$(\w+)/g;
    return $ENV{$1} if ( $1 && $ENV{$1} );
    return $arg;
}

#
# MESSAGES
#

sub verbose {
    my $self = shift;
    my $msg = shift or return;
    say "$msg" if $self->{conf}{verbose};
}

sub error {
    my $self = shift;
    my $msg = shift or return;
    say "Error: $msg";
}

sub warn {
    my $self = shift;
    my $msg = shift or return;
    say "Warning: $msg";
}

sub separator {
    say "---------------------";
}

#
# FUNC
#

1;
