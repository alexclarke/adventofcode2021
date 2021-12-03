#!/usr/bin/perl
#

#011111101110

my @aa;
my $lines = 0;

while (<>) {
	$lines++;
	chomp;
	my $len = length($_);
	@aa = (0)x$len unless @aa;
	my @line = split('', $_);
	print "LINE: @line\n";
	print "LINE: ". scalar @line ."\n";

	my $i = 0;
	for (@line) {  
		#print "On: $_ at $i \n";
		@aa[$i] += $_;
		$i++;
	}
}

print "@aa\n";

my $xbin = '';
for (@aa) {
	if ($_ > 0) {
		if ($_ > ($lines /2)) {
			$xbin .= '1';
		} else {
			$xbin .= '0';
		}
	}

}
print "X: $xbin\n";
$x_num = oct("0b" . $xbin);
print "$x_num\n";


my $ybin = '';
for (@aa) {
	if ($_ > 0) {
	if ($_ > ($lines /2)) {
		$ybin .= '0';
	} else {
		$ybin .= '1';
	}
}

}
print "Y: $ybin\n";
$y_num = oct("0b" . $ybin);
print "$y_num\n";

print $x_num * $y_num;
