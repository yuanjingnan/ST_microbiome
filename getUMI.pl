open IA,"gzip -dc $ARGV[0]|";
while(<IA>){
	chomp;
	my @F = split /\t/;
	$info{$F[0]} = "$F[2]\t$F[1]";
}

open IB,"gzip -dc $ARGV[1]|";
while(<IB>){
	chomp;
	my @F = split /\|\|\|/;
	$F[0] =~ s/^@//;
	next unless (exists $info{$F[0]});
	print "$info{$F[0]}\t$F[1]\t$F[2]\t$F[0]\n";
}

