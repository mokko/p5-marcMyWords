#ABSTRACT: Load a MARC file
package MARC::Shell::Command::open;
use Moo::Role;
use MARC::File;
use Say::Compat;

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
    my ( $self, $filename ) = @_;
    my $format = shift || 'USMARC';    #default

    if ( $self->{data}{context}{file} ) {
        $self->error("Close file before you open new one.");
        return;
    }

    $filename = $self->realpath_file($filename) or return;

    $self->_open($filename,$format);
    $self->verbose("File loaded: $filename as $format");
 }


#used for re-opens
sub _open {
    my ($self, $filename, $format)=@_;
    die "Bad error! Format missing" if (!$format); #should never happen!

    #die not tested
    my $file = "MARC::File::$format"->in($filename) or die $MARC::File::ERROR;
    $self->{data}{context}{file} = [ $filename, $format, $file ];
   
}

sub reload_file {
    my $self = shift;

    #say "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";
    my $filename = $self->current_filename;

    #    my $filename = @{ $self->{data}{context}{file} }[0];
    my $format = $self->current_format;

    #    my $format   = @{ $self->{data}{context}{file} }[1];
    #my $file     = @{ $self->{data}{context}{file} }[2];
    $self->verbose("Reloading ($filename, $format)");
    #$file->close; #probably not necessary...
    delete $self->{data}{context}{file}; #see also run_close in close.pm
    $self->_open( $filename, $format );
}

=method $self->current_filename; 

Gets location (absolute filepath) of currently opened file.

(Value gets set in open.pm.)
=cut

sub current_filename {
    @{ $_[0]->{data}{context}{file} }[0];
}

=method $self->current_format;

Gets format of current file.

=cut $self->current_format;

sub current_format {
    @{ $_[0]->{data}{context}{file} }[1];
}

=method $self->current_file;

=cut

sub current_file {
    @{ $_[0]->{data}{context}{file} }[2];
}

1;
