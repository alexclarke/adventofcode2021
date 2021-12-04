#!/usr/bin/perl

use strict;

package board;

my @input;
while (<>) {
    chomp;
    push @input, $_;
}

my @numbers = split(',', @input[0]);
my @boardInput = @input[1..$#input];
my @boards = loadBoards(\@boardInput);

print "\n" . "--- "x10 ."\nCalling numbers\n" . "--- "x10 ."\n";
for (@numbers) {
	callNumbers($_, \@boards);
	checkBoards(\@boards, $_);
}

### Sub-routines ###

sub callNumbers {
	my ($number, $boards) = @_;
	print "$number called\n"; 
	for (@$boards) {
		$_->mark($number);
	}
}

sub checkBoards {
	my ($boards, $lastNum) = @_;
	for (@$boards) {
		unless ($_->{done} eq "done") {
			if ($_->complete()) {
				print "WINNER: $_ with SCORE: ". $lastNum * $_->sumUnselected() ."\n";
			} else {
				print "INCOMPLETE BOARD: $_\n";
			}
		}
	}
	print "\n";
}

sub loadBoards {
	my $boardNew;
	my $boardsI = -1;
	my @boards;

	for (@{+shift}) {
		if ($_ eq '') {
			$boardNew = 1;
			$boardsI++;
		} else {
			push @boards, new("board") if ($boardNew);
			$boardNew = 0;
			$boards[$boardsI]->addRow($_);
		}
	}
	return @boards;
}


### Board sub-routines ### 

sub new {
	my ($class, $args) = @_;
	my $self = bless { rows => \() }, $class;
}

sub mark {
	my ($self, $number) = @_;
	for (@{$self->{rows}}) {
		for (@$_) {
			if ($_->{val} eq $number) {
				$_->{sel} = 1;
			}
		}
	}
}

sub addRow {
	my ($self, $row) = @_;
	my @row = ();
	for (split ' ', $row) {
		push @row, { sel => 0, val => $_ };
	}
	push(@{$self->{rows}}, \@row);
}

sub sumUnselected {
	my $self = shift;
	my $sum = 0;
	for (@{$self->{rows}}) {
		for (@$_) {
			$sum += $_->{val} unless $_->{sel};
		}
	}
	return $sum;
}

sub complete {
	my $self = shift;

	# ROWS
	for (@{$self->{rows}}) {
		my $rowComplete = 1;
		for (@$_) {
			$rowComplete = 0 unless ($_->{sel});
		}
		if ($rowComplete) {
			$self->{done} = "done";
			return $rowComplete;
		}
	}

	# COLUMNS
	my $index = 0;
	for (0..4) {
		my $columnComplete = 1;
		for (@{$self->{rows}}) {
			$columnComplete = 0 unless (@$_[$index]->{sel});
		}
		if ($columnComplete) {
			$self->{done} = "done";
			return $columnComplete;
		}
		$index++;
	}
}
