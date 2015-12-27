#!/usr/bin/perl
#
# $Id: pl.template,v 1.2 2014/07/18 15:01:38 caran Exp $
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $input = read_file( $ARGV[0] );

my $grid;

sub count_lights
 {
  my ($x, $y);
  my $count = 0;
  for ($x = 0; $x <= 999; $x++) {
    for ($y = 0; $y <= 999; $y++) {
      $count++ if ($grid->[$x][$y]);
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
      $grid->[$x][$y] = 1 if ($on);
      $grid->[$x][$y] = 0 if ($off);
      $grid->[$x][$y] = ($grid->[$x][$y] ? 0 : 1) if ($toggle);
     }
   }

  return;
 }

while ($input =~ /(\D+)(\d+),(\d+) through (\d+),(\d+)\n/msg) {
  my ($cmd, $x1, $y1, $x2, $y2) = ($1, $2, $3, $4, $5);
  set_grid( $cmd, $x1, $y1, $x2, $y2 );
 }

print "There are ", count_lights(), " lights lit\n";

