#!/usr/bin/perl

use strict;
my $days = shift;

my $in = <>;
chomp $in;
my @fish = split(',', $in);
print "Got @fish fish\n\n\n";

my $totalFish = 0;
my $reproductionPeriod = 6;

my %fishCountsFromAge = {};
my $fishInitialAge = 1;
for (1..10) {
	my $allFish = create($fishInitialAge, $days, 1);
	print "All fish for a fish aged $fishInitialAge is $allFish\n\n";
	$fishCountsFromAge{$fishInitialAge} = $allFish;
	$fishInitialAge++;
}

for (@fish) {
	$totalFish += $fishCountsFromAge{$_};
}

print "\n\n\nGot $totalFish fish\n";


sub create {
	my ($age, $toLive, $level) = @_;
	my $fishCount = 1;
	#print " - "x$level ."Creating fish with age $age and $toLive days to live, $level level\n";
	my $reduction = $age;

	while ($toLive > $reduction) {
		$toLive -= $reduction;
		$fishCount += create(8, $toLive-1, $level+1);
		$reduction = $reproductionPeriod+1;
	}

	return $fishCount;
}

