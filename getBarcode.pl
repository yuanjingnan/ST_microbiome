open IB,$ARGV[0];
while(<IB>){
	chomp;
	next unless ($_ =~ /^@/);
	my($reads,$bar,$umi) = split /\s+/;
    my($reads1,$x_raw,$y_raw) = split /\|/,$reads;
    my($x1,$x2,$x) = split /:/,$x_raw;
    my($y1,$y2,$y) = split /:/,$y_raw;
    print "$reads1|||CB:Z:$x\_$y|||UR:Z:$umi\n";
}
