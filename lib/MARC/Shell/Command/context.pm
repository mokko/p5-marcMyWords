#ABSTRACT: Show current context
package MARC::Shell::Command::context;
use strict;
use warnings;
use Moo::Role;
use Say::Compat;

sub summary { 'Show current context' }

sub help {
    <<'END';
context 
    Show current context. 
END
}

sub run {
    my ($self) = shift;

    #$self->verbose("Enter run_cd $dir_wanted");
    my $context = $self->{data}{context};

    say "dir:" . $context->{dir} if $context->{dir};
    say "file:" . $context->{file}{file}{filename} if $context->{file}{file}{filename};
    say "record:" . $context->{record}
      if $context->{record};
}

1;
