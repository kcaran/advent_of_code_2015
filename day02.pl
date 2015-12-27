#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $input = read_file( $ARGV[0] );

my $paper = 0;

sub box_surface
 {
  my ($l, $w, $h) = @_;
  return 2 * $l * $w + 2 * $w * $h + 2 * $h * $l;
 }

sub box_slack
 {
  my ($l, $w, $h) = @_;

  return min( $l * $w, $l * $h, $w * $h );
 }

while ($input =~ /(\d+)x(\d+)x(\d+)\s*/msg) {
  my $length = $1;
  my $width = $2;
  my $height = $3;
  print "$length x $width x $height\n";
  $paper += box_surface( $length, $width, $height );
  $paper += box_slack( $length, $width, $height );
 }

print "The elves need $paper square feet.\n";
