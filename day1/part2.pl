#!/usr/bin/perl

my @data = <>;
my $count = 0;

for (3..scalar @data) {
	$first = @data[$_-1] + @data[$_-2] + @data[$_-3];
	$second = @data[$_] + @data[$_-1] + @data[$_-2];
	$count++ if ($second > $first);
}

print "$count \n";
