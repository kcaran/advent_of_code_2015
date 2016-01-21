#!/usr/bin/perl
#
# I tried to brute-force this, then realized each combo *had* to be the
# total weight / 3;
#
use strict;
use warnings;

use File::Slurp;
use Data::Dumper;

my $codes;

my $max = 6;

my $initial = 20151125;
my $multiplier = 252533;
my $divisor = 33554393;

my $code_row = 2981;
my $code_column = 3075;

# I'm having a difficult time getting this 0-based, so use 1-based and subtract
my $i = $initial;
$codes->[0][0] = $initial;

my $interval = 2;
my $found = 0;
while (!$found) {
  for my $column (1 .. $interval) {
    $i = ($i * $multiplier) % $divisor;
    my $row = $interval - $column + 1;
    if (($row == $code_row) && ($column == $code_column)) {
      $found = $i;
      last;
     }
   }
  $interval++;
 }

print "The code is $found\n";
