#!/usr/bin/perl
use strict;
use warnings;

my $current_depth_sum= 20000;
my $increase_count = 0;
my $filename = 'input';

open(FH, '<', $filename) or die $!;
my @numbers = <FH>;
close(FH);

for (0 .. scalar @numbers- 3) {
    my $sum_value = $numbers[$_] + $numbers[$_ + 1] + $numbers[$_ + 2];
    
    $increase_count++ if ($sum_value > $current_depth_sum);
    $current_depth_sum = $sum_value;
}

print $increase_count;