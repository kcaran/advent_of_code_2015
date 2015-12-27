#!/usr/bin/perl
#
# $Id: pl.template,v 1.2 2014/07/18 15:01:38 caran Exp $
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );

my $input = read_file( $ARGV[0] );

my $debug = 1;

sub escape_chars
 {
  my $str = shift;

  print "$str => " if ($debug);
  $str =~ s/\\/\\\\/g;
  $str =~ s/"/\\"/g;
  $str = qq|"$str"|;
  print "$str\n" if ($debug);

  return length( $str );
 }

my $count = 0;
while ($input =~ /(.*?)\n/msg) {
  my $str = $1;
  my $code_cnt = length( $str );
  my $str_cnt = escape_chars( $str );
  print "$code_cnt => $str_cnt\n" if ($debug);

  $count += ($str_cnt - $code_cnt);
 }

print "Total is $count\n";

