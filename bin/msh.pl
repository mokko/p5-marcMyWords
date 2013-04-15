#ABSTRACT: Shell editor for MARC files
use MARC::Shell;

#temporary fix until I implement loading plugins from config file.
use MARC::File::USMARC;
use MARC::File::MicroLIF;
use MARC::File::XML;
use MARC::File::MARCMaker;

MARC::Shell->new->cmdloop;

=head1 SYNOPSIS

    #start interactive shell from your shell
    bash> marcmywords.pl

    #learn commands
    MARC::Shell>help

=head2 OPTIONS

Currently there are no command line options, but eventually there should be 
some, such as 
    -v      verbose

=head1 GLOBAL CONFIGURATION

In the future there will be a configuration file like
    ~/.marcMyWords


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

    context  
        report current directory, file currently opened etc.

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


=head1 TODO

reload msh if code has changed. I saw it somewhere on CPAN.
a working history. Saw it in Maisha Shell.

=cut