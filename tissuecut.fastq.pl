#!/usr/bin/perl
use strict;
use warnings;

my $gem_file = "gem.txt";
my $fastq_file = "reads.fastq";

# 读取gem文件，获取X_offset和Y_offset的值
my ($x_offset, $y_offset);
open(GEM, "<", $gem_file) or die "Cannot open gem.txt: $!";
while(<GEM>) {
    chomp;
    if(/^OffsetX=(\d+)/) {
        $x_offset = $1;
    } elsif(/^OffsetY=(\d+)/) {
        $y_offset = $1;
    }
}
close(GEM);

# 将X和Y这2列组合成"X_Y"记录在哈希表中
my %gem;
open(GEM, "<", $gem_file) or die "Cannot open gem.txt: $!";
while(<GEM>) {
    chomp;
    my ($gene, $x, $y, $count) = split(/\t/, $_);
    $gem{"${x}_${y}"} = 1;
}
close(GEM);

# 读取fastq文件，判断新的"X_Y"是否存在于gem文件中，如果存在，则输出完整的4行reads信息
open(FASTQ, "<", $fastq_file) or die "Cannot open reads.fastq: $!";
my ($id, $seq, $qual, $cx, $cy);
while(<FASTQ>) {
    chomp;
    if(/^@(.*?)\|Cx:i:(\d+)\|Cy:i:(\d+)/) {
        $id = $1;
        $cx = $2 - $x_offset;
        $cy = $3 - $y_offset;
    } elsif(/^([ACGTN]+)/) {
        $seq = $1;
    } elsif(/^\+$/) {
        $_ = <FASTQ>;
        chomp;
        $qual = $_;
        # 判断是否存在于gem文件中，存在则输出
        if(exists $gem{"${cx}_${cy}"}) {
            print "$id\n$seq\n+\n$qual\n";
        }
    }
}
close(FASTQ);