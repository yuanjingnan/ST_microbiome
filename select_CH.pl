#!/usr/bin/perl

use strict;
use warnings;

# 读取表格a
open my $fh1, '<', $ARGV[0] or die "无法打开文件：$!";
my @table_a = <$fh1>;
close ($fh1);

# 读取表格b
open my $fh2, "<", $ARGV[1] or die "Can't open file: $!";
my %table_b;
while (<$fh2>) {
    chomp;
    $table_b{$_} = 1;
}
close ($fh2);

# 提取表格a中与表格b相同值的行
foreach my $row (@table_a) {
    chomp $row;
    my @data = split /\t/, $row;
    my $key = (split /_/, $data[2])[0];
    if ($table_b{$key}) {
        print $row."\n";
    }
}
