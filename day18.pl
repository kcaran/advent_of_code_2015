#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 0;

my @containers = split( '\n', read_file( $ARGV[0] ) );

my $grid;

sub get_initial_state
 {
  my $grid;

  for my $text_row (split( '\n', read_file( $ARGV[0] ) )) {
    $text_row =~ s/\#/1/g;
    $text_row =~ s/\./0/g;
    my $row = [ split( '', $text_row ) ];
    push @{ $grid }, $row;
   }

  return $grid;
 }

sub neighbor_count
 {
  my ($grid, $row, $col) = @_;

  my $grid_row_size = @{ $grid };
  my $grid_col_size = @{ $grid->[0] };

  # Get neighbor min/max row and columns
  my $min_row = $row > 0 ? $row - 1 : 0;
  my $min_col = $col > 0 ? $col - 1 : 0;
  my $max_row = $row < $grid_row_size - 2 ? $row + 1 : $grid_row_size - 1;
  my $max_col = $col < $grid_col_size - 2 ? $col + 1 : $grid_col_size - 1;

  my $cnt = 0;
  for my $r ($min_row .. $max_row) {
    for my $c ($min_col .. $max_col) {
      # Ignore ourself
      next if ($r == $row) && ($c == $col);
      $cnt += $grid->[$r][$c];
     }
   }

  return $cnt;
 }

sub next_step
 {
  my $grid = shift;
  my $state;

  # First, get neighbor states
  for (my $row = 0; $row < @{ $grid }; $row++) {
    for (my $col = 0; $col < @{ $grid->[$row] }; $col++) {
      $state->[$row][$col] = neighbor_count( $grid, $row, $col );
     }
   }

  # Now, update grid
  for (my $row = 0; $row < @{ $grid }; $row++) {
    for (my $col = 0; $col < @{ $grid->[$row] }; $col++) {
      my $cnt = $state->[$row][$col];

      if ($grid->[$row][$col]) {
        # Light stays on if 2 or 3 neighbors are on
        $grid->[$row][$col] = ($cnt == 2 || $cnt == 3) ? 1 : 0;
       }
      else {
        # Light stays off unless 3 neighbors are on
        $grid->[$row][$col] = ($cnt == 3) ? 1 : 0;
       }

      # Part II - corner lights always stuck on
      if (($row == 0 || $row == @{ $grid } - 1)
       && ($col == 0 || $col == @{ $grid->[$row] } - 1)) {
        $grid->[$row][$col] = 1;
       }

     }
   }

  return;
 }

sub count_lights
 {
  my $grid = shift;
  my $cnt;

  for (my $row = 0; $row < @{ $grid }; $row++) {
    for (my $col = 0; $col < @{ $grid->[$row] }; $col++) {
      $cnt += $grid->[$row][$col];
     }
   }

  return $cnt;
 }


sub stuck_lights
 {
  my $grid = shift;

  my $grid_row_size = @{ $grid };
  my $grid_col_size = @{ $grid->[0] };

  $grid->[0][0] = 1;
  $grid->[0][$grid_col_size - 1] = 1;
  $grid->[$grid_row_size - 1][0] = 1;
  $grid->[$grid_row_size - 1][$grid_col_size - 1] = 1;

  return;
 }

$grid = get_initial_state();

# Part II - stuck_lights
stuck_lights( $grid );

my $num_steps = $ARGV[1] || 100;

for my $i (1 .. $num_steps) {
  next_step( $grid );
 }

print "There are ", count_lights( $grid ), " lights on.\n";
