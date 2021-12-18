#!/usr/bin/perl
use strict;
use Data::Dumper;
use experimental 'smartmatch';

my %nodes = ();

while (<>) {
	chomp;
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

print Dumper(\%nodes);

my %vertexes = {};
my %paths = {};

visit("start", [], {}, {});

sub visit {
	my ($node, $previous, $travelled, $small) = @_;
	my @prev = @$previous;
	print "Visiting $node with previous of: [ @prev ] \n";

	push @prev, $node;
	if ($node eq 'end') {
		print "FOUND PATH: @prev \n";
		$paths{(join ',', @prev)} = 1;
		return;
	}
	for (@{$nodes{$node}}) {
		next if ($_ eq 'start');
		print " "x4 . "$node travelling to: $_ \n";
		my %trav = %$travelled;
		my %sml = %$small;
		if ($_ eq uc $_ || $_ eq 'end') {
			$trav{"$node-$_"} = 1;
			visit($_, \@prev, \%trav, \%sml);
		} else {
			if ($sml{$_}) {
				$sml{$_}++;
			} else {
				$sml{$_} = 1;
			}
			if (singleSmallVisit(\%sml, $_)) {
				$trav{"$node-$_"} = 1;
				visit($_, \@prev, \%trav, \%sml) ;
			}
		}
	}
}

sub singleSmallVisit {
	my ($small, $node) = @_;
	my $numOverOne = 0;
	for (keys %$small) {
		$numOverOne++ if ($small->{$_} > 1);
	}
	if ($small->{$node} == 2 && $numOverOne == 1) {
		return 1;
	} elsif ($small->{$node} == 1) {
		return 1;
	}
	return 0;
}

