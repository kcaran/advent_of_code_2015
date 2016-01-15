#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 0;

my $input = read_file( $ARGV[0] );
my $race_time = $ARGV[1] || 1000;

my $entrants;

sub read_input
 {
  my $input = shift;

  while ($input =~ /(\w+)\scan fly\s(\d+)\skm\/s for (\d+)(?:.*?)(\d+)\sseconds\.\n/msg) {
    my $r = {
      velocity => $2,
      v_time => $3,
      r_time => $4,
      distance => 0,
      duration => 0,
      rest => 0,
    };
    $entrants->{ $1 } = $r;
   }
 }

sub advance_reindeer
 {
  my $r = shift;

  # Check if reindeer is resting
  if ($r->{ rest }) {
    $r->{ rest }--;
    return;
   }

  # Advance reindeer
  $r->{ distance } += $r->{ velocity };
  $r->{ duration }++;

  # Check if reindeer is tired
  if ($r->{ duration } == $r->{ v_time }) {
    $r->{ duration } = 0;
    $r->{ rest } = $r->{ r_time };
   }
 }

sub go_one_second
 {
  my $entrants = shift;

  for my $reindeer (keys %{ $entrants }) {
    advance_reindeer( $entrants->{ $reindeer } );
   }

  check_points( $entrants );
 }

sub check_points
 {
  my $entrants = shift;
  my $distance = 0;
  my @leaders = ();

  for my $reindeer (keys %{ $entrants }) {
    my $r_dist = $entrants->{ $reindeer }{ distance };
    if ($distance == $r_dist) {
      push @leaders, $reindeer;
     }
    if ($distance < $r_dist) {
      # Reset leading distance
      $distance = $r_dist;
      @leaders = ( $reindeer );
     }
   }

  for my $reindeer (@leaders) {
    $entrants->{ $reindeer }{ points }++;
   }
 }

sub check_points_leader
 {
  my $entrants = shift;

  my $points = 0;
  my $leader;
  for my $reindeer (keys %{ $entrants }) {
    my $r_points = $entrants->{ $reindeer }{ points } || 0;
    if ($points < $r_points) {
      $leader = $reindeer;
      $points = $r_points;
     }
   }

  return $leader;
 }

sub check_winner
 {
  my $entrants = shift;

  my $distance = 0;
  my $winner;
  for my $reindeer (keys %{ $entrants }) {
    my $r_dist = $entrants->{ $reindeer }{ distance };
    if ($distance < $r_dist) {
      $winner = $reindeer;
      $distance = $r_dist;
     }
   }

  return $winner;
 }

read_input( $input );

for (my $i = 0; $i < $race_time; $i++) {
  go_one_second( $entrants );
 }

my $winner = check_winner( $entrants );

print "The winner is $winner going $entrants->{ $winner }{ distance }km.\n";

my $leader = check_points_leader( $entrants );

print "The points leader is $leader with $entrants->{ $leader }{ points } points.\n";

#print Dumper( $entrants );
