#!/usr/bin/perl

use strict;

my $in = <>;
chomp $in;
my @fish = split(',', $in);
print "Got @fish fish\n\n\n";

my $day = 1;
for (1..80) {
	my $i = 0;
	for (@fish) {
		if ($_ == 0) {
			@fish[$i] = 6;
			push @fish, 9;
		} else {
			@fish[$i]--;
		}
		$i++;
	}
	print "Day $day has ". scalar @fish ." fish \n";
	$day++;
}
print "\n\n\nGot ". scalar @fish ." fish\n";


