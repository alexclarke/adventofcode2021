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

print "Got ". (scalar @grid * scalar @{@grid[0]}) ." dumbo octopuses\n";
print "-"x10 . "\n";
printGrid(\@grid);
print "-"x10 . "\n";

my $flashes = 0;
my $step = 0;
while (++$step) {

	energize(\@grid);
	flashGrid(\@grid);
	resetFlashers(\@grid);

	print "-"x10 . "\n";
	printGrid(\@grid);
	print "-"x10 . "\n";
	print "After step $step we've had $flashes flashes\n\n";
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
	die "THEY ALL FLASHED\n" if (keys %flashed == 100);
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
						if ($grid->[$yi][$xi] > 9) {
							flashLoc($yi, $xi, $grid, $flashed);
						}
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
			if ($_ > 9) {
				$grid->[$y][$x] = 0;
			}
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
