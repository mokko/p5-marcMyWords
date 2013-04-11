#ABSTRACT: Role to load history
package MARC::Shell::History;    #gets called in M::S::Base
use strict;
use warnings;
use Moo::Role;
use MooX::Types::MooseLike::Base qw (Str);


has history_filename => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    builder => '_build_history_filename'
);


our @history;    #is this a simpleton? Should probably be moo attribute

#has history => (is=>'rw',isa=>Array);

sub _build_history_filename {
    my $self = shift;

    my $path=$self->path ($self->conf_dir,'shell_history');
    return $path;
}

#basically from Test::Mining::Shell
sub _load_history {
    my $self = shift;
    print "history_filename" . $self->history_filename . "\n";
    chomp(my $text = $self->_get_file_text($self->history_filename));
    @history = split(/\n/, $text);
    return \@history;
}

1;
