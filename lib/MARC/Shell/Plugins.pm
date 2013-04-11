package MARC::Shell::Plugins; #NOT USED!
use strict;
use warnings;
use Moose::Role;    #to rename subs

#
# PLUGINS
#

=method load_plugins qw(a b c);

a b c will be available as commands. Dies on error.

=cut

sub load_plugins {
    my $self = shift;

    #-alias seems to work only with Moose, not with Moo.
    #Alternative would be Sub::Exporter
    my @plugins = @_;
    foreach my $plugin (@plugins) {
        $self->debug("about to load 'MARC::Shell::Command::$plugin'");
        with "MARC::Shell::Command::$plugin" => {
            -alias => {
                run     => "run_$plugin",
                help    => "help_$plugin",
                summary => "smry_$plugin"
            },
            -excludes => [ 'run', 'help', 'summary', ]
        };
    }
}

1;
