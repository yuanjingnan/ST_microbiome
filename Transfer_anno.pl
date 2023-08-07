#!/usr/bin/perl

# 打开gem.txt、table和输出文件
open my $gem_fh, '<', $ARGV[0] or die "无法打开文件：$!";
open my $table_fh, '<', $ARGV[1] or die "无法打开文件：$!";
my $bin_size = $ARGV[2];
# 从gem.txt文件中提取X_offset和Y_offset
my $X_offset = 0;
my $Y_offset = 0;
my %xy_hash;
while (my $line = <$gem_fh>) {
    chomp $line;
    # 使用正则表达式提取X_offset和Y_offset的值
    if ($line =~ /^#OffsetX=(\d+)/) {
        $X_offset = $1;
    } elsif ($line =~ /^#OffsetY=(\d+)/) {
        $Y_offset = $1;
    }
    if ($line =~ /^(\S+)\s+(\d+)\s+(\d+)/) {
    my $X = $2;
    $X = int($X/$bin_size)*$bin_size;
    my $Y = $3;
    $Y = int($Y/$bin_size)*$bin_size;
    my $key = "${X}_${Y}";
    $xy_hash{$key} = 1;
    }
}
 

# 处理table文件，进行计数统计并输出结果
my %count_hash;
while (my $line = <$table_fh>) {
    chomp $line;
    # 将每行数据分割成三个字段
    my ($coord_str, $MIDCount, $CH) = split("\t", $line);
    $CH =~ s/\s+/_/g;
    # 使用正则表达式从第一个字段中提取Cx和Cy的值
    #
    my ($Cx) = ($coord_str =~ /Cx:i:(\d+)/);
    my ($Cy) = ($coord_str =~ /Cy:i:(\d+)/);
    # 计算得到与gem.txt文件中所使用的X、Y对应的新X和新Y的值
    my $X = $Cx - $X_offset;
    $X = int($X/$bin_size)*$bin_size;
    my $Y = $Cy - $Y_offset;
    $Y = int($Y/$bin_size)*$bin_size;
    my $key = "${X}_${Y}_${CH}";
    # 将组合键的计数器加1
    $count_hash{$key}++;
}

# 获取X_Y和CH的唯一值列表，以及X_Y_CH组合的个数，并统计在键值对hash表中
my %unique_xy;
my %unique_ch;
my %xy_ch_count;
foreach my $ch (sort keys %count_hash) {
    if ($ch =~ /^(\d+)_(\d+)_(\S+)$/) {
        my $xy = "${1}_${2}";
        my $count = $count_hash{$ch};
        $unique_ch{$3} = 1;
        $unique_xy{$xy} = 1;      
        unless (exists $xy_ch_count{"$xy\t$3"}) {
            $xy_ch_count{"$xy\t$3"} = $count;
        } else {
            $xy_ch_count{"$xy\t$3"} += $count;
        }
    }
}

# 关闭文件句柄
close $gem_fh;
close $table_fh;

print  "X_Y\t";
foreach my $ch (sort keys %unique_ch) {
        print "$ch\t";
}
print  "Total\n";


my %output_hash;
my @xy_order = sort keys %xy_hash;
#print @xy_order;
foreach my $xy (@xy_order) {
    print "$xy\t";
    if (exists $unique_xy{$xy}) {
        $output_hash{$xy}{"Total"} = 0;
        foreach my $ch (sort keys %unique_ch) {
            my $count = exists $xy_ch_count{"$xy\t$ch"} ? $xy_ch_count{"$xy\t$ch"} : 0;
            print "$count\t";
            $output_hash{$xy}{$ch} = $count;
            $output_hash{$xy}{"Total"} += $count;
        }
        print "$output_hash{$xy}{'Total'}\n";
    }
    # 不存在于哈希表中的X_Y输出一整行0
    else {
        print  "0\t" x (scalar(keys %unique_ch) + 1) . "\n";
    }
}
