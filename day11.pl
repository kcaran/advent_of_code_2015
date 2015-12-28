#!/usr/bin/perl
#
use strict;
use warnings;

my $debug = 0;

my $input = $ARGV[0];
my $inc_char = length( $input ) - 1;

my @straights;
for my $l ('a' .. 'x') {
   my $l1 = $l++;
   my $l2 = $l++;
   push (@straights, "${l1}${l2}$l");
  }
my $straight_regex = join( '|', @straights );

sub check_password
 {
  my $password = shift;

  # Don't allow i, o, or l
  return if ($password =~ /[iol]/);

  return unless ($password =~ /(\w)/);

  return unless ($password =~ /$straight_regex/o);

  return unless ($password =~ /(\w)\1(?:.*?)([^\1])\2/);

  return 1;
 }

sub inc_password
 {
  my ($password, $place) = @_;

  $place = length( $password ) - 1 unless ($place);

  my $char = substr( $password, $place, 1 );
  if ($char eq 'z') {
    substr( $password, $place, 1 ) = 'a';
    return inc_password( $password, $place - 1 );
   }

  substr( $password, $place, 1 ) = ++$char;

  return $password;
 }

while (1) {
  $input = inc_password( $input );
  if (check_password( $input )) {
    print "The new password is $input\n";
    exit;
   }
 }
