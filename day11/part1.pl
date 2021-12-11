#!/usr/bin/perl

use strict;

my @grid;
while (<>) {
	chomp;
	my @line;
	for (split '', $_) {
		push @line, $_;
	}
	push @grid, \@line;
}

print "-"x10 . "\n";
printGrid(\@grid);
print "-"x10 . "\n";

my $flashes = 0;
for my $step (1..100) {
	energize(\@grid);
	flashGrid(\@grid);
	resetFlashers(\@grid);

	print "-"x10 . "\n";
	printGrid(\@grid);
	print "-"x10 . "\n";
	print "After step $step we've had $flashes flashes\n\n";

	$step++;
}

sub energize {
	my $grid = shift;
	my ($y, $x) = (0, 0);
	for (@$grid) {
		for (@$_) {
			$grid->[$y][$x++]++;
		}
		$x = 0;
		$y++;
	}
}

sub flashGrid {
	my ($grid) = @_;
	my ($y, $x) = (0, 0);
	my %flashed = ();
	for (@$grid) {
		for (@$_) {
			flashLoc($y, $x, $grid, \%flashed) if ($_ > 9);
			$x++;
		}
		$x = 0;
		$y++;
	}
}

sub flashLoc {
	my ($y, $x, $grid, $flashed) = @_;
	unless ($flashed->{"$y$x"}) {
		$flashes++;
		$flashed->{"$y$x"} = 1;
		for my $yi (($y-1)..($y+1)) {
			for my $xi (($x-1)..($x+1)) {
				if ($yi >= 0 && $yi < @grid &&
						$xi >= 0 && $xi < @{@$grid[0]} &&
						($yi != $y || $xi != $x)) {
						$grid->[$yi][$xi]++;
						flashLoc($yi, $xi, $grid, $flashed) if ($grid->[$yi][$xi] > 9);
				}
			}
		}
	}
}

sub resetFlashers {
	my ($grid) = @_;
	my ($y, $x) = (0, 0);
	for (@$grid) {
		for (@$_) {
			$grid->[$y][$x] = 0 if ($_ > 9);
			$x++;
		}
		$x = 0;
		$y++;
	}
}

sub printGrid {
	for (@{@_[0]}) {
		for (@$_) {
			print;
		}
		print "\n";
	}
}
