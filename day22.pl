#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 1;

my $boss = { hp => 71, damage => 10, armor => 0 };
my $me = { hp => 50, mana => 500, armor => 0, boss_hp => $boss->{ hp } };

my @wins;

sub battle
 {
  my ($me) = @_;

  if ($me->{ boss_hp } <= 0) {
    push @wins, $me->{ mana };
    return;
   }

  $me->{ hp } -= $boss->{ damage } - $me->{ armor };

  return ($me->{ hp } > 0) ? $me : undef;
 }

sub effects
 {
  my ($me) = @_;

  $me->{ armor } = 0;

  if ($me->{ shield }) {
    $me->{ armor } = 7;
    $me->{ shield }--;
   }

  if ($me->{ poison }) {
    $me->{ boss_hp } -= 3;
    $me->{ poison }--;
   }

  if ($me->{ recharge }) {
    $me->{ mana } += 101;
    $me->{ recharge }--;
   }
 }

sub next_turn
 { 
  my $turn = shift;
  my $new_turns = [];
  
  my $mana = $turn->{ mana };

  effects( $turn );
  if ($turn->{ boss_hp } <= 0) {
    push @wins, $mana;
    return;
   }

  if ($mana >= 53) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 53;
    $next->{ boss_hp } -= 3;

    push @{ $new_turns }, $next if (battle( $next ));
   }

  if ($mana >= 73) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 73;
    $next->{ boss_hp } -= 2;
    $next->{ hp } += 2;

    push @{ $new_turns }, $next if (battle( $next ));
   }
 
  if ($mana >= 113 && !$turn->{ shield }) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 113;
    $next->{ shield } = 6;
    push @{ $new_turns }, $next if (battle( $next ));
   }

  if ($mana >= 173 && !$turn->{ poison }) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 173;
    $next->{ poison } = 6;
    push @{ $new_turns }, $next if (battle( $next ));
   }

  if ($mana >= 229 && !$turn->{ recharge }) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 229;
    $next->{ recharge } = 5;
    push @{ $new_turns }, $next if (battle( $next ));
   }

  return $new_turns;
 }

my $possible_turns = [ $me ];

for (my $i = 0; $i < 100; $i++) {
  my $next_turns;
  for my $t (@{ $possible_turns }) {
    push @{ $next_turns }, @{ next_turn( $t ) };
   }
  $possible_turns = $next_turns;
print "$i. There are still ", scalar( @{ $possible_turns } ), " turns and ", scalar( @wins ), " wins.\n";
#print "TURN $i---------\n";
#print Dumper( $possible_turns );
 }

print Dumper( @wins );
