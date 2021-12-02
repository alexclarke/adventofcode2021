#!/usr/bin/perl


my $horizontal = 0;
my $depth = 0;
my $aim = 0;

while (<>) {
	my ($direction, $value) = m/(\w+)\s+(\d+)/;
	if ($direction eq "forward") {
		$horizontal += $value;
		$depth += ($aim * $value);
	} elsif ($direction eq "up") {
		$aim -= $value;
	} elsif ($direction eq "down") {
		$aim += $value;
	}
}

print "horizontal: $horizontal, depth: $depth \n";
print "result: ". $horizontal * $depth . "\n";
