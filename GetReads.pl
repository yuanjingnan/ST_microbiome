#die "perl $0 <kraken mpa> <kraken report> <kraken table>" if(@ARGV != 3);

open IB,$ARGV[0];
while(<IB>){
	chomp;
	my @F = split /\t/;
	next unless($F[5] =~ /G|S/);
    my $taxid= $F[6];
    my $genus = $F[7];
    $genus =~ s/^\s+//;
    $genus{$taxid} = $genus;
	next if($F[6]==9605 || $F[6] == 9606);
	$kraken{$F[6]}= 1;
}

open IC,$ARGV[1];
while(<IC>){
	chomp;
	my @F=split /\t/;
	($taxid) = $F[2] =~ /taxid (\d+)/;
	next unless (exists $kraken{$taxid});
	print "$F[1]\t$taxid\t$genus{$taxid}\n";
}
