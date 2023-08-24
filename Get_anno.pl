#!/usr/bin/perl

use strict;
use warnings;

# 读取输入文件
my ($input_file) = @ARGV;
open(my $fh, '<', $input_file) or die "无法打开文件 $input_file: $!";

# 读取表头
my $header = <$fh>;
chomp $header;
print "$header\n";

# 逐行读取数据并处理
while (my $line = <$fh>) {
    chomp $line;
    my @columns = split('\t', $line); # 假设表格以逗号分隔

    my $keep_row = 0; # 标记是否保留该行，默认为不保留

    # 检查除第一列外的其他列是否都为0
    for (my $i = 1; $i < scalar @columns; $i++) {
        if ($columns[$i] != 0) {
            $keep_row = 1; # 如果有非零值，则保留该行
            last;
        }
    }

    if ($keep_row) {
        print "$line\n"; # 输出保留的行
    }
}

# 关闭文件句柄
close($fh);