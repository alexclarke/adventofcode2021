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
	my $line = $_;
	print Dumper($line);

	my $Xinc = getInc($line->{"fromX"}, $line->{"toX"});
	my $Yinc = getInc($line->{"fromY"}, $line->{"toY"});
	print "increments $Xinc , $Yinc\n";
	drawLine($Xinc, $Yinc, $line, \@grid);

	printGrid(@grid);
}

sub drawLine {
	my ($incX, $incY, $line, $grid) = @_;
	my $currX = $line->{"fromX"};
	my $currY = $line->{"fromY"};
	print "Starting grid (with increments $incX , $incY) location $currX , $currY \n";
	do {
		#print "Incrementing grid location $currX , $currY \n";
		$grid[$currY]->[$currX]++;
		$currX += $incX;
		$currY += $incY;
	} until ($currX == ($line->{"toX"} + $incX) && $currY == ($line->{"toY"} + $incY));

}

sub getInc {
	my ($from, $to) = @_;
	if ($from > $to) {
		return -1;
	} elsif ($from < $to) {
		return 1;
	}
	return 0;
}

sub printGrid {
	my (@grid) = @_;
	my $overlap = 0;
	for (@grid) {
		for (@$_) {
			$overlap++ if ($_ > 1);
			if ($_ == 0) {
				#print '.';
			} else {
				#print;
			}
		}
		#print "\n";
	}
	print "\n" . "#"x11 . "\n";
	print "Overlaps: $overlap \n";

}

