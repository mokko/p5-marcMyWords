#ABSTRACT: Load a MARC file
package MARC::Shell::Command::open;
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

    if ( $self->{data}{context}{file} ) {
        $self->error("Close file before you open new one.");
        return;
    }

    if ( !$format ) {
        $format = 'USMARC';    #default
        $self->verbose("No format specified, default to '$format'.");
    }

    $file = $self->realpath_file($file) or return;

    my $batch = MARC::Batch->new( $format, $file ) or die $MARC::File::ERROR;

    #die not tested.
    #$batch->strict_off();
    $self->verbose("File loaded $file");
    $self->{data}{context}{file} = [ $file, $batch, $format ];

    #set context for file and record
    #open first record
}

sub reload_file {
    my $self = shift;
    $self->load(
        @{ $self->{data}{context}{file} }[0],
        @{ $self->{data}{context}{file} }[2]
    );
}
1;
