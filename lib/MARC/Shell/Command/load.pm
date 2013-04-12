#ABSTRACT: Load a MARC file
package MARC::Shell::Command::load;
use Moo::Role;
use MARC::Batch;

#use MARC::Record;

sub summary { 'Load a MARC file' }

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
    my ( $self, $file, $format ) = @_;

    if ( !$file ) {
        $self->error("No file specified!");
        return;
    }

    if ( !-f $file ) {
        $self->error("File does not exist or is no file!");
        return;
    }

    if ( !$format ) {
        $format = 'USMARC';    #default
        $self->verbose("You didn't specify a format. I assume you want '$format'.");
    }
    my $batch = MARC::Batch->new( 'USMARC', $file )
      or die "Not sure this works";

    #set context for file and record
    #open first record
}

1;
