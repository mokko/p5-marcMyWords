#ABSTRACT: Role to load history
package MARC::Shell::History;    #gets called in M::S::Base
use strict;
use warnings;
use Moo::Role;
use MooX::Types::MooseLike::Base qw (Str);

#history_file is new history_filename

our @history;    #is this a simpleton? Should probably be moo attribute

#basically from Test::Mining::Shell
sub _load_history {
    my $self = shift;
    print "history_filename" . $self->conf->{history_file} . "\n";
    chomp( my $text = $self->_get_file_text( $self->history_file) );
    @history = split( /\n/, $text );
    return \@history;
}

1;
