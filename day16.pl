#!/usr/bin/perl
#
use strict;
use warnings;

use File::Slurp;
use List::Util qw( min );
use Data::Dumper;

my $debug = 0;

my %test = (
	children => { comp => '=', val => 3 },
	cats => { comp => '>', val => 7 },
	samoyeds => { comp => '=', val => 2 },
	pomeranians => { comp => '<', val => 3 },
	akitas => { comp => '=', val => 0 },
	vizslas => { comp => '=', val => 0 },
	goldfish => { comp => '<', val => 5 },
	trees => { comp => '>', val => 3 },
	cars => { comp => '=', val => 2 },
	perfumes => { comp => '=', val => 1 },
);

my $input = read_file( $ARGV[0] );

sub read_input
 {
  my $input = shift;
  my $properties;

  while ($input =~ /^Sue (\d+):\s*(.*?)\n/msg) {
    my $num = $1;
    for (split( /\s*,\s*/, $2)) {
      my ($prop, $value) = /(\w+):\s*([0-9-]+)/;
      $properties->{ $num }{ $prop } = $value;
     }
   }

  return $properties;
 }

sub check_sue
 {
  my $sue = shift;

  for my $prop (keys{ %test }) {
    next unless defined( $sue->{ $prop } );
    my $comp = $test{ $prop }->{ comp };
    if ($comp eq '=') {
      return unless ($sue->{ $prop } == $test{ $prop }->{ val });
     }
    elsif ($comp eq '>') {
      return unless ($sue->{ $prop } > $test{ $prop }->{ val });
     }
    elsif ($comp eq '<') {
      return unless ($sue->{ $prop } < $test{ $prop }->{ val });
     }
   }

  return 1;
 }

my $sue_list = read_input( $input );

for my $sue (keys %{ $sue_list }) {
  if (check_sue( $sue_list->{ $sue } )) {
    die "It was Aunt Sue $sue\n";
   }
 }

print Dumper( $sue_list );
