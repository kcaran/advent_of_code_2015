#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 0;

my $input = read_file( $ARGV[0] );

sub read_input
 {
  my $input = shift;
  my $properties;

  while ($input =~ /^(\w+)\s*:\s*(.*?)\n/msg) {
    my $i = $1;
    for (split( /\s*,\s*/, $2)) {
      my ($prop, $value) = /(\w+)\s*([0-9-]+)/;
      $properties->{ $i }{ $prop } = $value;
     }
   }

  return $properties;
 }

sub calc_amounts
 {
  my ($ingredients, $amount) = @_;
  my $recipe;

  return [ [$amount] ] if (@{ $ingredients } == 1);
  for (my $i = 0; $i < @{ $ingredients } - 1; $i++) {
    my @new_ingredients = @{ $ingredients };
    my $ingredient = shift( @new_ingredients );
    for (my $amt = 0; $amt <= $amount; $amt++) {
      my $new_recipe = calc_amounts( \@new_ingredients, $amount - $amt );
      for my $r (@{ $new_recipe }) {
        push @{ $recipe }, [ $amt, @{ $r } ];
       }
     }
   }

  return $recipe;
 }
 
sub property_total
 {
  my ($properties, $prop, $amount) = @_;
  my $total = 0;
  
  my @ingredients = keys( %{ $properties } );
  
  for (my $i = 0; $i < @ingredients; $i++) {
    $total += $properties->{ $ingredients[$i] }{ $prop } * $amount->[$i];
   }

  return ($total > 0) ? $total : 0;
 }

sub recipe_score
 {
  my ($properties, $prop_names, $amount) = @_;
  my $score = 1;

  # Restrict to exactly 500 calories - Part II
  my $calories = property_total( $properties, 'calories', $amount );
  return 0 unless ($calories == 500);

  for my $prop (@{ $prop_names }) {
    next if ($prop eq 'calories');
    $score *= property_total( $properties, $prop, $amount );
   }

  # Don't return a negative score
  return $score;
 }

sub best_recipe
 { 
  my ($ingredients, $properties, $amounts) = @_;
  my $best = 0;
  
  my @prop_names = keys %{ $properties->{ $ingredients->[0] } };
  for my $amt (@{ $amounts }) {
    my $score = recipe_score( $properties, \@prop_names, $amt );
    $best = $score if ($best < $score);
   }

  return $best;
 }

my $properties = read_input( $input );
my @ingredients = keys( %{ $properties } );
my $amounts = calc_amounts( \@ingredients, 100 );

my $best = best_recipe( \@ingredients, $properties, $amounts );

print Dumper( $best );
