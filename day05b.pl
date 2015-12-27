#!/usr/bin/perl
#
# $Id: pl.template,v 1.2 2014/07/18 15:01:38 caran Exp $
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $input = read_file( $ARGV[0] );
#my $input = $ARGV[0];

my $nice_strings = 0;

sub nice_string
 {
  my $str = shift;

  return unless ($str =~ /(\w\w)\w*\1/);
  return unless ($str =~ /(\w)\w\1/);

  return 1;
 }

#print "$input is ", (nice_string( $input ) ? 'nice' : 'naughty'), "\n";
#exit;

while ($input =~ /(\w+)\s*/msg) {
  my $string = $1;
  $nice_strings++ if (nice_string( $string ));
  print "$string is ", (nice_string( $string ) ? 'nice' : 'naughty'), "\n";
 }
print "There are $nice_strings strings\n";
