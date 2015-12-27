#!/usr/bin/perl
#
# $Id: pl.template,v 1.2 2014/07/18 15:01:38 caran Exp $
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

#my $input = read_file( $ARGV[0] );
my $input = $ARGV[0];

my %grid;

my $move_santa = 1;
my $coords = [ [ 0, 0 ], [ 0, 0 ] ];

sub santa_move
 {
  my $move = shift || '';

  # For robo-santa
  $move_santa = ($move_santa + 1) % 2;

  $coords->[ $move_santa ][0]++ if ($move eq '>');
  $coords->[ $move_santa ][0]-- if ($move eq '<');
  $coords->[ $move_santa ][1]++ if ($move eq '^');
  $coords->[ $move_santa ][1]-- if ($move eq 'v');

  return "$coords->[$move_santa][0],$coords->[$move_santa][1]";
 }

# Go to first home
$grid{ santa_move() }++;

while ($input =~ /(.)/msg) {
  my $move = $1;
  my $next_coord = santa_move( $move );
  $grid{ $next_coord }++;
 }

print "Santa visited ", scalar keys %grid, " homes\n";
