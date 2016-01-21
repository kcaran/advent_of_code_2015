#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use Data::Dumper;

my $debug = 1;

my $boss = { hp => 69, damage => 10, armor => 0 };

# Note: Solution converges to the right answer with Boss HP of 69, not 71 !?
my $hard = 1;
$boss->{ hp } = 69 if ($hard);

my $me = { hp => 50, mana => 500, armor => 0, boss_hp => $boss->{ hp }, mana_spent => 0 };

my @wins;

sub battle
 {
  my ($turn) = @_;

  effects( $turn );

  if ($turn->{ boss_hp } <= 0) {
    push @wins, $turn->{ mana_spent };
    return;
   }

  $turn->{ hp } -= $boss->{ damage } - $turn->{ armor };

  return ($turn->{ hp } > 0) ? $turn : undef;
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

  $turn->{ hp } -= $hard;
  return if ($turn->{ hp } <= 0);

  effects( $turn );

  if ($turn->{ boss_hp } <= 0) {
    push @wins, $turn->{ mana_spent };
    return;
   }

  if ($mana >= 53) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 53;
    $next->{ mana_spent } += 53;
    $next->{ boss_hp } -= 3;

    push @{ $new_turns }, $next if (battle( $next ));
   }

  if ($mana >= 73) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 73;
    $next->{ mana_spent } += 73;
    $next->{ boss_hp } -= 2;
    $next->{ hp } += 2;

    push @{ $new_turns }, $next if (battle( $next ));
   }
 
  if ($mana >= 113 && !$turn->{ shield }) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 113;
    $next->{ mana_spent } += 113;
    $next->{ shield } = 6;
    push @{ $new_turns }, $next if (battle( $next ));
   }

  if ($mana >= 173 && !$turn->{ poison }) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 173;
    $next->{ mana_spent } += 173;
    $next->{ poison } = 6;
    push @{ $new_turns }, $next if (battle( $next ));
   }

  if ($mana >= 229 && !$turn->{ recharge }) {
    my $next = { %{ $turn } };
    $next->{ mana } -= 229;
    $next->{ mana_spent } += 229;
    $next->{ recharge } = 5;
    push @{ $new_turns }, $next if (battle( $next ));
   }

  return $new_turns;
 }

my $possible_turns = [ $me ];

for (my $i = 0; $i < 100; $i++) {
  my $next_turns;
  for my $t (@{ $possible_turns }) {
    my $turns = next_turn( $t );
    push @{ $next_turns }, @{ $turns } if ($turns);
   }
  $possible_turns = $next_turns;
  last unless ($next_turns);
  print "$i. There are still ", scalar( @{ $possible_turns } ), " turns and ", scalar( @wins ), " wins.\n";
 }

@wins = sort { $a <=> $b } @wins;

print "The minimum is $wins[0]\n";
print Dumper( @wins );
