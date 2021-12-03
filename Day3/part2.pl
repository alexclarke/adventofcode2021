#!/usr/bin/perl

my @input;
while (<>) {
	chomp;
	my @line = split('', $_);
	push @input, \@line;
}

my $fO = \@input;
my $fI = 0;
print "START WITH ". scalar @fO . "\n";
until (scalar(@$fO) == 1) {
	$fO = filter($fO, $fI, '1', '0');
	$fI++;
}

my $fC = \@input;
my $fJ = 0;
print "START WITH ". scalar @fC . "\n";
until (scalar(@$fC) == 1) {
	$fC = filter($fC, $fJ, '0', '1');
	$fJ++;
}
my $x_num;
my $y_num;
for (@$fO) {
	print "fO:  @$_ \n";
	$x_num = oct("0b" . join('', @$_));
	print "xnum $x_num \n";
}
for (@$fC) {
	print "fC:  @$_ \n";
	$y_num = oct("0b" . join('', @$_));
}
print $x_num * $y_num;

sub filter {
	my ($in, $index, $high, $low) = @_;
	my @local_input = @$in;
	my @local_counts = most($in, $high);
	printLines(@local_input);

	my $local_count = @local_counts[$index];
	print "LOC COUNT : $local_count \n";
	print "MID : " . (scalar @local_input / 2) ."\n";
	my $common = ( $local_count > ((scalar @local_input) / 2)) ? $high : $low; 

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
