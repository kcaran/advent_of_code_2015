#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 1;

my $store = {
    weapons => {
		dagger => { cost => 8, damage => 4, armor => 0 },
		shortsword => { cost => 10, damage => 5, armor => 0 },
		warhammer => { cost => 25, damage => 6, armor => 0 },
		longsword => { cost => 40, damage => 7, armor => 0 },
		greataxe => { cost => 74, damage => 8, armor => 0 },
    },
    armor => {
		leather => { cost => 13, damage => 0, armor => 1 },
		chainmail => { cost => 31, damage => 0, armor => 2 },
		splintmail => { cost => 53, damage => 0, armor => 3 },
		bandedmail => { cost => 75, damage => 0, armor => 4 },
		platemail => { cost => 102, damage => 0, armor => 5 },
    },
    rings => {
		damage_1 => { cost => 25, damage => 1, armor => 0 },
		damage_2 => { cost => 50, damage => 2, armor => 0 },
		damage_3 => { cost => 100, damage => 3, armor => 0 },
		defense_1 => { cost => 20, damage => 0, armor => 1 },
		defense_2 => { cost => 40, damage => 0, armor => 2 },
		defense_3 => { cost => 80, damage => 0, armor => 3 },
    },
};

my $boss = { hp => 109, damage => 8, armor => 2 };

sub battle
 {
  my ($me, $boss) = @_;

  my $me_hp = $me->{ hp };
  my $boss_hp = $boss->{ hp };
  while (1) {
    $boss_hp -= $me->{ damage } - $boss->{ armor };
    return 1 if ($boss_hp <= 0);
    $me_hp -= $boss->{ damage } - $me->{ armor };
    return -1 if ($me_hp <= 0);
   }
 }

sub ring_combos
 {
  my @r = keys $store->{ rings };
  my @combos = ();
  
  for (my $i = 0; $i < @r - 1; $i++) {
    for (my $j = $i + 1; $j < @r; $j++) {
      push @combos, [ $store->{ rings }{ $r[$i] }, $store->{ rings }{ $r[$j] } ];
     }
   }

  return @combos;
 }

sub add_inventory
 {
  my @items = @_;

  my $cost = 0;
  my $damage = 0;
  my $armor = 0;

  for my $i (@items) {
    $cost += $i->{ cost };
    $damage += $i->{ damage };
    $armor += $i->{ armor };
   }

  return { cost => $cost, damage => $damage, armor => $armor };
 }

sub create_inventories
 {
  my @w = keys $store->{ weapons };
  my @a = keys $store->{ armor };
  my @r = keys $store->{ rings };
  my @combos = ring_combos();
  my $inventories = [];
 
  for my $w (@w) {
    # Only the weapon
    my $weapon = $store->{ weapons }{ $w };
    push @{ $inventories }, add_inventory( $weapon );

    for my $a (@a) {
      # No rings
      my $armor = $store->{ armor }{ $a };
      push @{ $inventories }, add_inventory( $weapon, $armor );

      # Each ring
      for my $r (@r) {
        my $ring = $store->{ rings }{ $r };
        push @{ $inventories }, add_inventory( $weapon, $armor, $ring );
       }

      # Each combo
      for my $c (@combos) {
        push @{ $inventories }, add_inventory( $weapon, $armor, @{ $c } );
       }
     }

    for my $r (@r) {
      my $ring = $store->{ rings }{ $r };
      push @{ $inventories }, add_inventory( $weapon, $ring );
     }

    for my $c (@combos) {
      push @{ $inventories }, add_inventory( $weapon, @{ $c } );
     }
   }

  return $inventories;
 }

my $inventories = [ sort { $a->{ cost } <=> $b->{ cost } } @{ create_inventories() } ];

for my $inv (@{ $inventories }) {
  $inv->{ hp } = 100;
  if (battle( $inv, $boss ) > 0) {
    print "The minimum gold is $inv->{ cost }\n";
    last;
   }
 }

for my $inv (reverse @{ $inventories }) {
  $inv->{ hp } = 100;
  if (battle( $inv, $boss ) < 0) {
    print "The maximum gold to lose is $inv->{ cost }\n";
    last;
   }
 }
