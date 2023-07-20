#die "perl $0 <kraken.umi.lst> <offset_x> <offset_y>" if(@ARGV != 3);

my $offset_x = $ARGV[1];
my $offset_y = $ARGV[2];

open IP,"gzip -dc $ARGV[0]|";
while(<IP>){
	chomp;
	my @F = split /\t/;
	my $genu = $F[0];
	next if($genu  eq "");
	$F[2] =~ s/CB:Z://;
	my ($x,$y) = split /\_/,$F[2];
	#		print STDERR "$x\t$y\n";
	my $umi = $F[3];
	$umi =~ s/UR:Z://;
	$genu{$genu} = 1;
	$x = $x-$offset_x;
	$y = $y-$offset_y;
	$x = int($x/1)*1;
	$y = int($y/1)*1;
	my $coor = "$x\t$y";
	$count{$coor}{$genu}{$umi} = 1;
}


#print "geneID\txcoord\tycoord\tMIDCount\n";

for my $coor (sort keys %count){
	for my $genus (sort keys %{$count{$coor}}){
		#next unless (exists $count{$coor}{$genus});
		$n = scalar keys %{$count{$coor}{$genus}};
		#if(exists $ct{$coor}){
		#	$ct = $ct{$coor};
		#}
		#else{
		#	$ct = "Unknow";
		#}
		print "$genus\t$coor\t$n\n";
	}
}


