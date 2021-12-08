#!/usr/bin/perl

use strict;

my @subs = split(',', <>);

sort(@subs);
my $midPoint = scalar @subs / 2;
my $avg = @subs[$midPoint];

print "got $avg at $midPoint, for ". scalar @subs ."\n";

my $lowestFuelSpend = nav($avg);
my $newLowest;
do {
	$avg++;
	$newLowest = nav($avg);
	if ($newLowest < $lowestFuelSpend) {
		$lowestFuelSpend = $newLowest;
	}
} while ($avg < @subs[scalar @subs-1]);

$avg = $midPoint;
do {
	$avg--;
	$newLowest = nav($avg);
	if ($newLowest < $lowestFuelSpend) {
		$lowestFuelSpend = $newLowest;
	}
} while ($avg > 0);

sub nav {
	my $to = shift;
	my $fuelSpend = 0;
	for (@subs) {
		chomp;
		my $fuel = 0;
		if ($_ > $to) {
			$fuel += ($_ - $to);
		} elsif ($_ < $to) {
			$fuel += ($to - $_);
		}
		print "On $_ with total fuel spend of $fuel\n";
		$fuelSpend += $fuel;
	}
	return $fuelSpend;
}

print "Total $lowestFuelSpend\n";
