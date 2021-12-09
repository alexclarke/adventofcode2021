#!/usr/bin/perl
use strict;
use Data::Dumper;

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

my @basins;

for (@rray) {
	for (@$_) {
		my $checkPreY = ($y == 0) ? 0: 1;
		my $checkPreX = ($x == 0) ? 0: 1;
		my $checkPostY = ($y == scalar @rray-1) ? 0: 1;
		my $checkPostX = ($x == scalar(@{@rray[0]})-1) ? 0: 1;
		if ((!$checkPreY || $_ < $rray[$y-1]->[$x])
				&& (!$checkPostX || $_ < $rray[$y]->[$x+1])
				&& (!$checkPostY || $_ < $rray[$y+1]->[$x])
				&& (!$checkPreX || $_ < $rray[$y]->[$x-1])) {
				my $bt = basin($x, $y, \@rray);
				print "Got basin total $bt\n\n\n";
				push @basins, $bt;
		}
		$x++;
	}
	$x = 0;
	$y++;
}

my @bas = reverse(sort({ $a <=> $b } @basins));
print "@bas\n";
$result = @bas[0] * @bas[1] * @bas[2];
print "Result: $result\n";

sub basin {
	my ($x, $y, $grid) = @_;

	print "BASIN: $x, $y\n";

	my %coords = ( "$y$x" => 1);
	my @bCan= ( {"x" => $x+1, "y" => $y, "from" => $grid->[$y]->[$x]},
							{"x" => $x-1, "y" => $y, "from" => $grid->[$y]->[$x]},
							{"x" => $x, "y" => $y+1, "from" => $grid->[$y]->[$x]},
							{"x" => $x, "y" => $y-1, "from" => $grid->[$y]->[$x]});
	do {{
		my $can = shift @bCan;
		my $canY = $can->{"y"};
		my $canX = $can->{"x"};
		next if ($canX >= scalar(@{@rray[0]}) || $canX < 0 || $canY >= scalar @rray || $canY < 0);

		my $canFrom = $can->{"from"};
		if ($grid->[$canY]->[$canX] < 9 && $grid->[$canY]->[$canX] > $canFrom) {
			$coords{"$canY$canX"} = 1;
			push @bCan, {"x" => $canX+1, "y" => $canY, "from" => $grid->[$canY]->[$canX]} unless $coords{"".$canY . $canX+1};
			push @bCan, {"x" => $canX-1, "y" => $canY, "from" => $grid->[$canY]->[$canX]} unless $coords{"".$canY . $canX-1};
			push @bCan, {"x" => $canX, "y" => $canY+1, "from" => $grid->[$canY]->[$canX]} unless $coords{"".$canY+1 . $canX};
			push @bCan, {"x" => $canX, "y" => $canY-1, "from" => $grid->[$canY]->[$canX]} unless $coords{"".$canY-1 . $canX};
		}
	}} while(@bCan);
	print "\n". printBasin(\%coords) ."\n";
	print "-"x120 ."\n";
	return keys %coords;
}

sub printBasin {
	my $basin = shift;

	my $x =0;
	my $y =0;
	for (@rray) {
		for (@$_) {
			if ($basin->{"$y$x"}) {
				print $basin->{"$y$x"};
			} else {
				print ".";
			}
			$x++;
		}
		$x = 0;
		$y++;
		print "\n";
	}


}
