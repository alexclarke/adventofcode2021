#!/usr/bin/perl

my @input;
while (<>) {
	chomp;
	my @line = split('', $_);
	push @input, \@line;
}

my $fO = \@input;
my $fI = 0;
until (scalar(@$fO) == 1) {
	$fO = filter($fO, $fI, '1');
	$fI++;
}
my $fOres = oct("0b" . join('', @{@$fO[0]}));

my $fC = \@input;
my $fJ = 0;
until (scalar(@$fC) == 1) {
	$fC = filter($fC, $fJ, '0');
	$fJ++;
}
my $fCres = oct("0b" . join('', @{@$fC[0]}));

print "Result: ". $fOres * $fCres ."\n";

### Subroutines ###

sub filter {
	my ($in, $index, $high) = @_;
	my @local_input = @$in;
	my @local_counts = most($in, $high);
	printLines(@local_input);

	my $local_count = @local_counts[$index];
	print "LOC COUNT : $local_count \n";
	print "MID : " . (scalar @local_input / 2) ."\n";
	my $common;
	if ($high eq '0') {
		$common = ( $local_count <= ((scalar @local_input) / 2)) ? 0 : 1; 
	} else {
		$common = ( $local_count >= ((scalar @local_input) / 2)) ? 1 : 0; 
	}

	print "Local counts : @local_counts \n";
	print "Filtering local input of ". scalar @local_input ." items \n";
	print "Index $index got $common \n\n";
	my $k = 0;
	my @new;
	for (@local_input) {
		if ($_->[$index] eq $common) {
			push @new, $_;
		}
		$k++;
	}
	print "Returning local input of ". scalar @new . " items \n";
	return \@new;
}

sub most {
	my ($in, $high) = @_;
	my @counts;
	for (@$in) {
		my $len = scalar @$_;
		@counts = (0)x$len unless @counts;

		my $i = 0;
		for (@$_) {  
			#print "On: $_ at $i \n";
			@counts[$i]++ if ($high eq $_);
			$i++;
		}
	}
	return @counts;
}

sub printLines {
	for (@_) {
		print "[@$_] ";
	}
	print "\n";
}
