#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $debug = 0;

my $input = read_file( $ARGV[0] );

my $sitting;
my @guests;
my $charts;

sub add_me
 {
  my $sitting = shift;

  for my $guest (keys %{ $sitting }) {
    $sitting->{ $guest }{ me } = 0;
    $sitting->{ me }{ $guest } = 0;
   }
 }

sub read_input
 {
  while ($input =~ /(\w+)\swould\s(\w+)\s(\d+)(?:.*?)\s(\w+)\.\n/msg) {
    my ($name, $units, $other) = ($1, $3, $4);
    $units = -$units if ($2 eq 'lose');

    $sitting->{ $name }{ $other } = $units;
   }

  # This is part B
  add_me( $sitting );

  @guests = sort keys %{ $sitting };
 }

sub create_charts
 {
  my (@charts) = @_;
  my $seating;

  return [ [ $charts[0] ] ] if (@charts == 1);

  for (my $i = 0; $i < @charts; $i++) {
    my @new_charts = @charts;
    my $chart = splice( @new_charts, $i, 1 );
    my $new_seating = create_charts( @new_charts );
    for my $r (@{ $new_seating }) {
      push @{ $seating }, [ $chart, @{ $r } ];
     }
   }

  return $seating;
 }

sub calc_happiness
 { 
  my $chart = shift;
  my $happiness = 0;

  my $num_guests = @{ $chart };
  for (my $i = 0; $i < $num_guests; $i++) {
    my $name = @guests[ $chart->[$i] ];
    my $other = @guests[ $chart->[ ($i + 1) % $num_guests ] ];
    $happiness += $sitting->{ $name }{ $other };
    
    my $left = $i ? $i - 1 : $num_guests - 1;
    $other = @guests[ $chart->[ $left ] ];
    $happiness += $sitting->{ $name }{ $other };
   }

  return $happiness;
 }

sub calc_largest
 {
  my $largest = 0;

  for my $r (@{ $charts }) {
    my $d = calc_happiness( $r );
    $largest = $d if ($d > $largest);
    print "$d: @{ $r }\n" if ($d == $largest);
   }

  return $largest;
 }

=cut
sub calc_shortest
 {
  my $shortest = 1000000;

  for my $r (@{ $routes }) {
    my $d = calc_distance( $r );
    $shortest = $d if ($d < $shortest);
   }

  return $shortest;
 }

=cut
read_input();

#
# To avoid duplicates, get all of the seating arrangements for one less
# guest, then add 0 to the start of the array. Note that adding it to
# the end probably makes more sense.
#
$charts = create_charts( 1 .. @guests - 1 );

for (my $i = 0; $i < @{ $charts }; $i++) {
  unshift @{ $charts->[$i] }, 0;
 }

=cut
my $shortest = calc_shortest( $routes );

print "The shortest distance is $shortest\n";
=cut

my $largest = calc_largest( $charts );

print "The largest happiness is $largest\n";

print "Done\n";
