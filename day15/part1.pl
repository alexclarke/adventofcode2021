#!/usr/bin/perl

use strict;
use Data::Dumper;

my $table = getInput();

my %nodes;
my ($y, $x) = (0, 0);
for my $row (@$table) {
	for my $cell (@$row) {
		$nodes{"$y,$x"} = {};
		$x++;
	}
	$x = 0;
	$y++;
}

($y, $x) = (0, 0);
for my $row (@$table) {
	for my $cell (@$row) {
		if ($y > 0) {
			my $lowY = $y - 1;
			$nodes{"$lowY,$x"}->{"$y,$x"} = $cell; 
		}
		if ($x > 0) {
			my $lowX = $x - 1;
			$nodes{"$y,$lowX"}->{"$y,$x"} = $cell; 
		}
		if ($y < (scalar(@$table)-1)) {
			my $highY = $y + 1;
			$nodes{"$highY,$x"}->{"$y,$x"} = $cell; 
		}
		if ($x < (scalar(@$row)-1)) {
			my $highX = $x + 1;
			$nodes{"$y,$highX"}->{"$y,$x"} = $cell; 
		}
		$x++;
	}
	$x = 0;
	$y++;
}
print Dumper(\%nodes);

my ($costs, $prev) = dijkstra(\%nodes, "0,0");
print Dumper($costs);

my %prevShort;

my $node = "". (scalar(@$table)-1) .",". (scalar(@{@$table[0]})-1);
print "Cost for getting to dest: ". $costs->{$node} ."\n";
do {
	$prevShort{$node} = 1;
	$node = $prev->{$node};
} until ($node eq '0,0');


printGrid($table, \%prevShort);

sub dijkstra {
	my ($graph, $source) = @_;

	my %dist = ($source => 0);
	my %prev;

	my @q = ($source);  # All nodes initially in Q
	while (@q) {
		my $v = shift @q;
		my @a2q;
		for (keys %{$graph->{$v}}) {
			if ($dist{$_} != undef) {
				my $alt = $dist{$v} + $graph->{$v}->{$_};
				if ($alt < $dist{$_}) {
					$dist{$_} = $alt;
					$prev{$_} = $v;
				} 
			} else {
				push @q, $_;
				$dist{$_} = $dist{$v} + $graph->{$v}->{$_};
				$prev{$_} = $v;
			}
			@q = sort { ($dist{$a}) <=> ($dist{$b}) } @q;
		}
	}
	return \%dist, \%prev;
}

sub printGrid {
	my ($grid, $blanks) = @_;

	my ($y, $x) = (0, 0);
	for (@$grid) {
		for (@$_) {
			if ($blanks->{"$y,$x"}) {
				print '.';
			} else {
				print;
			}
			$x++;
		}
		$x = 0;
		$y++;
		print "\n";
	}
}

sub getInput() {
	my $tbl = [];
	while (<>) {
		chomp;
		my @line;
		push @line, $_ for (split '', $_);
		push @$tbl, \@line;
	}
	return $tbl;
}
