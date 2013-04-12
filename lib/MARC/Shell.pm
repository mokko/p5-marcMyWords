#ABSTRACT: Shell interface to MARC::Record and friends
package MARC::Shell;
use strict;
use warnings;
use parent qw(Term::Shell);    #still necessary?
use Moose;                     #for load_plugins
use Log::Dispatchouli;

#use File::Spec;                #could be in FileUtils
#use Cwd;
use MARC::Shell::Config;
use Getopt::Long;
use Path::Class::Dir;
use Path::Class::File;

with 'MARC::Shell::Base';

=head1 SYNOPSIS


=head1 DESCRIPTION

This document describes MARC::Shell's internals. See bin/msh.pl for 
user-facing documentation!

=head1 STATE

config (possibly MARC::Shell::Config object)
    dir: config dir (set in M::S::Config)
    file: full path to config file (set in M::S::Config)
    verbose: verbose mode on (1) or off (undef), from command line 
data
    context
        dir: always save absolute path
        file: with fully qualified paths
        record

=head1 PLUGINS

MARC::Shell's commands are stored as plugins in separate files at
    MARC::Shell::Command::$command

Each command is a Moo/se role. Each command should have a help, sumary and run 
method.

=cut

#TODO: currently it's necessary to list all commands
#We have a mechanism that loads plugins automatically, e.g. those
#which are in the MARC/Shell/Commands directory. Then we eventually
#need a mechanism to exclude deprecated plugins...
#our @plugins = qw(load save dir info cd);
load_plugins( autoplugs() );    #function!

=func load_plugins qw(a b c);

a b c will be available as commands. Dies on error.

=cut

sub load_plugins {
    print "About to load commands: @_\n";

    #-alias seems to work only with Moose, not with Moo.
    #Alternative would be Sub::Exporter
    foreach my $plugin (@_) {
        with "MARC::Shell::Command::$plugin" => {
            -alias => {
                run     => "run_$plugin",
                help    => "help_$plugin",
                summary => "smry_$plugin",
                alias   => "alias_$plugin",
                comp    => "comp_$plugin",
            },
            -excludes => [ 'run', 'help', 'summary', 'comp', 'alias' ]
        };
    }
}

=func autoplugs

Return the names of MARC::Shell commands installed in the directory of this 
install of MARC::Shell. 


=cut

sub autoplugs {
    my $class = __PACKAGE__;
    $class =~ s/::/\//;
    $class .= '.pm';
    my $path = $INC{$class};
    $path =~ s/.pm$//;
    $path = Path::Class::Dir->new( $path, 'Command' );

    my @plugs;
    if ( -d $path ) {
        opendir( my $dh, $path )
          || die "Can't open plugin dir: $!";

        while ( my $item = readdir($dh) ) {
            next if $item =~ /^\./;
            $item =~ s/.pm$//;
            push @plugs, $item;
        }
        closedir $dh;
    }
    return @plugs;
}

=method init

We use case insensitive commands within MARC::Shell.

=cut

sub init {
    my $self = shift or return;
    $self->{conf} = MARC::Shell::Config->new();
    $self->{conf}{argv_orig} = [@ARGV] || [];
    $self->{conf}{myself} = Path::Class::File->new($0)->absolute->stringify;
    
    $self->{API}->{case_ignore} = 1;

    #    "length=i" => \$length,    # numeric
    #    "file=s"   => \$data,      # string
    #fold command-line options and config file into one structure?
    GetOptions( "verbose" => \$self->{conf}{verbose} )
      or die("Error in command line arguments\n");

    #TODO:should depend on config file or command line options
    #my $logger = Log::Dispatchouli->new(
    #    {   ident     => 'MARC::Shell Logger',
    #        facility  => 'daemon',
    #        to_stdout => 1,
    #        debug     => 1,                      #$opt->{verbose}
    #    }
    #);

    $self->verbose("Verbose mode on");

    #init context
    $self->{data}{context}{dir} =
      Path::Class::Dir->new->absolute->stringify;

    #$self->{term}->SetHistory(@{$self->_load_history()});

}

=method
MARC::Shell path/to/directory>>
MARC::Shell path/to/file>>
MARC::Shell path/to/file::record>>

If prompt gets too long, we can probably wrap it in two lines.
MARC::Shell path/to/file
identifier>>

#prompt should be context sensitive, but to implement that
#i need to understand first how to save state
#i am guessing I can save info in $o

=cut

sub prompt_str {
    my $self   = shift;    #untested
    my $prompt = 'msh:';

    #either add file or dir if they exist
    if ( $self->{data}{context}{file} ) {
        $prompt .= $self->{data}{context}{file};
    }
    else {
        $prompt .= $self->{data}{context}{dir}
          if ( $self->{data}{context}{dir} );
    }

    #long lines get two lines
    $prompt .= "\/\n" if ( length $prompt > 70 );

    #add current record if identifier exists
    if ( $self->{data}{context}{record} ) {
        $prompt .= '::' . $self->{data}{context}{record};
    }

    return $prompt . '>';
}

=head1 QUESTIONS

How to deal with encoding? Which coding are we using at the moment? Should 
that be displayed?

We have to show a context, i.e. where we are. We can be in a directory, a file 
or a record.

=cut

#
# PLUGINS
#

1;
