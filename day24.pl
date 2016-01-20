#!/usr/bin/perl
#
# I tried to brute-force this, then realized each combo *had* to be the
# total weight / 3;
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 1;

my @packages = split( '\n', read_file( $ARGV[0] ) );

my $group_weight = 0;
$group_weight += $_ for (@packages);
$group_weight = $group_weight / 3;
die "Illegal package weight" unless ($group_weight == int( $group_weight ));

#
# Get the number of possible groups of packages - three groups, each with
# at least one package. The first group will have the least number of
# packages
#
sub get_pkg_counts
 {
  my $num = shift;
  my $combos;

  die unless ($num >= 3);
  for (my $i = 1; $i < $num - 3; $i++) {
    for (my $j = $i; $j < $num - $i - $j; $j++) {
      my $k = $num - $i - $j;
      push @{ $combos }, [ $i, $j, $k ];
    }
   }

  return $combos;
 }

#
# Get combos - Given a set of numbers, return the combos
#
sub get_combo_inc
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

#
# Get combos - $total C $num
#
sub get_combos
 {
  my ($total, $num) = @_;
  my $combos = [];

  for my $i (1 .. $num) {
    $combos = get_combo_inc( $combos, $total );
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

#
# Create the sets of packages for the three containers
#
sub config_packages
 {
  my ($num_packages, @config) = @_;
  my $combos;

  my $combo_1 = get_combos( $num_packages, $config[0] );
  for my $c1 (@{ $combo_1 }) {
    # Ignore combo if not the group weight. If combos go over, ignore rest
    my $weight = group_weight( $c1 );
    next if ($weight < $group_weight);
    last if ($weight > $group_weight);

    my $config = [];
    my @array = (0 .. $num_packages - 1);
    my %in_c1 = map { $_ => 1 } @{ $c1 };
    my @array_c2 = grep { !$in_c1{ $_ } } @array;
    my $combo_2 = get_combos( $num_packages - $config[0], $config[1] );
    my $c2 = [];
    my $c3 = [];
    for my $c2_index (@{ $combo_2 }) {
      # Avoid duplicates
      next if ($config[0] == $config[1] && $c1->[0] > $c2_index->[0]);

      $c2 = [ map { $array_c2[$_] } @{ $c2_index } ];
      my $weight = group_weight( $c2 );
      next if ($weight < $group_weight);
      last if ($weight > $group_weight);

      my %in_c2 = map { $_ => 1 } @{ $c2 };
	  $c3 = [ grep { !$in_c2{ $_ } } @array_c2 ];

      push @{ $combos }, [ $c1, $c2, $c3 ];
     }
   }

  return $combos;
 }

#
# Test if the containers have the same weight
#
sub check_combos
 {
  my ($packages, $combos) = @_;
  my @results;

  for my $c (@{ $combos }) {
    my @c1 = map { $packages->[ $_ ] } @{ $c->[0] };
    my $c1_wt = 0;
    $c1_wt += $_ for (@c1);
    my @c2 = map { $packages->[ $_ ] } @{ $c->[1] };
    my $c2_wt = 0;
    $c2_wt += $_ for (@c2);
    my @c3 = map { $packages->[ $_ ] } @{ $c->[2] };
    my $c3_wt = 0;
    $c3_wt += $_ for (@c3);

    if ($c1_wt == $c2_wt && $c1_wt == $c3_wt) {
      push @results, [ \@c1, \@c2, \@c3 ];
     }
   }
 
  return @results;
 }

sub smallest_qe_score
 {
  my @results = @_;

  my $min_size = @{ $results[0]->[0] };
  my $min_qe = 1000000;

  for my $r (@results) {
    last if (@{ $r->[0] } > $min_size);
    my $qe = 1;
    $qe *= $_ for (@{ $r->[0] });
    $min_qe = $qe if ($qe < $min_qe);
   }

  return $min_qe;
 }

my $num_packages = scalar @packages;

my $pkg_counts = get_pkg_counts( $num_packages );

my @results;

for my $config (@{ $pkg_counts }) {
  print "Testing ", join( ', ', @{ $config } ), "...\n";
  my $combos = config_packages( $num_packages, @{ $config } );
  push @results, check_combos( \@packages, $combos );
 }

print Dumper( @results );

print "The smallest qe is ", smallest_qe_score( @results ), "\n";

