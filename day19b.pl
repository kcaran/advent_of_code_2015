#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 0;

my ($replace, $test) = read_input();

sub read_input
 {
  my $replace;
  my $test;

  my @lines = split( '\n', read_file( $ARGV[0] ) );

  $test = pop @lines;
  pop @lines;

  for my $line (@lines) {
    my ($code, $rep) = ($line =~ /^(\w+)\s*\=\>\s*(\w+)$/);
    push @{ $replace->{ $code } }, $rep;
   }

  return ($replace, $test);
 }

sub invert_replace
 {
  my $replace = shift;

  my $invert;

  for my $code (keys %{ $replace }) {
    for my $rep (@{ $replace->{ $code } }) {
      push @{ $invert->{ $rep } }, $code;
     }
   }

  return $invert;
 }

sub make_molecule
 {
  my ($replace, $test) = @_;
  my $invert = invert_replace( $replace );
  my $steps = 0;
  my $old_steps = -1;
  my $has_e;

  # Make sure it converges
  while ($test ne 'e' && $old_steps != $steps) {
    $old_steps = $steps;
print "String is $test in $steps steps\n";
    # Try matching the longest molecules before the shortest
    for my $code (sort { length( $b ) <=> length( $a ) } keys %{ $invert }) {
      for my $rep (@{ $invert->{ $code } }) {
        while ($test =~ /$code/g) {        
          # Don't use the e until the end
          #next if ($rep eq 'e');
          my $start = $-[0];
          my $length = $+[0] - $-[0];
          substr $test, $start, $length, $rep;
          $steps++;
         }
       }
     }
   }

  return $steps;
 }

my $steps = make_molecule( $replace, $test );

print "It takes $steps steps to make the molecule\n";
