#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 1;

my ($replace, $test) = read_input();

my $grid;

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

sub find_replacements
 {
  my ($replace, $test) = @_;
  my $new_mols;

  for my $code (keys %{ $replace }) {
    while ($test =~ /$code/g) {
      my $start = $-[0];
      my $length = $+[0] - $-[0];
      for my $r (@{ $replace->{ $code } }) {
        my $new_test = $test;
        substr $new_test, $start, $length, $r;
        $new_mols->{ $new_test } = 1;
       }
     }
   }

  return $new_mols;
 }

sub make_molecule
 {
  my ($replace, $test) = @_;
  my $steps = 0;
  my $molecules = [ 'e' ];

  while (1) {
    $steps++;
    print "Now on step $steps\n" if ($debug);

    # Get a list of new molecules
    my @old_molecules = @{ $molecules };
    for my $m (@old_molecules) {
      push @{ $molecules }, keys %{ find_replacements( $replace, $m ) };
     }

    # Check for a match
    for my $m (@{ $molecules }) {
      return $steps if ($m eq $test);
     }
   }

  return;
 }

#my $new_mols = find_replacements( $replace, $test );

#print "There are ", scalar keys %{ $new_mols }, " new molecules.\n";

my $steps = make_molecule( $replace, $test );

print "It takes $steps steps to make the molecule\n";
