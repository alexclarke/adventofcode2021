#!/usr/bin/perl

use strict;
use Data::Dumper;
use experimental 'smartmatch';
use Storable qw(dclone);

my %nodes = ();

while (<>) {
	chomp;
	
	for (split '', $_) {
		my ($location, $connection) = split('-', $_);
		if ($nodes{$location}) {
			push @{$nodes{$location}}, $connection;
		} else {
			$nodes{$location} =  [$connection];
		}
		if ($nodes{$connection}) {
			push @{$nodes{$connection}}, $location;
		} else {
			$nodes{$connection} =  [$location];
		}
	}
}

print Dumper(\%nodes);

my %vertexes = {};
my %paths = {};

visit("start", [], {}, undef, 0);

sub visit {
	my ($node, $previous, $travelled, $small, $smallCount) = @_;
	my @prev = @$previous;
	print "Visiting $node with previous of: @prev \n";
	push @prev, $node;

	if ($node eq "end") {
		print "FOUND PATH: @prev \n";
		$paths{(join ',', @prev)} = 1;
	} else {
		for (@{$nodes{$node}}) {
			my %trav = %$travelled;
			unless ($trav{"$node-$_"} || $_ eq "start") {
				if ($_ eq uc $_) {
					print " "x4 . "$node travelling to: $_ \n";
					$trav{"$node-$_"}++;
					visit($_, \@prev, \%trav, $small, $smallCount);
				} elsif (!$small || ($_ eq $small && $smallCount < 2)) {
					print " "x4 . "$node travelling to: $_ \n";
					$trav{"$node-$_"}++;
					$smallCount++;
					$trav{"$node-$_"} = 1;
					visit($_, \@prev, \%trav, $_, $smallCount);
				} elsif (!($_ ~~ @prev)) {
					print " "x4 . "$node travelling to: $_ \n";
					$trav{"$node-$_"}++;
					visit($_, \@prev, \%trav, $small, $smallCount);
				}

			}
		}
	}
}

