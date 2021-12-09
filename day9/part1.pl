#!/usr/bin/perl


my $result = 0;

my @rray;

while (<>) {
	chomp;
	my @y;
	for (split "", $_) {
		push @y, $_;
	}
	push @rray, \@y;
}

my $x =0;
my $y =0;

my @lows;

for (@rray) {
	for (@$_) {
		my $checkPreY = 1;
		my $checkPreX = 1;
		my $checkPostY = 1;
		my $checkPostX = 1;
		if ($y == 0) {
			$checkPreY = 0;
		}
		if ($x == 0) {
			$checkPreX = 0;
		} 
		if ($y == scalar @rray-1) {
			$checkPostY = 0;
		}
		if ($x == scalar(@{@rray[0]})-1) {
			$checkPostX = 0;
		} 
		print "On $_ , with $checkPreY,  $checkPreX, $checkPostY, $checkPostX\n";
		if ((!$checkPreY || $_ < $rray[$y-1]->[$x])
				&& (!$checkPostX || $_ < $rray[$y]->[$x+1])
				&& (!$checkPostY || $_ < $rray[$y+1]->[$x])
				&& (!$checkPreX || $_ < $rray[$y]->[$x-1])) {
				print "LP";
				push @lows, $_ + 1;
		}



		$x++;
	}
	print "\n";

	$x = 0;
	$y++;
}

print "@lows\n";
$result += $_ for (@lows);


print "Result: $result\n";
