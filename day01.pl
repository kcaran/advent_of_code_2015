#!/usr/bin/perl
#
# $Id: pl.template,v 1.2 2014/07/18 15:01:38 caran Exp $
#
use strict;
use warnings;

use File::Slurp;

my $floor = 0;

#
# perl day01.pl $(cat input01.txt)
#
my $input = $ARGV[0];

my $count = 0;
while ($input =~ /(.)/g) {
  my $char = $1;
  $count++;
  $floor++ if ($char eq '(');
  $floor-- if ($char eq ')');
  #die "We are in the basement at character $count\n" if ($floor < 0);
 }

print "We are now on $floor floor\n";

