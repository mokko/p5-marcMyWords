#ABSTRACT: Show file currently opened/loaded
package MARC::Shell::Command::show;
use strict;
use warnings;
use Moo::Role;
use MARC::Batch;
use Say::Compat;
use Getopt::Long qw(GetOptionsFromArray);

sub summary { 'Show file currently opened/loaded ' }

sub help {
    <<'END';
Shows marc file in a human-friendly format.

show [FILE] --records
    shows only the leader field for each MARC record

    If no file is specified, it shows the file which is currently open.
    If you specify a file, it opens it first and then shows it.
    
    The flag --records shortens the display to two fields (001 and title). 
    
    Probably I should rename this flag. 
END
}

sub run {
    my $self = shift;
    my $records;
    GetOptionsFromArray( \@_, "records" => \$records );
    my $file = shift;

    if ($file) {
        $self->run_open($file);
    }

    $self->verbose("Enter run_show @_");

    #$self->verbose("Enter run_cd $dir_wanted");
    if ( !$self->{data}{context}{file} ) {
        $self->error("No file opened/loaded");
        return;
    }

    if ($records) {
        return $self->show_records;
    }

    if (@_) {
        $self->warn( 'Unrecognized arguments' . @_ );
    }

    my $batch = @{ $self->{data}{context}{file} }[1];

    while ( my $record = $batch->next() ) {
        my @fields = $record->fields();
        foreach my $field (@fields) {
            say $field->tag(), " ",
              defined $field->indicator(1) ? $field->indicator(1) : "",
              defined $field->indicator(2) ? $field->indicator(2) : "",
              " ", $field->as_string;
        }
        $self->separator;
        ## print the title contained in the record.
        #        print $record->title(), "\n";

    }
    if ( my @warnings = $batch->warnings() ) {
        say "\nWarnings were detected!", @warnings;
    }
}

sub show_records {
    my $self = shift;

    $self->verbose("Enter show_records");
    if ( !$self->{data}{context}{file} ) {
        $self->error("No file opened!");
        return;
    }

    my $batch = @{ $self->{data}{context}{file} }[1];

    $self->separator;
    while ( my $record = $batch->next() ) {
        my $tag   = 001;
        my $field = $record->field($tag);
        if ($field) {
            say "$tag  ", $field->as_string();
        }
        say "title ", $record->title();
        $self->separator;
    }

    ## make sure there weren't any problems.
    if ( my @warnings = $batch->warnings() ) {
        say "\nWarnings were detected!", @warnings;
    }

    $self->reload_file; #to be able to read from it again...
    

    $self->{data}{context}{file} = [ $file, $batch, $format ];

}

1;
