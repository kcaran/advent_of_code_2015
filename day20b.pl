#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 1;

my $max_houses = 50;

sub factor
 {
  my $num = shift;

  my @factors = (1, $num);

  my $sqrt_num = sqrt( $num );
  for (my $i = 2; $i < $sqrt_num; $i++) {
    my $multi = $num / $i;
    if ($multi == int( $multi )) {
      push @factors, $i if ($multi <= $max_houses);
      push @factors, $multi if ($i <= $max_houses);
     }
   }

  if ($sqrt_num <= $max_houses && $sqrt_num == int( $sqrt_num )) {
    push @factors, $sqrt_num;
   }

  return @factors;
 }

sub num_presents
 {
  my $num = shift;

  my $presents = 0;

  for my $p (factor( $num )) {
    $presents += $p;
   }

  return $presents * 11;
 }

sub test_presents
 {
  my ($test_num, $lower, $inc) = @_;

  my $house_num = $lower;
  my $presents = 0;
  while ($presents < $test_num) {
    $house_num += $inc;
    $presents = num_presents( $house_num );
print "For $house_num there are $presents presents\n" if ($debug);
   }

  return $house_num;
 }

my $test_num = $ARGV[0] || die "Please enter a test number\n";

my $house_num = test_presents( $test_num, 1, 1 );

print "The lowest house number with $test_num presents is $house_num\n";
