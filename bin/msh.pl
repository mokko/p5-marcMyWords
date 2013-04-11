#ABSTRACT: Shell editor for MARC files
use MARC::Shell;
MARC::Shell->new->cmdloop;

=head1 SYNOPSIS

    #start interactive shell from your shell
    bash> marcmywords.pl

    #learn commands
    MARC::Shell>help

=head2 OPTIONS

currently there are no command line options, but eventually there should be 
some, such as 
    -v      verbose

=head1 GLOBAL CONFIGURATION

In the future there will be a configuration file like
    ~/.marcMyWords

=cut