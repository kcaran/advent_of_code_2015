#!/usr/bin/perl
#
# For part two, I totally cheated and assumed that every legal combination
# could actually be used - I'm not sure if that is correct.
#
use strict;
use warnings;

use File::Slurp;
use Data::Dumper;

my $debug = 1;

my @packages = split( '\n', read_file( $ARGV[0] ) );
my $num_containers = 4;

my $num_packages = scalar @packages;

my $group_weight = 0;
$group_weight += $_ for (@packages);
$group_weight = $group_weight / $num_containers;
die "Illegal package weight" unless ($group_weight == int( $group_weight ));

#
# Get combos - Given a set of numbers, return the combos
#
sub get_combo_inc
 {
  my ($combos, $total, $exact) = @_;
  my $new_combos = [];

  # Return an array of single-element arrays - one for each number
  return [ map { [ $_ ] } (0 .. $total - 1) ] if (@{ $combos } == 0);

  for my $i (0 .. $total - 1) {
    for my $c (@{ $combos }) {
      # Only need to add numbers smaller than the smallest in the set
      next if ($i >= $c->[0]);
      my $combo = [ $i, @{ $c } ];
      my $weight = group_weight( $combo );
      if (($exact && $weight == $group_weight)
       || (!$exact && $weight <= $group_weight)) {
        push @{ $new_combos }, $combo;
       }
     }
   }

  return $new_combos;
 }

sub count_combos
 {
  my ($num) = @_;
  my $combos = [];
  for my $i (1 .. $num) {
    $combos = get_combo_inc( $combos, $num_packages, $i == $num );
   }

  return $combos;
 }

sub group_weight
 {
  my $combo = shift;

  my $weight = 0;

  $weight += $packages[$_] for (@{ $combo });

  return $weight;
 }

sub smallest_qe_combo
 {
  my ($combos) = @_;

  my $min_qe;

  for my $r (@{ $combos }) {
    my $qe = 1;
    $qe *= $packages[$_] for (@{ $r });
    if (!$min_qe || $qe < $min_qe) {
      $min_qe = $qe; 
     }
   }

  return $min_qe;
 }

#
# Iterate through the package size until we find valid ones
#
my $i = 2;
while (1) {
  my $valid_combos = count_combos( $i );
  if (@{ $valid_combos }) {
    print "The smallest qe is ", smallest_qe_combo( $valid_combos ), "\n";
    exit;
   }
  $i++;
 }

