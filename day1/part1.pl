#!/usr/bin/perl
use strict;
use warnings;

my $current_depth = 20000;
my $increase_count = 0;
my $filename = 'input';

open(FH, '<', $filename) or die $!;

while(<FH>){
    $increase_count++ if ($_ > $current_depth);
    $current_depth = $_;
}

print $increase_count;
close(FH);