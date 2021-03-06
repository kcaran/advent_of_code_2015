#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $input = read_file( $ARGV[0] );

my $grid;

sub count_brightness
 {
  my ($x, $y);
  my $count = 0;
  for ($x = 0; $x <= 999; $x++) {
    for ($y = 0; $y <= 999; $y++) {
      $count += ($grid->[$x][$y]) if ($grid->[$x][$y]);
     }
   }

  return $count;
 }

sub set_grid
 {
  my ($cmd, $x1, $y1, $x2, $y2) = @_;

  my $on = ($cmd =~ /turn on/);
  my $off = ($cmd =~ /turn off/);
  my $toggle = ($cmd =~ /toggle/);

  my ($x, $y);
  for ($x = $x1; $x <= $x2; $x++) {
    for ($y = $y1; $y <= $y2; $y++) {
      $grid->[$x][$y] ||= 0;
      $grid->[$x][$y]++ if ($on);
      $grid->[$x][$y]-- if ($off && $grid->[$x][$y]);
      $grid->[$x][$y] += 2 if ($toggle);
     }
   }

  return;
 }

while ($input =~ /(\D+)(\d+),(\d+) through (\d+),(\d+)\n/msg) {
  my ($cmd, $x1, $y1, $x2, $y2) = ($1, $2, $3, $4, $5);
  set_grid( $cmd, $x1, $y1, $x2, $y2 );
 }

print "There is ", count_brightness(), " brightness\n";

