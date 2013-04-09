#ABSTRACT: Shell interface to MARC::Record and friends
package MARC::Shell;
use strict;
use warnings;
use parent qw(Term::Shell);    #still necessary?
use Moose;

prompt_str('MARC::Shell');

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
        list a directory (not basic)
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

MARC::Shell path/to/directory>>
MARC::Shell path/to/file>>
MARC::Shell path/to/file::identifier>>

If prompt gets too long, we can probably wrap it in two lines.
MARC::Shell path/to/file
identifier>>



 opendir(my $dh, $some_dir) || error "can't opendir $some_dir: $!";
    @dots = grep { /^\./ && -f "$some_dir/$_" } readdir($dh);
    closedir $dh;


=head1 CONFIGURATION

Eventually, there will be a configuration file or directory
    ~/.marcMyWords
    

=head1 PLUGINS

MARC::Shell's commands are stored as plugins in separate files at
    MARC::Shell::Command::$command

Each command is a Moo/se role. Each command should have a help, sumary and run 
method.

=cut

my @plugins = qw(load save);
load_plugins (@plugins);

#
# SUBS
#

sub load_plugins {
    #-alias seems to work only with Moose, not with Moo. 
    #Alternative would be Sub::Exporter
    my @plugins=@_;
    foreach my $plugin (@plugins) {
        with "MARC::Shell::Command::$plugin" => {
            -alias => {
                run    => "run_$plugin",
                help   => "help_$plugin",
                sumary => "smry_$plugin"
            },
            -excludes => ['run', 'help', 'sumary',]
        };
    }
}

1;
