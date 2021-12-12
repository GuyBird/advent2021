#!/usr/bin/perl
use strict;
use warnings;

my $filename = 'input';

open(FH, '<', $filename) or die $!;
my @numbers = <FH>;
close(FH);

my $size = length($numbers[0]);
my @zero_count = (0) x $size;
my @one_count = (0) x $size;

for my $number (@numbers) {
    for my $index (0 .. $size - 2) {
        my $digit = substr $number, $index, 1;
        $zero_count[$index]++ if ($digit eq 0);
        $one_count[$index]++ if ($digit eq 1);
    }
}

my $gamma = "";
my $epsilon = "";
for my $index (0 .. $size - 2) {
    if ( $zero_count[$index] >  $one_count[$index]) {
        $gamma = $gamma . "0";
        $epsilon = $epsilon . "1";
    } else {
        $gamma = $gamma . "1";
        $epsilon = $epsilon . "0";
    }
} 

my $answer = eval("0b$gamma") * eval("0b$epsilon");
print $answer;