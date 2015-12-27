#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $input = read_file( $ARGV[0] );

my $paper = 0;

sub ribbon_len
 {
  my ($l, $w, $h) = @_;

  return min( 2 * ($l + $w), 2 * ($w + $h), 2 * ($h + $l) );
 }

sub ribbon_bow
 {
  my ($l, $w, $h) = @_;

  return $l * $w * $h;
 }

while ($input =~ /(\d+)x(\d+)x(\d+)\s*/msg) {
  my $length = $1;
  my $width = $2;
  my $height = $3;
  print "$length x $width x $height\n";
  $paper += ribbon_len( $length, $width, $height );
  $paper += ribbon_bow( $length, $width, $height );
 }

print "The elves need $paper feet.\n";
