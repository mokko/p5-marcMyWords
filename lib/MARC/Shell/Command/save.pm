#ABSTRACT: Save a file
package MARC::Shell::Command::save;
use Moo::Role;
use MARC::File::USMARC;    #necessary?
use Say::Compat;

sub summary { 'Save a file' }

sub help {
    <<'END';
Save a file.

save
    saves currently open file under same name (overwrite).
    Should confirm before saving (todo).

save FILENAME
    saves currently open file under new name.

Todo: allow saving different formats. Currently USMARC by default.
 
END
}

sub run {
    my $self = shift;

    if ( !$self->{data}{context}{file} ) {
        $self->error("No file opened!");
        return;
    }

    my $filename = shift || $self->current_filename;
    my $file = $self->current_file;
    open( OUTPUT, "> $filename" ) or die $!;   #all good things are three (todo)
    while ( my $record = $file->next() ) {
        print OUTPUT $record->as_usmarc();
    }
    close(OUTPUT);

    if ( my @warnings = $file->warnings() ) {
        say "\nWarnings were detected!", @warnings;
    }
    $self->run_close;
}

1;
