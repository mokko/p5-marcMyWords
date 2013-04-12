#ABSTRACT: Reload myself
package MARC::Shell::Command::reload;
use strict;
use warnings;
use Moo::Role;

#use Try::Tiny;

sub summary { 'Reloading msh.pl' }

sub help {
    <<'END';
reload myself
END
}

sub run {
    my $self = shift;
    print "reloading...\n";
    exec( $^X, '-Ilib', $0, @{ $self->{conf}{argv_orig} } )
      ;

}

1;
