#!/usr/bin/perl
#
use strict;
use warnings;

use Digest::MD5 qw( md5_hex );

my $key = $ARGV[0];

print md5_hex( $key . '609043' );

sub check_md5
 {
  my $answer = shift;

  return md5_hex( $key . $answer ) =~ /^000000/;
 }

my $answer = 0;

while (1) {
  die "The answer is $answer\n" if (check_md5( $answer ));
  $answer++;
 }
