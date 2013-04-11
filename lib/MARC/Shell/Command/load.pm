#ABSTRACT: Load a MARC file
package MARC::Shell::Command::load;
use Moo::Role;

sub summary {'Load a MARC file'}

sub help {
    <<'END';
load FILE [FORMAT]
    loads a marc file. 
    
    Expects absolute or relative path. 
    
    You may specify a format. Default format is marc (binary). See the formats 
    command for list of all supported formats.
END
}

sub run {
    my $self = shift;
    print $self. "\n";
}




1;
