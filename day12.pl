#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;

my $input = read_file( $ARGV[0] );

sub strip_object
 {
  my ($input, $found_idx) = @_;

  my $pre_cnt = 0;
  my $pre_idx = $found_idx - 1;
  while ($pre_cnt >= 0) {
    my $char = substr( $input, $pre_idx, 1 );
    $pre_cnt++ if ($char eq '}');
    $pre_cnt-- if ($char eq '{');
    $pre_idx--;
   }

  my $post_cnt = 0;
  my $post_idx = $found_idx + 1;
  while ($post_cnt >= 0) {
    my $char = substr( $input, $post_idx, 1 );
    $post_cnt++ if ($char eq '{');
    $post_cnt-- if ($char eq '}');
    $post_idx++;
   }

  # The pre-index is actually one less, and the post-index is one more
  print substr( $input, $pre_idx + 1, $post_idx - $pre_idx ), "\n";

  substr( $input, $pre_idx + 1, $post_idx - $pre_idx ) = '';
  return $input;
 }

sub ignore_red
 {
  my $input = shift;
  my $found_idx = index $input, ':"red"';
  if ($found_idx >= 0) {
    $input = strip_object( $input, $found_idx );
    return ignore_red( $input );
   }

  return $input;
 }

$input = ignore_red( $input );
print "$input\n";

my $sum = 0;
while ($input =~ /(-*\d+)/msg) {
  $sum += $1;
 }

print "The sum is $sum\n";
