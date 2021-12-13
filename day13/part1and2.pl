#!/usr/bin/perl

use strict;

my @coords = ();
my @folds = ();

my ($maxX, $maxY) = getInstructions(\@coords, \@folds);
my $grid = [(map { [('.') x $maxX] }(1..$maxY) )];
$grid->[$_->{'y'}]->[$_->{'x'}] = '#' for (@coords);

print "BEGIN:\n";
my $beforeCount = printGrid($grid);

for (@folds) {
	my ($axis, $from) = m/([xy])=(\d+)/;
	$grid = fold($axis, $from, $grid);
	print "AFTER fold $_:\n";
	my $afterCount = printGrid($grid);
	print "TOTAL remaining dots: $afterCount\n\n\n";
}

sub fold {
	my ($axis, $from, $grid) = @_;
	my @folded;

	if ($axis eq 'y') {
		@folded = @$grid[0..$from-1];
		for my $foldY ($from+1..$maxY-1) {
			for my $foldX (0..$maxX-1) {
				if ($grid->[$foldY]->[$foldX] eq '#') {
					my $newY = abs($from+($from-$foldY));
					@folded[$newY]->[$foldX] = '#';
				}
			}
		}
	} elsif ($axis eq 'x') {
		@folded = map { my @toSplice = @$_; [splice @toSplice, 0, $from]; } @$grid;
		for my $foldY (0..$maxY-1) {
			for my $foldX ($from+1..$maxX-1) {
				if ($grid->[$foldY]->[$foldX] eq '#') {
					my $newX = abs($from+($from-$foldX));
					@folded[$foldY]->[$newX] = '#';
				}
			}
		}
	}
	return \@folded;
}

sub printGrid {
	print "-"x100 ."\n";
	my $count = 0;
	for (@{@_[0]}) {
		for (@$_) {
			print;
			$count ++ if ($_ eq '#');
		}
		print "\n";
	}
	return $count;
}

sub getInstructions {
	my ($coords, $folds) = @_;
	my ($maxX, $maxY) = (0, 0);
	while (<>) {
		chomp;
		if (m/fold along/) {
			push @$folds, m/fold along (.*)/;
		} elsif ($_) {
			my ($x, $y) = m/(\d+),(\d+)/;
			push @$coords, { "x" => $x, "y" => $y };
			$maxX = $x if ($x > $maxX);
			$maxY = $y if ($y > $maxY);
		}
	}
	return ($maxX+1, $maxY+1);
}
