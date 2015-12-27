#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $input = read_file( $ARGV[0] );

my $nice_strings = 0;

sub nice_string
 {
  my $str = shift;

  return if ($str =~ /ab/);
  return if ($str =~ /cd/);
  return if ($str =~ /pq/);
  return if ($str =~ /xy/);
  my @vowels = ($str =~ /([aeiou])/g);
  return unless (@vowels >= 3);
  return unless ($str =~ /(\w)\1/);

  return 1;
 }

while ($input =~ /(\w+)\s*/msg) {
  my $string = $1;
  $nice_strings++ if (nice_string( $string ));
 }
print "There are $nice_strings strings\n";

