#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $input = read_file( $ARGV[0] );

my $debug = 1;

sub count_chars
 {
  my $str = shift;

  print "$str => " if ($debug);
  $str =~ s/^"//;
  $str =~ s/"$//;

  # The escaped backslash has to be first!
  $str =~ s/\\\\/\*/g;
  $str =~ s/\\x[a-f0-9]{2}/-/g;
  $str =~ s/\\"/\^/g;
  print "$str\n" if ($debug);

  return length( $str );
 }

my $count = 0;
while ($input =~ /(.*?)\n/msg) {
  my $str = $1;
  my $code_cnt = length( $str );
  my $str_cnt = count_chars( $str );
  print "$code_cnt => $str_cnt\n" if ($debug);

  $count += ($code_cnt - $str_cnt);
 }

print "Total is $count\n";

