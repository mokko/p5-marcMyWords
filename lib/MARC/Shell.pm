#ABSTRACT: Shell interface to MARC::Record and friends
package MARC::Shell;
use strict;
use warnings;
use parent qw(Term::Shell);    #still necessary?
use Moose; #for load_plugins
use Log::Dispatchouli;
use File::Spec;                #could be in FileUtils
use Cwd;    
use MARC::Shell::Config;

with 'MARC::Shell::Base';

=head1 SYNOPSIS

see msh.pl for user-facing documentation!

=head1 PLUGINS

MARC::Shell's commands are stored as plugins in separate files at
    MARC::Shell::Command::$command

Each command is a Moo/se role. Each command should have a help, sumary and run 
method.

=cut

#TODO: currently it's still necessary to list all commands
our @plugins = qw(load save dir info cd);
load_plugins(@plugins); #function!

=head1 NOTES
TERM::Shell wants me to use 
$self->{SHELL} to store data, but $self->{data} seems more appropriate

data
    context
        dir: always save absolute path
        file: with fully qualified paths
        record

=cut

sub run_() {
    print "blank line\n";
}

=method init

We use case insensitive commands within MARC::Shell.

=cut

sub init {
    my $self = shift or return;
    $self->debug("Enter init");
    $self->{API}->{case_ignore} = 1;

    #TODO:should depend on config file or command line options
    #my $logger = Log::Dispatchouli->new(
    #    {   ident     => 'MARC::Shell Logger',
    #        facility  => 'daemon',
    #        to_stdout => 1,
    #        debug     => 1,                      #$opt->{verbose}
    #    }
    #);

    $self->debug("Debuging on");
    $self->{conf}=MARC::Shell::Config->new();

    



    #init context
    $self->{data}{context}{dir} = File::Spec->rel2abs(getcwd);
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
    if ($self->{data}{context}{file}) {
        $prompt .= $self->{data}{context}{file};
    }
    else {
        $prompt .= $self->{data}{context}{dir}
          if ($self->{data}{context}{dir});
    }

    #long lines get two lines
    $prompt .= "\/\n" if (length $prompt > 70);

    #add current record if identifier exists
    if ($self->{data}{context}{record}) {
        $prompt .= '::' . $self->{data}{context}{record};
    }

    return $prompt . '>';
}

=head1 COMMANDS (todo)

=head2 Shell related

    help [COMMAND]       
        help on commands

    exit        
        leave MARC::Shell

    debug DEBUG_LEVEL
        turns debuging on or off        
        DEBUG_LEVEL accepts log, debug, fatal or off.
        
        Will probably use Log::Dispatchouli

    info
        reports info on the current state of MARC::Shell
        e.g. encoding

    formats 
        list known formats and their labels


=head2 File Operations

    load FILE [FORMAT]       
        load a file (basic)
        default format is ?

    save FILE [FORMAT]       
        save a file (basic)
        default format is ?

    which_file  
        report currently opened file; 
        can perhaps be eliminated by a clever prompt (expendable)

    cd DIRECTORY
        change directory (not basic)

    dir DIRECTORY       
        list directory contents (not basic)
        just for convenieance so you don't have to go back to shell

    convert INPUT_FILE OUTPUT_FILE [INPUT_FORMAT] [OUTPUT_FORMAT]   
                a file a from one format to another
                how to determine input and output formats?
      
    TODO
       other shell convenience file operations like a backup, or delete etc.
   

=head2 Selecting a record

Don't assume that a file has only one record! If no file selected report an 
error.

    show          
                show current file (in marcmaker format, basic)

    show_records
    showr
                show only the selected records's indentifiers
    
    select ID   
                select a record (basic)

    select -i
                select a record interactively (non-basic)


=head2 Edit a record

You can only edit a record if a record is selected.

    mod TAG TAGCONTENT       
        modify a tag

    add TAG TAGCONTENT        
        add a tag

    del         
        delete a tag
    
=head2 Validation (file/record)

    validate

    TODO

=head1 QUESTIONS

How to deal with encoding? Which coding are we using at the moment? Should 
that be displayed?

We have to show a context, i.e. where we are. We can be in a directory, a file 
or a record.

=cut


#
# SUBS
#


#
# PLUGINS
#

=func load_plugins qw(a b c);

a b c will be available as commands. Dies on error.

=cut

sub load_plugins {
    #-alias seems to work only with Moose, not with Moo.
    #Alternative would be Sub::Exporter
    my @plugins = @_;
    foreach my $plugin (@plugins) {
        #$self->debug("about to load 'MARC::Shell::Command::$plugin'");
        with "MARC::Shell::Command::$plugin" => {
            -alias => {
                run     => "run_$plugin",
                help    => "help_$plugin",
                summary => "smry_$plugin",
            },
            -excludes => [ 'run', 'help', 'summary', ] 
        };
    }
}


1;
