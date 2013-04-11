use strict;
use warnings;
use Test::More tests => 1;

BEGIN {
    use_ok('MARC::Shell') || print "Bail out!\n";
}
done_testing;
#"__PACKAGE__::$VERSION"
diag(__PACKAGE__." , Perl $], $^X");
