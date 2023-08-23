use strict;
use warnings;

my ($input_file,$output_file) = @ARGV;

# Read input file
open my $fh_in, "<", $input_file or die "Could not open $input_file: $!";
my @lines = <$fh_in>;
close $fh_in;

# Sort and remove duplicates
my @sorted_lines = sort @lines;
my @unique_lines = do {
    my %seen;
    grep { !$seen{$_}++ } @sorted_lines;
};

# Write output file
open my $fh_out, ">", $output_file or die "Could not open $output_file: $!";
print $fh_out @unique_lines;
close $fh_out;