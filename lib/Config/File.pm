#ABSTRACT
package Config::File;
use strict;
use warnings;
use Moo;
use MooX::Types::MooseLike::Base qw (Str);    #try Types::Tiny one of these days
use File::HomeDir;
use Path::Class;                              #exports file and dir

=head1 SYNOPSIS

    #INIT: set location of config file
    #either using defaults
    my $conf=MooX::Config->new(); # $HOME/config

    #OR
    my $conf=MooX::Config->new(path=>'/path/to/config')

    #OR using file and dir 
    my $conf=MooX::Config->new(dir=>'/path/to', file=>'config')

    #as a result you will have access to path and components
    #all paths are absolute and cleaned up
    $conf->path; #full path to config file
    $conf->file; #only file (basename)
    $conf->dir;  #path to config dir

    #SETTING AND GETTING
    #set config values
    $conf->{key}=$value; #or _key ???
    $conf->set('key',$value);

    #get config value
    my $value=$conf->get('key');
    $conf->{key}; #or _key ???

    #LOAD config file
    my $conf=MooX::Config->new(type=>'INI); # $HOME/config
    
    #currently I think only of a single conf dir... that's fine


=head1 DESCRIPTION

This module encapsulates some of the stuff you need to do with 
configuration files (config file) repeatedly. 

It doesn't specify yet another config file format. Instead, 
=over 

=item * It helps with finding a good location for your config file.

=item * It provides an object for config information.

It creates the directory (conf dir) in which the conf file lies, if it doesn't 
exist yet.

If the conf file exists, object is populated it with info from conf file.

config->path    #full path to config file
config->dir  #directory in which config file lies   
config->file #filename of config file

You may provide input with relative paths, but internally all paths are stored 
absolute! This is a feature.

=head1 COMPARISON

A bit like L<Config::Role>, but using Moo and with clearer documentation.

=attr file

Either provide the location of the configuration file, e.g. 

    my $conf=MooX::Config->new(file=>'/home/you/.MyClass/config')

or a sensible default (requires Moose): 
    
    $HOME/My_Class/config

=cut

has 'file' => (
    is      => 'ro',
    isa     => Str,
    default => sub { 'config' }    #only when file NOT in constructor

      #    trigger  => \&_trigger_file,  #only when file in constructor
);

has 'path' => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    builder => '_build_path',      #only when path NOT in constructor
    trigger => \&_trigger_path,    #only when path in constructor
);

#default: only built when no value specified during construction
sub _build_path {
    return Path::Class::File->new( $_[0]->dir, $_[0]->file )
      ->absolute->stringify;
}

#only when path specified during construction
#overwrite dir and file then
sub _trigger_path {
    my $self = shift;
    my $path = Path::Class::File->new(shift)->cleanup;
    if ( !$path->is_absolute ) {
        $path = $path->absolute;
    }

    $self->{dir} = dir($path)->cleanup->absolute;
    my @comp = $path->components();

    #map { print "|||$_ " } @comp;
    #print "\n";

    $self->{file} = $comp[-1];
}

=attr dir

=cut

has 'dir' => (
    is  => 'ro',
    isa => Str,

    #default = only when dir NOT in constructor
    default => sub { File::HomeDir->my_home },
    trigger => \&_trigger_dir, #only when dir in constructor
);

#cleanup and make absolute what is suplied from constructor
#mkdir if it doesn't exist yet or die
sub _trigger_dir {
    my $self = shift;
    $self->{dir} = Path::Class::Dir->new(shift)->cleanup->absolute;
    if ( !-d $self->{dir} ) {
        mkdir $self->{dir} or die "Can't make config dir: $self->{dir}"
    }

}

1;
