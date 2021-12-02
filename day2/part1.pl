#!/usr/bin/perl


my $horizontal = 0;
my $depth = 0;

while (<>) {
	my ($direction, $value) = m/(\w+)\s+(\d+)/;
	if ($direction eq "forward") {
		$horizontal += $value;
	} elsif ($direction eq "up") {
		$depth -= $value;
	} elsif ($direction eq "down") {
		$depth += $value;
	}
}

print "horizontal: $horizontal, depth: $depth \n";
print "result: ". $horizontal * $depth . "\n";
