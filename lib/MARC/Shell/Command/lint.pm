#ABSTRACT: Check MARC file using MARC::Lint
package MARC::Shell::Command::lint;
use strict;
use warnings;
use Moo::Role;
use Say::Compat;
use MARC::Lint;

sub summary { 'Check marc file using MARC::Lint' }

sub help {
    <<'END';
Check marc file using MARC::Lint.

lint
    checks currently open file
    
lint FILE
    checks FILE
 
END
}

sub run {
    my $self = shift;
    my $file = shift;

    if ($file) {
        $self->run_open($file);
    }

    if ( !$self->{data}{context}{file} ) {
        $self->error("No file opened/loaded");
        return;
    }

    #from marclint
    my $counts = 0;
    my $errors = 0;
    $file  = @{ $self->{data}{context}{file} }[1]; #file=batch
    my $linter = new MARC::Lint;

    while ( my $marc = $file->next() ) {
        if ( not $marc ) {
            warn $MARC::Record::ERROR;
            ++$errors;
        }
        else {
            ++$counts;
        }

        #store warnings in @warningstoreturn
        my @warningstoreturn = ();

        #retrieve any decoding errors
        #get any warnings from decoding the raw MARC
        push @warningstoreturn, $marc->warnings();

        $linter->check_record($marc);

        #add any warnings from MARC::Lint
        push @warningstoreturn, $linter->warnings;

        if (@warningstoreturn) {
            say join( $marc->title, @warningstoreturn, "\n");
            ++$errors;
        }
    }    # while
    $self->reload_file; #to be able to read from it again...
    
}

1;
