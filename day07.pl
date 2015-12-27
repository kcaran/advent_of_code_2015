#!/usr/bin/perl
#
# $Id: pl.template,v 1.2 2014/07/18 15:01:38 caran Exp $
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $input = read_file( $ARGV[0] );

my %wires;

sub input_value
 {
  my $in = shift;

  # We must force values to be integers, not strings
  return int( $in ) if ($in =~ /^\d+$/);
  return int( $wires{ $in } || 0 ) if ($in =~ /^[a-z]+$/);
  die "Bad input: $in";
 }

sub one_input
 {
  my ($input, $output) = @_;

  my $in = $input->[0];

  $wires{ $output } = input_value( $in );

  return;
 }

sub two_input
 {
  my ($input, $output) = @_;

  die "Bad input: @{ $input } -> $output" unless ($input->[0] eq 'NOT');

  my $in = $input->[1];
  $wires{ $output } = ~( input_value( $in ) ) & 0xffff;

  return;
 }

sub three_input
 {
  my ($input, $output) = @_;

  my ($x, $cmd, $y) = @{ $input };

  $x = input_value( $x );
  $y = input_value( $y );

  if ($cmd eq 'AND') {
    $wires{ $output } = ($x & $y);
   }
  elsif ($cmd eq 'OR') {
    $wires{ $output } = ($x | $y);
   }
  elsif ($cmd eq 'LSHIFT') {
    $wires{ $output } = ($x << $y) & 0xffff;
   }
  elsif ($cmd eq 'RSHIFT') {
    $wires{ $output } = ($x >> $y);
   }
  else {
    die "Bad circuit @{ $input } -> $output";
   }
 }

sub parse_circuit
 {
  my ($input, $output) = @_;

  one_input( $input, $output ) if (@{ $input } == 1);
  two_input( $input, $output ) if (@{ $input } == 2);
  three_input( $input, $output ) if (@{ $input } == 3);
 }

sub debug
 {
  my ($input, $output) = @_;
  print "@{ $input } -> $output\n";
  for my $wire (sort keys %wires) {
    print "$wire: $wires{ $wire }\n";
   }
 }

while ($input =~ /(.*?)\s+\-\>\s+(.*?)\s*\n/msg) {
  my $output = $2;
  my @input = split( /\s+/, $1 );
  parse_circuit( \@input, $output );
  debug( \@input, $output );
 }

for my $wire (sort keys %wires) {
  print "$wire: $wires{ $wire }\n";
 }
