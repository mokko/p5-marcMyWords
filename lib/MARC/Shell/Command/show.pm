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

show [FILE] [--records] [--page]
    shows only the leader field for each MARC record

    If no file is specified, it shows the file which is currently open.
    If you specify a file, it opens it first and then shows it.
    
OPTIONS
    The optional flag --records shortens the display to two fields (001 and 
    title). 
    
    Probably I should rename this flag.
    
    --page: output through pager (todo) 
END
}

sub run {
    my $self = shift;
    my ( $records, $pager );
    GetOptionsFromArray( \@_, "records" => \$records, "pager" => \$pager );
    my $filename = shift;

    if ($filename) {
        $self->run_open($filename) or return;
    }

    #$self->verbose("Enter run_show @_");

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

    my $file = @{ $self->{data}{context}{file} }[2];
    my $i = 1;
    while ( my $record = $file->next() ) {
        $self->separator( $i++ );
        my @fields = $record->fields();
        foreach my $field (@fields) {
            say $field->tag(), " ",
              defined $field->indicator(1) ? $field->indicator(1) : "",
              defined $field->indicator(2) ? $field->indicator(2) : "",
              " ", $field->as_string;
        }
        ## print the title contained in the record.
        #        print $record->title(), "\n";

    }
    if ( my @warnings = $file->warnings() ) {
        say "\nWarnings were detected!", @warnings;
    }
    $self->reload_file;    #to be able to read from it again...
}

sub show_records {
    my $self = shift;

    $self->verbose("Enter show_records");
    if ( !$self->{data}{context}{file} ) {
        $self->error("No file opened!");
        return;
    }

    my $file = @{ $self->{data}{context}{file} }[2];

    my $i = 1;
    while ( my $record = $file->next() ) {
        $self->separator( $i++ );
        my $tag   = 001;
        my $field = $record->field($tag);
        if ($field) {
            say "$tag  ", $field->as_string();
        }
        say "title ", $record->title();
    }

    ## make sure there weren't any problems.
    if ( my @warnings = $file->warnings() ) {
        say "\nWarnings were detected!", @warnings;
    }

    $self->reload_file;    #to be able to read from it again...

    #$self->{data}{context}{file} = [ $file, $batch, $format ];

}

1;
