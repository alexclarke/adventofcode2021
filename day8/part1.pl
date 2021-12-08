#!/usr/bin/perl

use strict;

my @inputs;
while (<>) {
	my ($first, $second) = m/(.*)\|(.*)/;
	push @inputs, split(' ', $second);
}

print "IN: @inputs\n";

my $count;
for (@inputs) {
	if (length($_) == 2 || length($_) == 4 || length($_) == 3 || length($_) == 7) {
		$count++;
	}
}
	
	print "count: $count\n";
