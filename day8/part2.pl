#!/usr/bin/perl

use strict;
use Data::Dumper;

my @inputs;
my @outputs;
while (<>) {
	my ($first, $second) = m/(.*)\|(.*)/;
	push @inputs, $first;
	push @outputs, $second;
}

my $i = 0;
my $count;
for (@inputs) {
	my $patterns = find($_);
	my $out;
	print "\n\n\nGOT PATTERNS ". Dumper($patterns) ."";
	for (split ' ', @outputs[$i++]) {
		my $sorted = join('', sort(split('', $_)));
		my $val = $patterns->{$sorted};
		$out .= $val;
		print "calculating is $out\n";
	}
	$count += $out;

}
	
print "count: $count\n";


sub find {
	my $index = shift;
	my %places;
	my %pat;
	my %num;
	for (split ' ', $index) {
		my $sorted = join('', sort(split('', $_)));
		if (length == 2) {
			$pat{$sorted} = 1; $num{1} = $sorted;
		} elsif (length == 4) {
			$pat{$sorted} = 4; $num{4} = $sorted;
		} elsif (length == 3) {
			$pat{$sorted} = 7; $num{7} = $sorted;
		} elsif (length == 7) {
			$pat{$sorted} = 8; $num{8} = $sorted;
		}
	}

	for (split ' ', $index) {
		my $sorted = join('', sort(split('', $_)));
		if (length == 6) {
			my $is4 = 0;
			my $is6 = 0;
			# 0 - Won't have 4
			for (split '', %num{4}) {
				if (index($sorted, $_) == -1) {
					$pat{$sorted} = 0; $num{0} = $sorted; $is4 = 1; last;
				}
			}
			
			# 6 - Won't have 1
			for (split '', %num{1}) {
				if (index($sorted, $_) == -1) {
					$pat{$sorted} = 6; $num{6} = $sorted; $is6 = 1; last;
				}
			}
			
			# 9 - must be nine if not already set
			$pat{$sorted} = 9 unless ($is4 || $is6);
		}
	}

	for (split ' ', $index) {
		my $sorted = join('', sort(split('', $_)));
		if (length == 5) {
			my $is3 = 1;
			my $is2 = 0;
			for (split '', %num{1}) {
				$is3 = $is3 && (index($sorted, $_) != -1)
			}
			if ($is3) {
				$pat{$sorted} = 3; $num{3} = $sorted; next;
			}
			for (split '', $sorted) {
				#print "------> checking $_ against ". $num{6} ."\n";
				if (index($num{6}, $_) == -1) {
					$pat{$sorted} = 2; $num{2} = $sorted; 
					$is2 = 1;
					last;
				}
			}
			# 5 - must be nine if not already set
			$pat{$sorted} = 5 unless ($is2 || $is3);
		}
	}
	return \%pat;
}
