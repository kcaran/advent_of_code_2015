#!/usr/bin/perl
#
# I tried to brute-force this, then realized each combo *had* to be the
# total weight / 3;
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use POSIX qw( ceil );
use Data::Dumper;

my $debug = 1;

my @packages = split( '\n', read_file( $ARGV[0] ) );
my $num_containers = 3;

my $num_packages = scalar @packages;

my $group_weight = 0;
$group_weight += $_ for (@packages);
$group_weight = $group_weight / $num_containers;
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

  die unless ($num >= $num_containers);
  for (my $i = 1; $i < $num - $num_containers; $i++) {
    for (my $j = $i; $j <= $num - $i - $j; $j++) {
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

sub get_c3_packages
 {
  my ($c1, $c2) = @_;
  my $c3;

  my %in_c1 = map { $_ => 1 } @{ $c1 };
  my %in_c2 = map { $_ => 1 } @{ $c2 };
  for my $i (0 .. $num_packages - 1) {
    # Invalid if a number is in both $c1 and $c2
    return if ($in_c1{ $i } && $in_c2{ $i });
    push @{ $c3 }, $i if (!$in_c1{ $i } && !$in_c2{ $i });
   }

  return $c3;
 }

#
# Create the sets of packages for the three containers
#
sub config_packages
 {
  my ($config, $valid_combos) = @_;

  my $combos;

  for my $c1 (@{ $valid_combos->{ $config->[0] } }) {
    for my $c2 (@{ $valid_combos->{ $config->[1] } }) {
      my $c3 = get_c3_packages( $c1, $c2 );
      next unless $c3;
      push @{ $combos }, [ $c1, $c2, $c3 ];
     }
    }

  return $combos;
 }

sub smallest_qe_score
 {
  my @results = @_;

  my $min_size = @{ $results[0]->[0] };
  my $min_qe;
  my $winner;

  for my $r (@results) {
    last if (@{ $r->[0] } > $min_size);
    my $qe = 1;
    $qe *= $packages[$_] for (@{ $r->[0] });
    if (!$min_qe || $qe < $min_qe) {
      $min_qe = $qe; 
      $winner = $r;
     }

    if (@{ $r->[1] } == $min_size) {
      my $qe = 1;
      $qe *= $packages[$_] for (@{ $r->[1] });
      if (!$min_qe || $qe < $min_qe) {
        $min_qe = $qe;
        $winner = $r;
       }
     }

    if (@{ $r->[2] } == $min_size) {
      my $qe = 1;
      $qe *= $packages[$_] for (@{ $r->[2] });
      if (!$min_qe || $qe < $min_qe) {
        $min_qe = $qe;
        $winner = $r;
       }
     }
   }

  return $min_qe;
 }

my $pkg_counts = get_pkg_counts( $num_packages );

print Dumper( $pkg_counts );
die;

my $valid_combos;

# Get the combos for each number of packages that match the group weight
for my $i (2 .. ceil($num_packages / $num_containers)) {
  # Hack - I know odd numbers won't work
  next if ($i % 2);
  $valid_combos->{ $i } = count_combos( $i );
  print "$i. There are ", scalar @{ $valid_combos->{ $i } }, " valid combos\n";
 }

my @results;

my $min_pkg_size = @packages;

for my $config (@{ $pkg_counts }) {
  # Once we have the minimum package size, we don't have to go further
  last unless ($config->[0] <= $min_pkg_size);
  print "Testing ", join( ', ', @{ $config } ), "...\n";
  my $valids = config_packages( $config, $valid_combos );
  if ($valids) {
    $min_pkg_size = $config->[0];
    push @results, @{ $valids } if ($valids);
   }
 }

#print Dumper( @results );

print "The smallest qe is ", smallest_qe_score( @results ), "\n";

