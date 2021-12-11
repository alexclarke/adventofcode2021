#!/usr/bin/perl

use strict;
use Data::Dumper;

my %braces = ('[' => ']',
							']' => '[',
							'(' => ')',
							')' => '(',
							'{' => '}',
							'}' => '{',
							'<' => '>',
							'>' => '<');

my %invalid = ( ']' => 0, ')' => 0, '}' => 0, '>' => 0);
my $line = 0;
my @scores;
my %score = ( ']' => 2, ')' => 1, '}' => 3, '>' => 4);

while (<>) {
	chomp;
	$line++;
	my @stack;
	my $errorChar;

	for (split '', $_) {
		if ( $_ eq ')' || $_ eq ']' || $_ eq '}' || $_ eq '>') {
			my $removed = pop @stack;
			$errorChar = $_ if (%braces{$_} ne $removed && !$errorChar);
		} elsif ($_ eq '(' || $_ eq '[' || $_ eq '{' || $_ eq '<') {
			push @stack, $_;
		}
	}

	$invalid{$errorChar}++;
	print "$line: STILL GOT STACK OF @stack\n";
	unless ($errorChar) {
		print "$line: WORKING @stack\n";
		my $comScore = 0;
		my @completion;
		while (@stack) {
			my $val = pop @stack;
			$comScore = $comScore * 5;
			$comScore += $score{%braces{$val}};
		}
		push @scores, $comScore;
	}
}

my @sorted = sort { $a <=> $b } @scores;
print Dumper(\@sorted);

print "Total: ". @sorted[scalar @sorted / 2];
