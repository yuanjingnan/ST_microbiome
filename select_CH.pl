#!/usr/bin/perl
use strict;
use warnings;


# 打开表格文件，读取文件内容，生成哈希表
open my $fh2, "<", $ARGV[1] or die "Can't open file: $!";
my $query_id = $ARGV[2];

my %table;
while (my $line = <$fh2>) {
    chomp $line;
    my ($sample, $species) = split /\t/, $line; 
    if ($sample eq $query_id) {
	    $species =~ s/ /_/g;
            $table{$species}=1;
        }
}
close $fh2;

open my $fh1, '<', $ARGV[0] or die "无法打开文件：$!";
my @table_a = <$fh1>;
close ($fh1);

foreach my $row (@table_a) {
    chomp $row;
    my @data = split /\t/, $row;
    my $key = $data[2];
    $key =~ s/ /_/g;
    if (exists $table{$key}) {
        print $row."\n";
    }
}

