#!/usr/bin/perl

use strict;
use Data::Dumper;

my $maxX =0;
my $maxY =0;

my @lines;
while (<>) {
	chomp;
	my ($fromX, $fromY, $toX, $toY) = m#(\d+),(\d+) -> (\d+),(\d+)#;
	$maxX = $fromX if ($fromX > $maxX);
	$maxX = $toX if ($toX > $maxX);
	$maxY = $fromY if ($fromY > $maxY);
	$maxY = $toY if ($toY > $maxY);
	my %coords = (
		"fromX" => $fromX,
		"fromY" => $fromY,
		"toX" => $toX,
		"toY" => $toY
	);
	push @lines, \%coords;
}
print "hash ". scalar @lines ."\n";
print "maxX: $maxX, maxY: $maxY \n";

my @grid;
push @grid, [(0) x$maxX] for (0..$maxY);

for (@lines) {
	my %line = %$_;
	print Dumper(\%line);
	if (%line{"fromX"} ne %line{"toX"} && %line{"fromY"} eq %line{"toY"}) {
		if (%line{"fromX"} < %line{"toX"}) {
			drawLine(1, 0, \%line, \@grid);
		} else {
			drawLine(-1, 0, \%line, \@grid);
		}
	} elsif (%line{"fromX"} eq %line{"toX"} && %line{"fromY"} ne %line{"toY"}) {
		if (%line{"fromY"} < %line{"toY"}) {
			drawLine(0, 1, \%line, \@grid);
		} else {
			drawLine(0, -1, \%line, \@grid);
		}
	}
	printGrid(@grid);
}

sub drawLine {
	my ($incX, $incY, $line, $grid) = @_;
	my $currX = $line->{"fromX"};
	my $currY = $line->{"fromY"};
	print "Starting grid (with increments $incX , $incY) location $currX , $currY \n";
	if ($incX != 0) {
		do {
			print "Incrementing grid location $currX , $currY \n";
			$grid[$currY]->[$currX]++;
			$currX += $incX;
		} until ($currX == ($line->{"toX"} + $incX));
	}
	if ($incY != 0) {
		do {
			print "Incrementing grid location $currX , $currY \n";
			$grid[$currY]->[$currX]++;
			$currY += $incY;
		} until ($currY == ($line->{"toY"} + $incY));
	}

}

sub printGrid {
	my (@grid) = @_;
	my $overlap = 0;
	for (@grid) {
		for (@$_) {
			$overlap++ if ($_ > 1);
			if ($_ == 0) {
				print '.';
			} else {
				print;
			}
		}
		print "\n";
	}
	print "\n" . "#"x11 . "\n";
	print "Overlaps: $overlap \n";

}

