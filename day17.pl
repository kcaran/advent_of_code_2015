#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 0;

my $amount = 150;

my @containers = split( '\n', read_file( $ARGV[0] ) );
my $num_containers = @containers;

sub check_for_fits
 {
  my ($combos) = @_;
  my $fits = 0;

  for my $c (@{ $combos }) {
    my $total = 0;
    for my $container_num (@{ $c }) {
      $total += $containers[$container_num];
     }
    $fits++ if ($total == $amount);
   }

  return $fits;
 }

sub get_combos
 {
  my ($combos, $total) = @_;
  my $new_combos = [];

  # Return an array of single-element arrays - one for each number
  return [ map { [ $_ ] } (0 .. $total - 1) ] if (@{ $combos } == 0);

  for my $i (0 .. $total - 1) {
    for my $c (@{ $combos }) {
      # Only need to add numbers smaller than the smallest in the set
      next if ($i >= $c->[0]);
      push @{ $new_combos }, [ $i, @{ $c } ];
     }
   }

  return $new_combos;
 }

my $combos = [];
my $fits = 0;
my $min_containers_fits = 0;
for my $count (1 .. $num_containers) {
  $combos = get_combos( $combos, $num_containers );
  my $combos_fits = check_for_fits( $combos );
  $min_containers_fits = $combos_fits if ($combos_fits && !$fits);
  $fits += $combos_fits;
 }

print "The number of fits for the minimum is $min_containers_fits\n";
print "The number of fits is $fits\n";
