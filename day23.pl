#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 1;

my @commands = split( '\n', read_file( $ARGV[0] ) );

my $a = 1;
my $b = 0;

my $inst = {
	hlf => \&half_reg,
	tpl => \&triple_reg,
	inc => \&inc_reg,
	jmp => \&jump,
	jie => \&jump_if_even,
	jio => \&jump_if_one,
};

sub half_reg
 {
  my ($line, $args) = @_;
  if ($args eq 'a') {
    $a = int( $a / 2 );
   }
  elsif ($args eq 'b') {
    $b = int( $b / 2 );
   }
  else {
    die "Invalid argument $args to half_reg()";
   }

  return $line + 1;
 }

sub inc_reg
 {
  my ($line, $args) = @_;
  if ($args eq 'a') {
    $a += 1;
   }
  elsif ($args eq 'b') {
    $b += 1;
   }
  else {
    die "Invalid argument $args to inc_reg()";
   }

  return $line + 1;
 }

sub triple_reg
 {
  my ($line, $args) = @_;
  if ($args eq 'a') {
    $a *= 3;
   }
  elsif ($args eq 'b') {
    $b *= 3;
   }
  else {
    die "Invalid argument $args to triple_reg()";
   }

  return $line + 1;
 }

sub jump
 {
  my ($line, $args) = @_;

  return $line + $args;
 }

sub jump_if_even
 {
  my ($line, $args) = @_;
  my ($reg, $jump) = split ', ', $args;

  if ($reg eq 'a') {
    return $line + $jump unless ($a % 2);
   }
  elsif ($reg eq 'b') {
    return $line + $jump unless ($b % 2);
   }
  else {
    die "Invalid argument $args to jump_if_even()";
   }

  return $line + 1;
 }

sub jump_if_one
 {
  my ($line, $args) = @_;
  my ($reg, $jump) = split ', ', $args;

  if ($reg eq 'a') {
    return $line + $jump if ($a == 1);
   }
  elsif ($reg eq 'b') {
    return $line + $jump if ($b == 1);
   }
  else {
    die "Invalid argument $args to jump_if_odd()";
   }

  return $line + 1;
 }

my $line = 0;
while ($line < @commands) {
  my ($cmd, $args) = $commands[$line] =~ /^(\w{3})\s+(.*)$/;
  die "End execution on line $line" unless $inst->{ $cmd };

print "Executing $cmd $args, \$a = $a, \$b = $b at line $line\n";
  $line = &{ $inst->{ $cmd } }( $line, $args );
 }

print "\$a = $a, \$b = $b\n";
