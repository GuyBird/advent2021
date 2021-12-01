#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $current_depth_sum= 20000;
my $increase_count = 0;
my $filename = 'day1_input';

open(FH, '<', $filename) or die $!;
my @numbers = <FH>;
close(FH);

my $numbers_length = @numbers; 

for my $current_sum (0 .. $numbers_length - 3) {
    my $sum_value = $numbers[$current_sum] + $numbers[$current_sum + 1] + $numbers[$current_sum + 2];
    
    $increase_count++ if ($sum_value > $current_depth_sum);
    $current_depth_sum = $sum_value;
}

print $increase_count;