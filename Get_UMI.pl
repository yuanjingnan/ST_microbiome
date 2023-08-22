#!/usr/bin/perl

use strict;
use warnings;


my ($input_file,$fa_file) = @ARGV;
open(INPUT1, "<", $input_file) or die "Cannot open $input_file: $!";

my %values_a;
while (my $line = <INPUT1>) {
    chomp $line;
    my ($value) = split /\t/, $line;
    $values_a{$value} = $line;
}
close $input_file;

my %values_b;
open(INPUT2, "<", $fa_file) or die "Cannot open $fa_file: $!";
while (my $line = <INPUT2>) {
    chomp $line;
    if ($line =~ /^>/){
        my ($value,$ID,$UMI) = split / /, $line;
        $value =~ s/>//g;
        if (exists $values_a{$value}) {
	    my $line1 = $values_a{$value};
	    my ($value1,$tax,$tax1) = split /\t/, $line1;
	    my ($value2,$x,$y) = split /\|/, $value1;
            my @strings = ($x,$y,$UMI);
	    my $result = join("|", @strings); 
            print "$result\t$tax\t$tax1\n";
            }
    }

}
close $fa_file;
