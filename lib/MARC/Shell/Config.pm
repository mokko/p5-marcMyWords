#ABSTRACT: Configuration specific to MARC::Shell
package MARC::Shell::Config;
use strict;
use warnings;
use Path::Class::Dir;
use Path::Class::File;
use File::HomeDir;
use Moo;
use MooX::Types::MooseLike::Base qw (Str);

=head1 SYNOPSIS

    use MARC::Shell::Config;

    #create config dir or dies
    my $conf=MARC::Shell::Config->new; 
    
=method new

returns MARC::Shell::Config object. The config object is essentially a 
hashref with content of the config file. Expects nothing.



=cut

#
# location
#

=attr dir


my $path=$conf->dir;

Return absolute full path to config dir. 
    $HOME/.marcMyWords

TODO: If you provide your own dir things will not work now!
    
=cut

has 'dir' => (
    is      => 'ro',
    isa     => Str,
    builder => '_build_dir',      #if new has NO dir
    trigger => \&_trigger_dir,    #if new has dir
);

#default: only when constructor has no DIR
sub _build_dir {
    my $config_dir =
      Path::Class::Dir->new( File::HomeDir->my_home, '.marcMyWords' )
      ->stringify;
    if ( !-d $config_dir ) {
        mkdir $config_dir
          or die "Can't make config dir: $config_dir";
    }
    return $config_dir;
}

#only when passed a value from constructor
sub _trigger_dir {
    my ( $self, $dir ) = @_;
    $self->{dir} = Path::Class::Dir->new($dir)->cleanup->absolute->stringify;
}

=method my $path=$conf->file; 

Return absolute full path to config file
    $HOME/.marcMyWords/config

=cut

has 'file' => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    builder => '_build_file',      #if new has NO dir
    trigger => \&_trigger_file,    #if new has dir
);

sub _build_file {
    my $self = shift;
    my $config_file = Path::Class::File->new( $self->dir, 'config' )->stringify;

    #todo warn if config file doesn't exist
    if ( !-f $config_file ) {
        warn "Warning: Config file not found!";
    }
    return $config_file;
}

#only when passed a value from constructor
sub _trigger_file {
    my ( $self, $file ) = @_;
    $file = Path::Class::File->new($file)->cleanup->absolute;
    $self->{file} = $file->stringify;
    $self->{dir}  = $file->dir->stringify;
}

1;
