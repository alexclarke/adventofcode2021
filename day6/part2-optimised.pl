#!/usr/bin/perl
use strict;

my $days = shift;
my @fish = split(',', <>);

my @live = (0) x 9;
@live[$_]++ for (@fish) ;

until ($days-- == 0) {
		push @live, my $births = shift @live;
		@live[6] += $births;
}

my $totalFish = 0;
$totalFish += $_ for (@live) ;
print "\n\n\n$totalFish fish alive\n";
