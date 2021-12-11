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

while (<>) {
	chomp;
	$line++;
	my @stack;
	my $errorChar;

	for (split '', $_) {
		if ( $_ eq ')' || $_ eq ']' || $_ eq '}' || $_ eq '>') {
			my $removed = pop @stack;
			if (%braces{$_} ne $removed && !$errorChar) {
				print "-"x12 . "FOUND ERROR on line $line:\n";
				print "On: $_ , popped $removed\n";
				print "Stack: @stack\n\n\n";
				$errorChar = $_;
			}
		} elsif ($_ eq '(' || $_ eq '[' || $_ eq '{' || $_ eq '<') {
			push @stack, $_;
		}
	}

	$invalid{$errorChar}++;
	print "$line: STILL GOT STACK OF @stack\n";
}

print Dumper(\%invalid);

my $sum = ($invalid{')'} * 3) + ($invalid{']'} * 57) + ($invalid{'}'} * 1197) + ($invalid{'>'} * 25137);

print "Total: $sum\n";
