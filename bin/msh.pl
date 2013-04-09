#!/usr/bin/perl
use warnings;
use strict;
use MARC::Shell;

#use Data::Dumper;
#print map {"$_\n" if $_=~/MARC|Term/}keys %INC;

MARC::Shell->new->cmdloop;
