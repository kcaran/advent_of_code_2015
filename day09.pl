#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $debug = 0;

my $input = read_file( $ARGV[0] );

my $distances;
my @cities;
my $routes;

sub calc_distance
 { 
  my $route = shift;
  my $distance = 0;

  for (my $i = 0; $i < @{ $route } - 1; $i++) {
    my $city_from = $cities[ $route->[$i] ];
    my $city_to = $cities[ $route->[$i+1] ];
    $distance += $distances->{ $city_from }{ $city_to };
   }

  return $distance;
 }

sub read_input
 {
  while ($input =~ /(\w+)\s+to\s+(\w+)\s+=\s+(\d+)\n/msg) {
    $distances->{ $1 }{ $2 } = $3;
    $distances->{ $2 }{ $1 } = $3;
   }

  @cities = keys( %{ $distances } );
 }

sub possible_routes
 {
  my (@cities) = @_;
  my $routes;

  return [ [ $cities[0] ] ] if (@cities == 1);

  for (my $i = 0; $i < @cities; $i++) {
    my @new_cities = @cities;
    my $city = splice( @new_cities, $i, 1 );
    my $new_routes = possible_routes( @new_cities );
    for my $r (@{ $new_routes }) {
      push @{ $routes }, [ $city, @{ $r } ];
     }
   }

  return $routes;
 }

sub calc_longest
 {
  my $longest = 0;

  for my $r (@{ $routes }) {
    my $d = calc_distance( $r );
    $longest = $d if ($d > $longest);
   }

  return $longest;
 }

sub calc_shortest
 {
  my $shortest = 1000000;

  for my $r (@{ $routes }) {
    my $d = calc_distance( $r );
    $shortest = $d if ($d < $shortest);
   }

  return $shortest;
 }

read_input();

$routes = possible_routes( 0 .. @cities - 1 );

my $shortest = calc_shortest( $routes );

print "The shortest distance is $shortest\n";

my $longest = calc_longest( $routes );

print "The longest distance is $longest\n";
