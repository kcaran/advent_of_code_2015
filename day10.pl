#!/usr/bin/perl
#
use strict;
use warnings;

my $debug = 0;

my $input = $ARGV[0];
my $num_times = $ARGV[1];

sub look_and_say
 {
  my $input = shift;
  my $new_input = '';
  while ($input =~ /((\d)\2*)/g) {
    $new_input .= length($1) . substr( $1, 0, 1 );
   }

  return $new_input;
 }

while ($num_times) {
  $input = look_and_say( $input );
  print "$input\n" if ($debug);
  $num_times--;
 }

print "String is now ", length( $input ), " characters long\n";
