package MARC::Shell::Messages;
use strict;
use warnings;
use Moo::Role;
use Say::Compat;

sub verbose {
    my $self = shift;
    my $msg = shift or return;
    $msg =~ s/\n$//;
    say "$msg" if $self->{conf}{verbose};
}

sub error {
    my $self = shift;
    my $msg = shift or return;
    say "Error: $msg";
}

sub warn {
    my $self = shift;
    my $msg = shift or return;
    say "Warning: $msg";
}

sub separator {
    my $self = shift;
    my $no   = shift;
    my $hr   = "---------------------";

    say $hr;
    if ($no) {
        say "RECORD NO. #$no";
        say $hr;
    }

}

1;